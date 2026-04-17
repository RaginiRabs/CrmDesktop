import { useState, useEffect, useRef, useCallback } from 'react';
import { Search, Bell, Fingerprint, LogIn, LogOut, X, Camera, RotateCcw, MapPin, Clock, CheckCircle, AlertCircle } from 'lucide-react';
import { apiFetch } from '../../utils/api';
import { useToast } from '../../context/ToastContext';
import { requestNotificationPermission, onForegroundMessage } from '../../services/firebase';
import './Header.css';

const Header = ({ title, subtitle, actions }) => {
  const { showToast } = useToast();
  const [searchOpen, setSearchOpen] = useState(false);

  // ── Notification State ──
  const [notifOpen, setNotifOpen] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const notifRef = useRef(null);

  // ── Attendance State ──
  const [isPunchedIn, setIsPunchedIn] = useState(false);
  const [activeSession, setActiveSession] = useState(null);
  const [elapsedTime, setElapsedTime] = useState(null);
  const [showCameraModal, setShowCameraModal] = useState(false);
  const [cameraType, setCameraType] = useState('punchIn');
  const [capturedImage, setCapturedImage] = useState(null);
  const [submitting, setSubmitting] = useState(false);
  const videoRef = useRef(null);
  const canvasRef = useRef(null);
  const streamRef = useRef(null);

  // ── Fetch notifications ──
  const fetchNotifications = useCallback(async () => {
    try {
      const res = await apiFetch('notifications');
      if (res.success) {
        setNotifications(res.data?.notifications?.slice(0, 10) || []);
        setUnreadCount(res.data?.unreadCount || 0);
      }
    } catch (e) {}
  }, []);

  // ── Fetch attendance status ──
  const fetchAttendance = useCallback(async () => {
    try {
      const res = await apiFetch('attendance/today');
      if (res.success) {
        setIsPunchedIn(res.data?.isPunchedIn || false);
        setActiveSession(res.data?.activeSession || null);
      }
    } catch (e) {}
  }, []);

  useEffect(() => {
    fetchNotifications();
    fetchAttendance();
    setupPushNotifications();
    const interval = setInterval(fetchNotifications, 30000);
    return () => clearInterval(interval);
  }, []);

  // ── Setup FCM push notifications ──
  const setupPushNotifications = async () => {
    try {
      const token = await requestNotificationPermission();
      if (token) {
        // Send token to backend to register this browser
        await apiFetch('auth/device-token', {
          method: 'POST',
          body: JSON.stringify({ device_token: token, device_platform: 'web' }),
        }).catch(() => {});
      }

      // Listen for foreground messages
      onForegroundMessage((payload) => {
        const { title, body } = payload.notification || {};
        // Show browser notification
        if (title && Notification.permission === 'granted') {
          new Notification(title, { body: body || '', icon: '/logo192.png' });
        }
        // Refresh notification count
        fetchNotifications();
        showToast(title || 'New notification', 'info');
      });
    } catch (err) {
      console.log('[FCM] Setup error:', err);
    }
  };

  // ── Elapsed timer (updates every second) ──
  useEffect(() => {
    if (!isPunchedIn || !activeSession?.punch_in_time) { setElapsedTime(null); return; }
    const update = () => {
      const diff = Date.now() - new Date(activeSession.punch_in_time).getTime();
      const h = Math.floor(diff / 3600000);
      const m = Math.floor((diff % 3600000) / 60000);
      const s = Math.floor((diff % 60000) / 1000);
      setElapsedTime(`${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`);
    };
    update();
    const t = setInterval(update, 1000);
    return () => clearInterval(t);
  }, [isPunchedIn, activeSession]);

  // ── Close dropdowns on outside click ──
  useEffect(() => {
    const handler = (e) => {
      if (notifRef.current && !notifRef.current.contains(e.target)) setNotifOpen(false);
    };
    document.addEventListener('mousedown', handler);
    return () => document.removeEventListener('mousedown', handler);
  }, []);

  // ── Notification actions ──
  const markAsRead = async (nId) => {
    await apiFetch(`notifications/${nId}/read`, { method: 'PUT' });
    setNotifications(prev => prev.map(n => n.n_id === nId ? { ...n, is_read: 1 } : n));
    setUnreadCount(prev => Math.max(0, prev - 1));
  };

  const markAllRead = async () => {
    await apiFetch('notifications/read-all', { method: 'PUT' });
    setNotifications(prev => prev.map(n => ({ ...n, is_read: 1 })));
    setUnreadCount(0);
  };

  const timeAgo = (dt) => {
    if (!dt) return '';
    const mins = Math.floor((Date.now() - new Date(dt)) / 60000);
    if (mins < 1) return 'Just now';
    if (mins < 60) return `${mins}m ago`;
    const hrs = Math.floor(mins / 60);
    if (hrs < 24) return `${hrs}h ago`;
    return `${Math.floor(hrs / 24)}d ago`;
  };

  // ── Camera / Attendance ──
  const openCamera = async (type) => {
    setCameraType(type);
    setCapturedImage(null);
    setShowCameraModal(true);
    // Start webcam after modal renders
    setTimeout(startWebcam, 300);
  };

  const startWebcam = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'user', width: 640, height: 480 },
      });
      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        videoRef.current.play();
      }
    } catch (err) {
      showToast('Camera access denied. Please allow camera permission.', 'error');
    }
  };

  const stopWebcam = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(t => t.stop());
      streamRef.current = null;
    }
  };

  const capturePhoto = () => {
    if (!videoRef.current || !canvasRef.current) return;
    const canvas = canvasRef.current;
    const video = videoRef.current;
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    const ctx = canvas.getContext('2d');
    ctx.drawImage(video, 0, 0);
    const dataUrl = canvas.toDataURL('image/jpeg', 0.7);
    setCapturedImage(dataUrl);
    stopWebcam();
  };

  const retakePhoto = () => {
    setCapturedImage(null);
    setTimeout(startWebcam, 200);
  };

  const closeCameraModal = () => {
    setShowCameraModal(false);
    setCapturedImage(null);
    stopWebcam();
  };

  const submitAttendance = async () => {
    if (!capturedImage) return;
    setSubmitting(true);
    try {
      // Try to get location
      let lat = null, lng = null, address = null;
      try {
        const pos = await new Promise((resolve, reject) =>
          navigator.geolocation.getCurrentPosition(resolve, reject, { timeout: 5000 })
        );
        lat = pos.coords.latitude;
        lng = pos.coords.longitude;
        address = `${lat.toFixed(6)}, ${lng.toFixed(6)}`;
      } catch (e) {}

      const endpoint = cameraType === 'punchIn' ? 'attendance/punch-in' : 'attendance/punch-out';
      const res = await apiFetch(endpoint, {
        method: 'POST',
        body: JSON.stringify({ image: capturedImage, lat, lng, address }),
      });

      if (res.success) {
        showToast(cameraType === 'punchIn' ? 'Punched in successfully!' : 'Punched out successfully!', 'success');
        closeCameraModal();
        fetchAttendance();
      } else {
        showToast(res.message || 'Failed to record attendance', 'error');
      }
    } catch (err) {
      showToast('Failed to submit attendance', 'error');
    } finally {
      setSubmitting(false);
    }
  };

  const handleAttendanceClick = () => {
    if (isPunchedIn) {
      openCamera('punchOut');
    } else {
      openCamera('punchIn');
    }
  };

  return (
    <>
      <header className="header">
        <div className="header__left">
          <div className="header__title-group">
            <h1 className="header__title">{title}</h1>
            {subtitle && <p className="header__subtitle">{subtitle}</p>}
          </div>
        </div>

        <div className="header__right">
          <div className={`header__search ${searchOpen ? 'header__search--open' : ''}`}>
            <Search size={18} />
            <input
              type="text"
              placeholder="Search anything..."
              className="header__search-input"
              onFocus={() => setSearchOpen(true)}
              onBlur={() => setSearchOpen(false)}
            />
          </div>

          {/* Attendance Button */}
          {isPunchedIn ? (
            <button
              className="header__punch-chip"
              onClick={handleAttendanceClick}
              title="Click to Punch Out"
            >
              <span className="header__punch-live" />
              <Fingerprint size={16} />
              <span className="header__punch-timer">{elapsedTime || '00:00:00'}</span>
            </button>
          ) : (
            <button
              className="header__icon-btn header__attendance-btn"
              onClick={handleAttendanceClick}
              title="Punch In"
            >
              <Fingerprint size={19} />
            </button>
          )}

          {/* Notification Button */}
          <div className="header__notif-wrap" ref={notifRef}>
            <button
              className="header__icon-btn header__notification-btn"
              onClick={() => { setNotifOpen(!notifOpen); if (!notifOpen) fetchNotifications(); }}
            >
              <Bell size={19} />
              {unreadCount > 0 && (
                <span className="header__notification-badge">{unreadCount > 9 ? '9+' : unreadCount}</span>
              )}
            </button>

            {/* Notification Dropdown */}
            {notifOpen && (
              <div className="header__notif-dropdown">
                <div className="header__notif-head">
                  <span className="header__notif-title">Notifications</span>
                  {unreadCount > 0 && (
                    <button className="header__notif-mark-all" onClick={markAllRead}>Mark all read</button>
                  )}
                </div>
                <div className="header__notif-list">
                  {notifications.length === 0 ? (
                    <div className="header__notif-empty">
                      <Bell size={24} />
                      <span>No notifications</span>
                    </div>
                  ) : notifications.map(n => (
                    <div
                      key={n.n_id}
                      className={`header__notif-item ${!n.is_read ? 'header__notif-item--unread' : ''}`}
                      onClick={() => { if (!n.is_read) markAsRead(n.n_id); }}
                    >
                      <div className={`header__notif-icon header__notif-icon--${n.type || 'general'}`}>
                        {n.type === 'lead' ? <AlertCircle size={14} /> :
                         n.type === 'followup' ? <Clock size={14} /> :
                         <Bell size={14} />}
                      </div>
                      <div className="header__notif-content">
                        <span className="header__notif-msg">{n.title || n.message}</span>
                        {n.message && n.title && <span className="header__notif-body">{n.message}</span>}
                        <span className="header__notif-time">{timeAgo(n.create_dt)}</span>
                      </div>
                      {!n.is_read && <span className="header__notif-unread-dot" />}
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>

          {actions && <div className="header__actions">{actions}</div>}
        </div>
      </header>

      {/* Camera Modal */}
      {showCameraModal && (
        <div className="cam-overlay" onClick={closeCameraModal}>
          <div className="cam-modal" onClick={e => e.stopPropagation()}>
            <div className="cam-header">
              <div className="cam-header__left">
                <div className={`cam-header__icon ${cameraType === 'punchIn' ? 'cam-header__icon--in' : 'cam-header__icon--out'}`}>
                  {cameraType === 'punchIn' ? <LogIn size={18} /> : <LogOut size={18} />}
                </div>
                <div>
                  <h3 className="cam-header__title">{cameraType === 'punchIn' ? 'Punch In' : 'Punch Out'}</h3>
                  <p className="cam-header__sub">Take a selfie to record attendance</p>
                </div>
              </div>
              <button className="cam-close" onClick={closeCameraModal}><X size={20} /></button>
            </div>

            <div className="cam-body">
              {!capturedImage ? (
                <div className="cam-video-wrap">
                  <video ref={videoRef} className="cam-video" autoPlay playsInline muted />
                  <div className="cam-video-overlay">
                    <div className="cam-face-guide" />
                  </div>
                  <button className="cam-capture-btn" onClick={capturePhoto}>
                    <Camera size={24} />
                  </button>
                </div>
              ) : (
                <div className="cam-preview-wrap">
                  <img src={capturedImage} alt="Captured" className="cam-preview-img" />
                  <div className="cam-preview-badge">
                    <CheckCircle size={14} />
                    Photo captured
                  </div>
                </div>
              )}
            </div>

            <div className="cam-footer">
              {capturedImage ? (
                <>
                  <button className="cam-btn cam-btn--retake" onClick={retakePhoto}>
                    <RotateCcw size={16} /> Retake
                  </button>
                  <button
                    className={`cam-btn cam-btn--submit ${cameraType === 'punchIn' ? 'cam-btn--in' : 'cam-btn--out'}`}
                    onClick={submitAttendance}
                    disabled={submitting}
                  >
                    {submitting ? 'Submitting...' : cameraType === 'punchIn' ? 'Confirm Punch In' : 'Confirm Punch Out'}
                  </button>
                </>
              ) : (
                <p className="cam-hint">
                  <MapPin size={13} /> Location will be captured automatically
                </p>
              )}
            </div>

            <canvas ref={canvasRef} style={{ display: 'none' }} />
          </div>
        </div>
      )}
    </>
  );
};

export default Header;

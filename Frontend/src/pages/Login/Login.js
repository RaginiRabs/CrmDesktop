import React, { useState } from 'react';
import { useAuth } from '../../context/AuthContext';
import { Building2, LogIn, ArrowRight, Eye, EyeOff, Loader2 } from 'lucide-react';
import './Login.css';

const Login = () => {
  const { isClientVerified, verifyClientCode, login } = useAuth();
  const [step, setStep] = useState(isClientVerified ? 'login' : 'client');
  const [clientCode, setClientCode] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleVerifyClient = async (e) => {
    e.preventDefault();
    if (!clientCode.trim()) { setError('Please enter client code'); return; }
    setLoading(true);
    setError('');
    const result = await verifyClientCode(clientCode.trim());
    setLoading(false);
    if (result.success) {
      setStep('login');
      setError('');
    } else {
      setError(result.message);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    if (!username.trim()) { setError('Please enter username'); return; }
    if (!password) { setError('Please enter password'); return; }
    setLoading(true);
    setError('');
    const result = await login(username, password);
    setLoading(false);
    if (!result.success) {
      setError(result.message);
    }
    // If success, App.js will redirect automatically
  };

  return (
    <div className="login-page">
      <div className="login-card">
        <div className="login-header">
          <div className="login-logo">
            <Building2 size={32} />
          </div>
          <h1 className="login-title">RABS Connect</h1>
          <p className="login-subtitle">
            {step === 'client' ? 'Enter your client code to get started' : 'Sign in to your account'}
          </p>
        </div>

        {error && <div className="login-error">{error}</div>}

        {step === 'client' ? (
          <form onSubmit={handleVerifyClient} className="login-form">
            <div className="login-field">
              <label className="login-label">Client Code</label>
              <input
                className="login-input"
                type="text"
                placeholder="Enter client code"
                value={clientCode}
                onChange={e => setClientCode(e.target.value)}
                autoFocus
              />
            </div>
            <button className="login-btn" type="submit" disabled={loading}>
              {loading ? <Loader2 size={18} className="spin" /> : <ArrowRight size={18} />}
              <span>{loading ? 'Verifying...' : 'Continue'}</span>
            </button>
          </form>
        ) : (
          <form onSubmit={handleLogin} className="login-form">
            <div className="login-field">
              <label className="login-label">Username</label>
              <input
                className="login-input"
                type="text"
                placeholder="Enter username"
                value={username}
                onChange={e => setUsername(e.target.value)}
                autoFocus
              />
            </div>
            <div className="login-field">
              <label className="login-label">Password</label>
              <div className="login-password-wrap">
                <input
                  className="login-input"
                  type={showPassword ? 'text' : 'password'}
                  placeholder="Enter password"
                  value={password}
                  onChange={e => setPassword(e.target.value)}
                />
                <button type="button" className="login-eye" onClick={() => setShowPassword(!showPassword)}>
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>
            <button className="login-btn" type="submit" disabled={loading}>
              {loading ? <Loader2 size={18} className="spin" /> : <LogIn size={18} />}
              <span>{loading ? 'Signing in...' : 'Sign In'}</span>
            </button>
            <button type="button" className="login-link" onClick={() => { setStep('client'); setError(''); }}>
              Change client code
            </button>
          </form>
        )}
      </div>
    </div>
  );
};

export default Login;

import React, { useState, useEffect, useCallback } from 'react';
import { useNavigate } from 'react-router-dom';
import { apiFetch } from '../../utils/api';
import Header from '../../components/layout/Header';
import { Button, Modal } from '../../components/common/Common';
import { Plus, Search, Phone, Mail, MapPin, Award, Edit2, Trash2, Eye, Building2 } from 'lucide-react';
import './Brokers.css';

const Brokers = () => {
  const navigate = useNavigate();
  const [brokers, setBrokers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [pagination, setPagination] = useState({ page: 1, total: 0, totalPages: 1 });
  const [selectedBroker, setSelectedBroker] = useState(null);
  const [showDetail, setShowDetail] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [deletingId, setDeletingId] = useState(null);
  const [toast, setToast] = useState(null);

  const fetchBrokers = useCallback(async () => {
    setLoading(true);
    try {
      const params = new URLSearchParams();
      params.append('page', pagination.page);
      params.append('limit', 20);
      if (search) params.append('search', search);
      if (statusFilter !== 'all') params.append('status', statusFilter);

      const res = await apiFetch(`brokers?${params}`);
      if (res.success) {
        setBrokers(res.data || []);
        setPagination(p => ({
          ...p,
          total: res.pagination?.total || 0,
          totalPages: res.pagination?.totalPages || 1,
        }));
      }
    } catch (err) {
      console.error('Fetch brokers error:', err);
    } finally {
      setLoading(false);
    }
  }, [pagination.page, search, statusFilter]);

  useEffect(() => { fetchBrokers(); }, [fetchBrokers]);

  const handleSearch = (e) => {
    setSearch(e.target.value);
    setPagination(p => ({ ...p, page: 1 }));
  };

  const handleDelete = async () => {
    if (!deletingId) return;
    try {
      const res = await apiFetch(`brokers/${deletingId}`, { method: 'DELETE' });
      if (res.success) {
        setToast({ type: 'success', message: 'Broker deleted successfully' });
        fetchBrokers();
      } else {
        setToast({ type: 'error', message: res.message || 'Failed to delete' });
      }
    } catch (err) {
      setToast({ type: 'error', message: 'Failed to delete broker' });
    }
    setShowDeleteConfirm(false);
    setDeletingId(null);
    setTimeout(() => setToast(null), 3000);
  };

  const handleStatusChange = async (brokerId, newStatus) => {
    try {
      const res = await apiFetch(`brokers/${brokerId}/status`, {
        method: 'PATCH',
        body: JSON.stringify({ status: newStatus }),
      });
      if (res.success) {
        setToast({ type: 'success', message: 'Status updated' });
        fetchBrokers();
        if (selectedBroker?.b_id === brokerId) {
          setSelectedBroker(prev => ({ ...prev, status: newStatus }));
        }
      }
    } catch (err) {
      setToast({ type: 'error', message: 'Failed to update status' });
    }
    setTimeout(() => setToast(null), 3000);
  };

  const openDetail = async (broker) => {
    try {
      const res = await apiFetch(`brokers/${broker.b_id}`);
      if (res.success) {
        setSelectedBroker(res.data);
        setShowDetail(true);
      }
    } catch (err) {
      setSelectedBroker(broker);
      setShowDetail(true);
    }
  };

  const getInitials = (name) => {
    if (!name) return '?';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'active': return '#22c55e';
      case 'inactive': return '#ef4444';
      case 'suspended': return '#f59e0b';
      default: return '#6b7280';
    }
  };

  const formatDate = (dt) => {
    if (!dt) return '-';
    return new Date(dt).toLocaleDateString('en-IN', { day: '2-digit', month: 'short', year: 'numeric' });
  };

  return (
    <div>
      <Header
        title="Broker Management"
        subtitle={`${pagination.total} brokers`}
        actions={<Button variant="gold" icon={Plus} onClick={() => navigate('/brokers/add')}>Add Broker</Button>}
      />
      <div className="page">
        {/* Search & Filters */}
        <div className="broker-filters">
          <div className="broker-filters__search">
            <Search size={16} />
            <input placeholder="Search by name, mobile, RERA, company..." value={search} onChange={handleSearch} />
          </div>
          <div className="broker-filters__chips">
            {[{ v: 'all', l: 'All' }, { v: 'active', l: 'Active' }, { v: 'inactive', l: 'Inactive' }, { v: 'suspended', l: 'Suspended' }].map(s => (
              <button key={s.v} className={`filter-chip ${statusFilter === s.v ? 'filter-chip--active' : ''}`} onClick={() => { setStatusFilter(s.v); setPagination(p => ({ ...p, page: 1 })); }}>{s.l}</button>
            ))}
          </div>
        </div>

        {/* Table */}
        <div className="broker-table-wrap">
          <table className="broker-table">
            <thead>
              <tr>
                <th>Broker</th>
                <th>Contact</th>
                <th>Company</th>
                <th>RERA No.</th>
                <th>Specialization</th>
                <th>Status</th>
                <th>Joined</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan="8" className="broker-table__empty">Loading...</td></tr>
              ) : brokers.length === 0 ? (
                <tr><td colSpan="8" className="broker-table__empty">No brokers found</td></tr>
              ) : brokers.map(broker => (
                <tr key={broker.b_id} className="broker-table__row">
                  <td>
                    <div className="broker-table__name-cell">
                      <div className="broker-table__avatar" style={{ borderColor: getStatusColor(broker.status) }}>
                        {getInitials(broker.broker_name)}
                      </div>
                      <span className="broker-table__name">{broker.broker_name}</span>
                    </div>
                  </td>
                  <td>
                    <div className="broker-table__contact">
                      <span><Phone size={12} /> {broker.country_code} {broker.mobile_no}</span>
                      {broker.broker_email && <span><Mail size={12} /> {broker.broker_email}</span>}
                    </div>
                  </td>
                  <td><span className="broker-table__company">{broker.company || '-'}</span></td>
                  <td><span className="broker-table__rera">{broker.rera_no || '-'}</span></td>
                  <td><span className="broker-table__spec">{broker.specialization || '-'}</span></td>
                  <td>
                    <select
                      className="broker-table__status-select"
                      value={broker.status}
                      onChange={(e) => handleStatusChange(broker.b_id, e.target.value)}
                      style={{ color: getStatusColor(broker.status) }}
                    >
                      <option value="active">Active</option>
                      <option value="inactive">Inactive</option>
                      <option value="suspended">Suspended</option>
                    </select>
                  </td>
                  <td><span className="broker-table__date">{formatDate(broker.created_at)}</span></td>
                  <td>
                    <div className="broker-table__actions">
                      <button className="broker-action-btn" title="View" onClick={() => openDetail(broker)}><Eye size={15} /></button>
                      <button className="broker-action-btn" title="Edit" onClick={() => navigate(`/brokers/edit/${broker.b_id}`)}><Edit2 size={15} /></button>
                      <button className="broker-action-btn broker-action-btn--danger" title="Delete" onClick={() => { setDeletingId(broker.b_id); setShowDeleteConfirm(true); }}><Trash2 size={15} /></button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {pagination.totalPages > 1 && (
          <div className="broker-pagination">
            <span className="broker-pagination__info">Page {pagination.page} of {pagination.totalPages} ({pagination.total} brokers)</span>
            <div className="broker-pagination__btns">
              <button disabled={pagination.page <= 1} onClick={() => setPagination(p => ({ ...p, page: p.page - 1 }))}>Previous</button>
              <button disabled={pagination.page >= pagination.totalPages} onClick={() => setPagination(p => ({ ...p, page: p.page + 1 }))}>Next</button>
            </div>
          </div>
        )}
      </div>

      {/* Detail Modal */}
      <Modal isOpen={showDetail} onClose={() => setShowDetail(false)} title="Broker Details" size="lg">
        {selectedBroker && (
          <div className="broker-detail">
            <div className="broker-detail__header">
              <div className="broker-detail__avatar" style={{ borderColor: getStatusColor(selectedBroker.status) }}>
                {getInitials(selectedBroker.broker_name)}
              </div>
              <div>
                <h3 className="broker-detail__name">{selectedBroker.broker_name}</h3>
                <p className="broker-detail__company"><Building2 size={14} /> {selectedBroker.company}</p>
                <span className="broker-detail__status" style={{ color: getStatusColor(selectedBroker.status) }}>
                  {selectedBroker.status}
                </span>
              </div>
            </div>
            <div className="broker-detail__grid">
              <div className="broker-detail__item"><span className="broker-detail__label">Phone</span><span className="broker-detail__value">{selectedBroker.country_code} {selectedBroker.mobile_no}</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label">Email</span><span className="broker-detail__value">{selectedBroker.broker_email || '-'}</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label"><Award size={13} /> RERA No.</span><span className="broker-detail__value">{selectedBroker.rera_no}</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label">Specialization</span><span className="broker-detail__value">{selectedBroker.specialization || '-'}</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label">Commission</span><span className="broker-detail__value">{selectedBroker.commission_percentage}%</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label">Experience</span><span className="broker-detail__value">{selectedBroker.experience_years || 0} years</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label"><MapPin size={13} /> Location</span><span className="broker-detail__value">{selectedBroker.location || '-'}</span></div>
              <div className="broker-detail__item"><span className="broker-detail__label">Address</span><span className="broker-detail__value">{selectedBroker.address || '-'}</span></div>
              {selectedBroker.remark && <div className="broker-detail__item" style={{ gridColumn: '1/-1' }}><span className="broker-detail__label">Remark</span><span className="broker-detail__value">{selectedBroker.remark}</span></div>}
              <div className="broker-detail__item"><span className="broker-detail__label">Joined</span><span className="broker-detail__value">{formatDate(selectedBroker.created_at)}</span></div>
              {selectedBroker.license_expiry_date && <div className="broker-detail__item"><span className="broker-detail__label">License Expiry</span><span className="broker-detail__value">{formatDate(selectedBroker.license_expiry_date)}</span></div>}
            </div>
          </div>
        )}
      </Modal>

      {/* Delete Confirmation */}
      <Modal isOpen={showDeleteConfirm} onClose={() => setShowDeleteConfirm(false)} title="Delete Broker" size="sm">
        <p style={{ color: 'var(--gray-600)', marginBottom: 20 }}>Are you sure you want to delete this broker? This action cannot be undone.</p>
        <div className="modal__actions">
          <Button variant="outline" onClick={() => setShowDeleteConfirm(false)}>Cancel</Button>
          <Button variant="danger" icon={Trash2} onClick={handleDelete}>Delete</Button>
        </div>
      </Modal>

      {/* Toast */}
      {toast && (
        <div className={`broker-toast broker-toast--${toast.type}`}>
          {toast.message}
        </div>
      )}
    </div>
  );
};

export default Brokers;

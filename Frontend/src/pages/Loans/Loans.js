import React, { useState, useEffect, useMemo } from 'react';
import { useCRM } from '../../context/CRMContext';
import Header from '../../components/layout/Header';
import { Button, Badge, Table, Modal, FormInput, FormSelect, StatCard } from '../../components/common/Common';
import { Plus, Search, DollarSign, TrendingUp, CheckCircle, Clock, Edit2, Trash2, Download } from 'lucide-react';
import './Loans.css';

const emptyForm = {
  applicant_name: '',
  applicant_phone: '',
  applicant_email: '',
  loan_amount: '',
  loan_type: 'Home Loan',
  tenure_months: '240',
  interest_rate: '',
  status: 'Pending',
  lender_name: '',
  loan_reference: '',
  approval_date: '',
  start_date: '',
  emi_amount: '',
  notes: '',
};

const Loans = () => {
  const { fetchLoans, fetchLoanStats, createLoanRecord, updateLoanRecord, deleteLoanRecord } = useCRM();
  const [loans, setLoans] = useState([]);
  const [stats, setStats] = useState({});
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('All');
  const [typeFilter, setTypeFilter] = useState('All');
  const [loading, setLoading] = useState(true);
  const [showAddModal, setShowAddModal] = useState(false);
  const [showViewModal, setShowViewModal] = useState(false);
  const [selectedLoan, setSelectedLoan] = useState(null);
  const [editMode, setEditMode] = useState(false);
  const [formData, setFormData] = useState({ ...emptyForm });
  const [toast, setToast] = useState(null);

  useEffect(() => {
    loadLoans();
    loadStats();
  }, []);

  const loadLoans = async () => {
    setLoading(true);
    const res = await fetchLoans({ search, status: statusFilter !== 'All' ? statusFilter : null, loan_type: typeFilter !== 'All' ? typeFilter : null });
    if (res.success) setLoans(res.data);
    setLoading(false);
  };

  const loadStats = async () => {
    const res = await fetchLoanStats();
    if (res.success) setStats(res.data);
  };

  const filteredLoans = useMemo(() => {
    return loans.filter(l => {
      const q = search.toLowerCase();
      const matchSearch = !q || l.applicant_name.toLowerCase().includes(q) || l.applicant_phone.includes(q) || (l.loan_reference || '').includes(q);
      const matchStatus = statusFilter === 'All' || l.status === statusFilter;
      const matchType = typeFilter === 'All' || l.loan_type === typeFilter;
      return matchSearch && matchStatus && matchType;
    });
  }, [loans, search, statusFilter, typeFilter]);

  const handleFormChange = (e) => setFormData(p => ({ ...p, [e.target.name]: e.target.value }));

  const showNotification = (message, type) => {
    setToast({ message, type });
    setTimeout(() => setToast(null), 3000);
  };

  const handleAddLoan = async () => {
    const nameTrimed = formData.applicant_name.trim();
    const phoneTrimed = formData.applicant_phone.trim();
    const amountTrimed = formData.loan_amount.toString().trim();

    if (!nameTrimed) {
      showNotification('Applicant name is required', 'error');
      return;
    }
    if (!phoneTrimed) {
      showNotification('Phone number is required', 'error');
      return;
    }
    if (!/^\d{7,15}$/.test(phoneTrimed.replace(/\D/g, ''))) {
      showNotification('Phone number must be 7-15 digits', 'error');
      return;
    }
    if (!amountTrimed) {
      showNotification('Loan amount is required', 'error');
      return;
    }
    if (!formData.loan_type) {
      showNotification('Loan type is required', 'error');
      return;
    }

    const res = await createLoanRecord(formData);
    if (res.success) {
      showNotification('Loan created successfully', 'success');
      setShowAddModal(false);
      setFormData({ ...emptyForm });
      loadLoans();
      loadStats();
    } else {
      showNotification(res.message || 'Failed to create loan', 'error');
    }
  };

  const handleEditLoan = async () => {
    if (!selectedLoan) return;

    const nameTrimed = formData.applicant_name.trim();
    const phoneTrimed = formData.applicant_phone.trim();
    const amountTrimed = formData.loan_amount.toString().trim();

    if (!nameTrimed) {
      showNotification('Applicant name is required', 'error');
      return;
    }
    if (!phoneTrimed) {
      showNotification('Phone number is required', 'error');
      return;
    }
    if (!/^\d{7,15}$/.test(phoneTrimed.replace(/\D/g, ''))) {
      showNotification('Phone number must be 7-15 digits', 'error');
      return;
    }
    if (!amountTrimed) {
      showNotification('Loan amount is required', 'error');
      return;
    }

    const res = await updateLoanRecord(selectedLoan.loan_id, formData);
    if (res.success) {
      showNotification('Loan updated successfully', 'success');
      setShowViewModal(false);
      setEditMode(false);
      setSelectedLoan(null);
      loadLoans();
      loadStats();
    } else {
      showNotification(res.message || 'Failed to update loan', 'error');
    }
  };

  const handleDeleteLoan = async (id) => {
    if (!window.confirm('Are you sure you want to delete this loan record?')) return;
    const res = await deleteLoanRecord(id);
    if (res.success) {
      showNotification('Loan deleted successfully', 'success');
      loadLoans();
      loadStats();
    } else {
      showNotification(res.message || 'Failed to delete loan', 'error');
    }
  };

  const openViewModal = (loan) => {
    setSelectedLoan(loan);
    setFormData({ ...loan });
    setEditMode(false);
    setShowViewModal(true);
  };

  const getStatusColor = (status) => {
    const colors = {
      'Pending': 'primary',
      'Approved': 'success',
      'Rejected': 'danger',
      'Active': 'success',
      'Closed': 'gray',
    };
    return colors[status] || 'primary';
  };

  const LoanForm = ({ onSubmit, submitLabel }) => (
    <div>
      <div className="form-row">
        <FormInput label="Applicant Name *" name="applicant_name" value={formData.applicant_name} onChange={handleFormChange} placeholder="Full name" />
        <FormInput label="Phone *" name="applicant_phone" value={formData.applicant_phone} onChange={handleFormChange} placeholder="+91" />
      </div>
      <div className="form-row">
        <FormInput label="Email" name="applicant_email" type="email" value={formData.applicant_email} onChange={handleFormChange} placeholder="email@example.com" />
        <FormSelect label="Loan Type *" name="loan_type" value={formData.loan_type} onChange={handleFormChange} options={['Home Loan', 'Personal Loan', 'Business Loan', 'Auto Loan', 'Education Loan']} />
      </div>
      <div className="form-row">
        <FormInput label="Loan Amount *" name="loan_amount" type="number" value={formData.loan_amount} onChange={handleFormChange} placeholder="e.g. 5000000" />
        <FormInput label="Interest Rate %" name="interest_rate" type="number" step="0.01" value={formData.interest_rate} onChange={handleFormChange} placeholder="e.g. 6.5" />
      </div>
      <div className="form-row">
        <FormInput label="Tenure (Months)" name="tenure_months" type="number" value={formData.tenure_months} onChange={handleFormChange} />
        <FormInput label="EMI Amount" name="emi_amount" type="number" value={formData.emi_amount} onChange={handleFormChange} placeholder="Calculated" />
      </div>
      <div className="form-row">
        <FormInput label="Lender Name" name="lender_name" value={formData.lender_name} onChange={handleFormChange} placeholder="Bank/NBFC name" />
        <FormInput label="Loan Reference" name="loan_reference" value={formData.loan_reference} onChange={handleFormChange} placeholder="Reference number" />
      </div>
      <div className="form-row">
        <FormSelect label="Status" name="status" value={formData.status} onChange={handleFormChange} options={['Pending', 'Approved', 'Rejected', 'Active', 'Closed']} />
      </div>
      <div className="form-row">
        <FormInput label="Approval Date" name="approval_date" type="date" value={formData.approval_date} onChange={handleFormChange} />
        <FormInput label="Start Date" name="start_date" type="date" value={formData.start_date} onChange={handleFormChange} />
      </div>
      <div className="form-group">
        <label className="form-label">Notes</label>
        <textarea className="form-input" name="notes" value={formData.notes} onChange={handleFormChange} rows="3" placeholder="Add notes..." style={{ resize: 'vertical', minHeight: '70px' }} />
      </div>
      <div className="modal__actions">
        <Button variant="outline" onClick={() => { setShowAddModal(false); setShowViewModal(false); }}>Cancel</Button>
        <Button variant="gold" onClick={onSubmit}>{submitLabel}</Button>
      </div>
    </div>
  );

  const columns = [
    {
      header: 'Applicant', render: (row) => (
        <div style={{ display: 'flex', flexDirection: 'column' }}>
          <p style={{ fontWeight: 600, color: 'var(--navy-800)', fontSize: '13px' }}>{row.applicant_name}</p>
          <p style={{ fontSize: '11px', color: 'var(--gray-500)', marginTop: '2px' }}>{row.applicant_phone}</p>
        </div>
      )
    },
    { header: 'Type', render: (row) => <Badge variant="primary">{row.loan_type}</Badge> },
    { header: 'Amount', render: (row) => <span style={{ fontWeight: 600, color: 'var(--gold-700)', fontSize: '13px' }}>₹ {Number(row.loan_amount).toLocaleString('en-IN')}</span> },
    { header: 'Lender', render: (row) => <span style={{ fontSize: '13px', color: 'var(--gray-700)' }}>{row.lender_name || '—'}</span> },
    { header: 'EMI', render: (row) => <span style={{ fontSize: '13px', color: 'var(--gray-700)' }}>₹ {row.emi_amount ? Number(row.emi_amount).toLocaleString('en-IN') : '—'}</span> },
    { header: 'Status', render: (row) => <Badge variant={getStatusColor(row.status)}>{row.status}</Badge> },
    {
      header: 'Actions', width: '100px', render: (row) => (
        <div style={{ display: 'flex', gap: '6px' }}>
          <button className="btn btn--ghost btn--sm" onClick={(e) => { e.stopPropagation(); openViewModal(row); }}><Edit2 size={14} /></button>
          <button className="btn btn--ghost btn--sm" onClick={(e) => { e.stopPropagation(); handleDeleteLoan(row.loan_id); }} style={{ color: 'var(--danger)' }}><Trash2 size={14} /></button>
        </div>
      )
    }
  ];

  return (
    <div>
      <Header
        title="Loan Management"
        subtitle={`${loans.length} loans`}
        actions={<Button variant="gold" icon={Plus} onClick={() => { setFormData({ ...emptyForm }); setShowAddModal(true); }}>Add Loan</Button>}
      />
      <div className="page">
        <div className="page__grid page__grid--stats">
          <StatCard icon={DollarSign} label="Total Loans" value={stats.total || 0} />
          <StatCard icon={TrendingUp} label="Total Amount" value={`₹ ${stats.total_amount ? (stats.total_amount / 10000000).toFixed(1) : 0} Cr`} accent />
          <StatCard icon={CheckCircle} label="Approved" value={stats.by_status?.find(s => s.status === 'Approved')?.count || 0} />
          <StatCard icon={Clock} label="Pending" value={stats.by_status?.find(s => s.status === 'Pending')?.count || 0} />
        </div>

        <div className="filter-bar">
          <div className="filter-bar__search">
            <Search size={16} />
            <input placeholder="Search by name, phone, or ref..." value={search} onChange={(e) => setSearch(e.target.value)} />
          </div>
          {['All', 'Pending', 'Approved', 'Rejected', 'Active', 'Closed'].map(s => (
            <button key={s} className={`filter-chip ${statusFilter === s ? 'filter-chip--active' : ''}`} onClick={() => setStatusFilter(s)}>{s}</button>
          ))}
        </div>

        {loading ? (
          <div style={{ textAlign: 'center', padding: '40px', color: 'var(--gray-500)' }}>Loading...</div>
        ) : filteredLoans.length > 0 ? (
          <Table columns={columns} rows={filteredLoans} onRowClick={openViewModal} />
        ) : (
          <div style={{ textAlign: 'center', padding: '40px', color: 'var(--gray-500)' }}>No loans found</div>
        )}
      </div>

      <Modal isOpen={showAddModal} onClose={() => setShowAddModal(false)} title="Add Loan" size="md">
        <LoanForm onSubmit={handleAddLoan} submitLabel="Add Loan" />
      </Modal>

      <Modal isOpen={showViewModal} onClose={() => { setShowViewModal(false); setEditMode(false); }} title={editMode ? 'Edit Loan' : 'Loan Details'} size="md">
        {!editMode && selectedLoan ? (
          <div>
            <div className="lead-detail__header">
              <div style={{ flex: 1 }}>
                <h3 className="lead-detail__name">{selectedLoan.applicant_name}</h3>
                <p className="lead-detail__sub">{selectedLoan.loan_type} · {selectedLoan.loan_reference}</p>
              </div>
              <div>
                <Button variant="primary" icon={Edit2} size="sm" onClick={() => setEditMode(true)}>Edit</Button>
              </div>
            </div>
            <div className="lead-detail__grid">
              <div className="lead-detail__item"><span className="lead-detail__label">Phone</span><span className="lead-detail__value">{selectedLoan.applicant_phone}</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Email</span><span className="lead-detail__value">{selectedLoan.applicant_email || '—'}</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Loan Amount</span><span className="lead-detail__value">₹ {Number(selectedLoan.loan_amount).toLocaleString('en-IN')}</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">EMI</span><span className="lead-detail__value">₹ {selectedLoan.emi_amount ? Number(selectedLoan.emi_amount).toLocaleString('en-IN') : '—'}</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Interest Rate</span><span className="lead-detail__value">{selectedLoan.interest_rate}%</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Tenure</span><span className="lead-detail__value">{selectedLoan.tenure_months} months</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Lender</span><span className="lead-detail__value">{selectedLoan.lender_name || '—'}</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Status</span><Badge variant={getStatusColor(selectedLoan.status)}>{selectedLoan.status}</Badge></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Approval Date</span><span className="lead-detail__value">{selectedLoan.approval_date || '—'}</span></div>
              <div className="lead-detail__item"><span className="lead-detail__label">Start Date</span><span className="lead-detail__value">{selectedLoan.start_date || '—'}</span></div>
            </div>
            {selectedLoan.notes && (
              <div style={{ marginTop: '20px', padding: '12px', backgroundColor: 'var(--blue-50)', borderRadius: 6 }}>
                <p style={{ fontSize: '12px', color: 'var(--blue-700)', whiteSpace: 'pre-wrap' }}>{selectedLoan.notes}</p>
              </div>
            )}
          </div>
        ) : (
          <LoanForm onSubmit={handleEditLoan} submitLabel="Save Changes" />
        )}
      </Modal>

      {toast?.message && (
        <div className={`toast toast--${toast.type}`} style={{
          position: 'fixed',
          bottom: 24,
          right: 24,
          padding: '12px 16px',
          borderRadius: 8,
          fontSize: 14,
          fontWeight: 500,
          zIndex: 9999,
          backgroundColor: toast.type === 'success' ? '#10b981' : '#ef4444',
          color: 'white',
          boxShadow: '0 4px 12px rgba(0,0,0,0.15)',
          animation: 'slideIn 0.3s ease-out'
        }}>
          {toast.message}
        </div>
      )}
    </div>
  );
};

export default Loans;

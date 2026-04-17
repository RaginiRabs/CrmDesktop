import React, { useState, useEffect, useCallback } from 'react';
import { apiFetch } from '../../utils/api';
import Header from '../../components/layout/Header';
import { Modal, Button } from '../../components/common/Common';
import {
  Plus, Edit2, Trash2, ToggleLeft, ToggleRight, ChevronDown,
  Globe, Tag, Flag, Building2, Briefcase, Home, LayoutGrid, Clock, Search
} from 'lucide-react';
import './DynamicFields.css';

const FIELD_TYPES = [
  { key: 'lead_sources', label: 'Lead Sources', icon: Globe, color: '#4285F4', endpoint: 'leads/sources', nameField: 'name', idField: 'src_id', hasColor: true, hasIcon: true },
  { key: 'lead_statuses', label: 'Lead Statuses', icon: Tag, color: '#22c55e', endpoint: 'dynamic-fields/lead-statuses', nameField: 'name', idField: 'ls_id', hasColor: true },
  { key: 'lead_priorities', label: 'Lead Priorities', icon: Flag, color: '#ef4444', endpoint: 'dynamic-fields/lead-priorities', nameField: 'name', idField: 'lp_id', hasColor: true },
  { key: 'projects', label: 'Projects', icon: Building2, color: '#8b5cf6', endpoint: 'dynamic-fields/projects', nameField: 'name', idField: 'project_id', extraFields: ['developer', 'location'] },
  { key: 'service_types', label: 'Service Types', icon: Briefcase, color: '#f59e0b', endpoint: 'dynamic-fields/service-types', nameField: 'name', idField: 'st_id' },
  { key: 'property_types', label: 'Property Types', icon: Home, color: '#06b6d4', endpoint: 'dynamic-fields/property-types', nameField: 'name', idField: 'pt_id' },
  { key: 'property_configurations', label: 'Configurations', icon: LayoutGrid, color: '#ec4899', endpoint: 'dynamic-fields/configurations', nameField: 'name', idField: 'pc_id' },
  { key: 'attendance_policies', label: 'Attendance', icon: Clock, color: '#14b8a6', endpoint: 'dynamic-fields/attendance-policies', nameField: 'title', idField: 'ap_id', extraFields: ['type', 'threshold_hours'] },
];

const DynamicFields = () => {
  const [selectedType, setSelectedType] = useState(FIELD_TYPES[0]);
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [showModal, setShowModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [editItem, setEditItem] = useState(null);
  const [deleteItem, setDeleteItem] = useState(null);
  const [formData, setFormData] = useState({ name: '', color: '#808080', icon: '', developer: '', location: '', type: '', threshold_hours: '' });
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState(null);

  const showToast = (message, type = 'success') => {
    setToast({ message, type });
    setTimeout(() => setToast(null), 3000);
  };

  const fetchItems = useCallback(async () => {
    setLoading(true);
    try {
      const res = await apiFetch(selectedType.endpoint);
      if (res.success) {
        const data = res.data;
        setItems(Array.isArray(data) ? data : []);
      }
    } catch (err) {
      console.error('Fetch error:', err);
    }
    setLoading(false);
  }, [selectedType]);

  useEffect(() => { fetchItems(); }, [fetchItems]);

  const openAdd = () => {
    setEditItem(null);
    setFormData({ name: '', color: '#808080', icon: '', developer: '', location: '', type: '', threshold_hours: '' });
    setShowModal(true);
  };

  const openEdit = (item) => {
    setEditItem(item);
    setFormData({
      name: item[selectedType.nameField] || '',
      color: item.color || '#808080',
      icon: item.icon || '',
      developer: item.developer || '',
      location: item.location || '',
      type: item.type || '',
      threshold_hours: item.threshold_hours || '',
    });
    setShowModal(true);
  };

  const handleSave = async () => {
    if (!formData.name.trim()) {
      showToast('Name is required', 'error');
      return;
    }
    setSaving(true);
    try {
      const payload = { [selectedType.nameField]: formData.name.trim() };
      if (selectedType.hasColor) payload.color = formData.color;
      if (selectedType.hasIcon) payload.icon = formData.icon;
      if (selectedType.extraFields) {
        selectedType.extraFields.forEach(f => { if (formData[f]) payload[f] = formData[f]; });
      }

      const endpoint = editItem
        ? `${selectedType.endpoint}/${editItem[selectedType.idField]}`
        : selectedType.endpoint;
      const method = editItem ? 'PUT' : 'POST';

      const res = await apiFetch(endpoint, { method, body: JSON.stringify(payload) });
      if (res.success) {
        showToast(editItem ? 'Updated successfully' : 'Added successfully');
        setShowModal(false);
        fetchItems();
      } else {
        showToast(res.message || 'Failed to save', 'error');
      }
    } catch (err) {
      showToast('Failed to save', 'error');
    }
    setSaving(false);
  };

  const handleDelete = async () => {
    if (!deleteItem) return;
    try {
      const res = await apiFetch(`${selectedType.endpoint}/${deleteItem[selectedType.idField]}`, { method: 'DELETE' });
      if (res.success) {
        showToast('Deleted successfully');
        fetchItems();
      } else {
        showToast(res.message || 'Failed to delete', 'error');
      }
    } catch (err) {
      showToast('Failed to delete', 'error');
    }
    setShowDeleteModal(false);
    setDeleteItem(null);
  };

  const handleToggle = async (item) => {
    try {
      const res = await apiFetch(`${selectedType.endpoint}/${item[selectedType.idField]}/toggle`, { method: 'PATCH' });
      if (res.success) {
        fetchItems();
      }
    } catch (err) {
      showToast('Failed to toggle', 'error');
    }
  };

  return (
    <div>
      <Header title="Dynamic Fields" subtitle="Manage all dropdown options in one place" />
      <div className="page">
        {/* Category Cards */}
        <div className="df-cards">
          {FIELD_TYPES.map(ft => {
            const Icon = ft.icon;
            const isActive = ft.key === selectedType.key;
            return (
              <div
                key={ft.key}
                className={`df-card ${isActive ? 'df-card--active' : ''}`}
                style={{ '--df-accent': ft.color }}
                onClick={() => setSelectedType(ft)}
              >
                <div className="df-card__icon" style={{ background: ft.color + '15', color: ft.color }}>
                  <Icon size={18} />
                </div>
                <span className="df-card__label">{ft.label}</span>
                {isActive && <span className="df-card__count">{items.length}</span>}
              </div>
            );
          })}
        </div>

        {/* Active Section Header */}
        <div className="df-active-header">
          <div className="df-active-header__left">
            {React.createElement(selectedType.icon, { size: 20, color: selectedType.color })}
            <h3 className="df-active-header__title">{selectedType.label}</h3>
            <span className="df-active-header__badge" style={{ background: selectedType.color + '18', color: selectedType.color }}>{items.length} items</span>
          </div>
          <div className="df-active-header__right">
            <div className="df-search">
              <Search size={14} />
              <input placeholder={`Search ${selectedType.label.toLowerCase()}...`} className="df-search__input" />
            </div>
            <Button variant="gold" icon={Plus} onClick={openAdd}>Add New</Button>
          </div>
        </div>

        {/* Table */}
        <div className="df-table-wrap">
          <table className="df-table">
            <thead>
              <tr>
                <th style={{ width: 40 }}>#</th>
                {selectedType.hasColor && <th style={{ width: 50 }}>Color</th>}
                <th>Name</th>
                {selectedType.extraFields?.map(f => <th key={f} style={{ textTransform: 'capitalize' }}>{f.replace(/_/g, ' ')}</th>)}
                <th style={{ width: 70 }}>Active</th>
                <th style={{ width: 100 }}>Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan="10" className="df-table__empty">Loading...</td></tr>
              ) : items.length === 0 ? (
                <tr><td colSpan="10" className="df-table__empty">No items found. Click "Add" to create one.</td></tr>
              ) : items.map((item, idx) => (
                <tr key={item[selectedType.idField]} className="df-table__row">
                  <td className="df-table__num">{idx + 1}</td>
                  {selectedType.hasColor && (
                    <td>
                      <span className="df-color-dot" style={{ background: item.color || '#808080' }} />
                    </td>
                  )}
                  <td className="df-table__name">{item[selectedType.nameField]}</td>
                  {selectedType.extraFields?.map(f => <td key={f} className="df-table__extra">{item[f] || '-'}</td>)}
                  <td>
                    <button className="df-toggle" onClick={() => handleToggle(item)}>
                      {item.is_active !== 0 ? (
                        <ToggleRight size={22} className="df-toggle--on" />
                      ) : (
                        <ToggleLeft size={22} className="df-toggle--off" />
                      )}
                    </button>
                  </td>
                  <td>
                    <div className="df-table__actions">
                      <button className="df-action-btn" title="Edit" onClick={() => openEdit(item)}><Edit2 size={14} /></button>
                      <button className="df-action-btn df-action-btn--danger" title="Delete" onClick={() => { setDeleteItem(item); setShowDeleteModal(true); }}><Trash2 size={14} /></button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Add/Edit Modal */}
      <Modal isOpen={showModal} onClose={() => setShowModal(false)} title={editItem ? `Edit ${selectedType.label.replace(/s$/, '')}` : `Add ${selectedType.label.replace(/s$/, '')}`} size="sm">
        <div className="df-form">
          <div className="df-form__field">
            <label>Name *</label>
            <input value={formData.name} onChange={(e) => setFormData(p => ({ ...p, name: e.target.value }))} placeholder={`Enter ${selectedType.label.replace(/s$/, '').toLowerCase()} name`} />
          </div>
          {selectedType.hasColor && (
            <div className="df-form__field">
              <label>Color</label>
              <div className="df-form__color-row">
                <input type="color" value={formData.color} onChange={(e) => setFormData(p => ({ ...p, color: e.target.value }))} className="df-form__color-input" />
                <input value={formData.color} onChange={(e) => setFormData(p => ({ ...p, color: e.target.value }))} placeholder="#808080" className="df-form__color-text" />
              </div>
            </div>
          )}
          {selectedType.hasIcon && (
            <div className="df-form__field">
              <label>Icon</label>
              <input value={formData.icon} onChange={(e) => setFormData(p => ({ ...p, icon: e.target.value }))} placeholder="e.g. globe, user, building" />
            </div>
          )}
          {selectedType.extraFields?.map(f => (
            <div className="df-form__field" key={f}>
              <label style={{ textTransform: 'capitalize' }}>{f.replace(/_/g, ' ')}</label>
              <input value={formData[f] || ''} onChange={(e) => setFormData(p => ({ ...p, [f]: e.target.value }))} placeholder={`Enter ${f.replace(/_/g, ' ')}`} />
            </div>
          ))}
          <div className="modal__actions">
            <Button variant="outline" onClick={() => setShowModal(false)}>Cancel</Button>
            <Button variant="gold" onClick={handleSave} disabled={saving}>{saving ? 'Saving...' : (editItem ? 'Update' : 'Add')}</Button>
          </div>
        </div>
      </Modal>

      {/* Delete Confirm */}
      <Modal isOpen={showDeleteModal} onClose={() => setShowDeleteModal(false)} title="Delete Item" size="sm">
        <p style={{ color: 'var(--gray-600)', marginBottom: 20 }}>
          Are you sure you want to delete <strong>{deleteItem?.[selectedType.nameField]}</strong>? This may affect existing data.
        </p>
        <div className="modal__actions">
          <Button variant="outline" onClick={() => setShowDeleteModal(false)}>Cancel</Button>
          <Button variant="danger" icon={Trash2} onClick={handleDelete}>Delete</Button>
        </div>
      </Modal>

      {toast && <div className={`broker-toast broker-toast--${toast.type}`}>{toast.message}</div>}
    </div>
  );
};

export default DynamicFields;

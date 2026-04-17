import React, { useState } from 'react';
import { NavLink, useLocation } from 'react-router-dom';
import { useCRM } from '../../context/CRMContext';
import { useAuth } from '../../context/AuthContext';
import {
  LayoutDashboard, Users, Briefcase, UserCheck, CalendarClock,
  ChevronLeft, ChevronRight, ChevronDown, Building2, Crown,
  List, Sparkles, Upload, UserPlus, UserX, PlusCircle, BarChart3,
  PhoneCall, CreditCard, Home, UserCog, FileText, FolderKanban,
  Receipt, Link2, KeyRound, Settings2, LogOut, MapPin
} from 'lucide-react';
import './Sidebar.css';

const leadsSubItems = [
  { path: '/leads', icon: List, label: 'Total Leads' },
  { path: '/leads/fresh', icon: Sparkles, label: 'Fresh Leads' },
  { path: '/leads/imported', icon: Upload, label: 'Import Leads' },
  { path: '/leads/assigned', icon: UserPlus, label: 'Assign Leads' },
  { path: '/leads/non-assigned', icon: UserX, label: 'Non-Assign Leads' },
  { path: '/leads/add', icon: PlusCircle, label: 'Add Lead' },
  { path: '/leads/status-wise', icon: BarChart3, label: 'Status Wise' },
];

const followUpSubItems = [
  { path: '/followup/today', icon: PhoneCall, label: 'Today' },
  { path: '/followup/missed', icon: UserX, label: 'Missed' },
  { path: '/followup/upcoming', icon: UserCheck, label: 'Upcoming' },
];

const loanSubItems = [
  { path: '/loans', icon: List, label: 'All Loans' },
  { path: '/loans/add', icon: PlusCircle, label: 'Add Loan' },
];

const propertiesSubItems = [
  { path: '/properties/all', icon: List, label: 'All Properties' },
  { path: '/properties/add', icon: PlusCircle, label: 'Add Property' },
];

const brokerSubItems = [
  { path: '/brokers/list', icon: List, label: 'Broker List' },
  { path: '/brokers/add', icon: PlusCircle, label: 'Add Broker' },
];

const hrSubItems = [
  { path: '/hr/candidates', icon: Users, label: 'All Candidates' },
  { path: '/hr/candidates/add', icon: PlusCircle, label: 'Add Candidate' },
];

const attendanceSubItems = [
  { path: '/attendance/daily', icon: FileText, label: 'Daily Report' },
  { path: '/attendance/monthly', icon: BarChart3, label: 'Monthly Report' },
];

const usersSubItems = [
  { path: '/users/all', icon: List, label: 'All Users' },
  { path: '/users/add', icon: UserPlus, label: 'Add User' },
  { path: '/users/roles', icon: UserCog, label: 'Roles & Permissions' },
];


// ─── Reusable collapsible group ───────────────────────────────────────────────
const SidebarGroup = ({ icon: Icon, label, basePath, subItems, sidebarOpen }) => {
  const location = useLocation();
  const isActive = location.pathname.startsWith(basePath);
  const [open, setOpen] = useState(isActive);

  return (
    <div className="sidebar__group">
      <button
        className={`sidebar__link sidebar__link--parent ${isActive ? 'sidebar__link--active' : ''}`}
        onClick={() => setOpen((prev) => !prev)}
        title={label}
      >
        <Icon size={20} />
        {sidebarOpen && (
          <>
            <span>{label}</span>
            <ChevronDown
              size={16}
              className={`sidebar__chevron ${open ? 'sidebar__chevron--open' : ''}`}
            />
          </>
        )}
      </button>

      {sidebarOpen && open && (
        <div className="sidebar__submenu">
          {subItems.map((item) => (
            <NavLink
              key={item.path}
              to={item.path}
              end
              className={({ isActive }) =>
                `sidebar__sublink ${isActive ? 'sidebar__sublink--active' : ''}`
              }
            >
              <item.icon size={15} />
              <span>{item.label}</span>
            </NavLink>
          ))}
        </div>
      )}
    </div>
  );
};

// ─── Main Sidebar ─────────────────────────────────────────────────────────────
const Sidebar = () => {
  const { sidebarOpen, toggleSidebar } = useCRM();
  const { user, logout, clientData } = useAuth();

  return (
    <aside className={`sidebar ${sidebarOpen ? 'sidebar--open' : 'sidebar--collapsed'}`}>

      {/* Header / Logo */}
      <div className="sidebar__header">
        <div className="sidebar__logo">
          <div className="sidebar__logo-icon">
            <Crown size={22} />
          </div>
          {sidebarOpen && (
            <div className="sidebar__logo-text">
              <h1>Fortune</h1>
              <span>Real Estate CRM</span>
            </div>
          )}
        </div>
        <button className="sidebar__toggle" onClick={toggleSidebar}>
          {sidebarOpen ? <ChevronLeft size={18} /> : <ChevronRight size={18} />}
        </button>
      </div>

      {/* Navigation */}
      <nav className="sidebar__nav">

        {/* Dashboard */}
        <NavLink
          to="/"
          end
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="Dashboard"
        >
          <LayoutDashboard size={20} />
          {sidebarOpen && <span>Dashboard</span>}
        </NavLink>

        {/* Leads */}
        <SidebarGroup
          icon={Users}
          label="Leads"
          basePath="/leads"
          subItems={leadsSubItems}
          sidebarOpen={sidebarOpen}
        />

        {/* Follow up */}
        <NavLink
          to="/followup"
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="Follow up"
        >
          <PhoneCall size={20} />
          {sidebarOpen && <span>Follow up</span>}
        </NavLink>

        {/* Loan */}
        <SidebarGroup
          icon={CreditCard}
          label="Loan"
          basePath="/loans"
          subItems={loanSubItems}
          sidebarOpen={sidebarOpen}
        />

        {/* All Broker */}
        <SidebarGroup
          icon={Briefcase}
          label="All Broker"
          basePath="/brokers"
          subItems={brokerSubItems}
          sidebarOpen={sidebarOpen}
        />

        {/* Human Resources */}
        <SidebarGroup
          icon={UserCog}
          label="Human Resources"
          basePath="/hr"
          subItems={hrSubItems}
          sidebarOpen={sidebarOpen}
        />

        {/* Attendance Report */}
        <SidebarGroup
          icon={CalendarClock}
          label="Attendance Report"
          basePath="/attendance"
          subItems={attendanceSubItems}
          sidebarOpen={sidebarOpen}
        />

        {/* Track Team */}
        <NavLink
          to="/track-team"
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="Track Team"
        >
          <MapPin size={20} />
          {sidebarOpen && <span>Track Team</span>}
        </NavLink>

        {/* Users */}
        <SidebarGroup
          icon={Users}
          label="Users"
          basePath="/users"
          subItems={usersSubItems}
          sidebarOpen={sidebarOpen}
        />

        {/* Dynamic Fields */}
        <NavLink
          to="/dynamic-fields"
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="Dynamic Fields"
        >
          <Settings2 size={20} />
          {sidebarOpen && <span>Dynamic Fields</span>}
        </NavLink>

        {/* PaySlip */}
        <NavLink
          to="/payslip"
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="PaySlip"
        >
          <Receipt size={20} />
          {sidebarOpen && <span>PaySlip</span>}
        </NavLink>

        {/* API Integration */}
        <NavLink
          to="/api-integration"
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="API Integration"
        >
          <Link2 size={20} />
          {sidebarOpen && <span>API Integration</span>}
        </NavLink>

        {/* Change Password */}
        <NavLink
          to="/change-password"
          className={({ isActive }) => `sidebar__link ${isActive ? 'sidebar__link--active' : ''}`}
          title="Change Password"
        >
          <KeyRound size={20} />
          {sidebarOpen && <span>Change Password</span>}
        </NavLink>

      </nav>

      {/* Footer */}
      <div className="sidebar__footer">
        <div className="sidebar__user">
          <div className="sidebar__user-avatar">
            <Building2 size={16} />
          </div>
          {sidebarOpen && (
            <div className="sidebar__user-info">
              <p className="sidebar__user-name">{user?.name || clientData?.companyName || 'User'}</p>
              <p className="sidebar__user-role">{user?.role_name || 'Admin'}</p>
            </div>
          )}
        </div>
        {sidebarOpen && (
          <button onClick={logout} className="sidebar__logout" title="Logout" style={{ background: 'none', border: 'none', color: 'rgba(255,255,255,0.5)', cursor: 'pointer', padding: '6px', borderRadius: 6 }}>
            <LogOut size={16} />
          </button>
        )}
      </div>

    </aside>
  );
};

export default Sidebar;
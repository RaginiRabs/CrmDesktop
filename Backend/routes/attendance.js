/**
 * Attendance Routes
 */

const express = require('express');
const router = express.Router();
const attendanceController = require('../controllers/attendanceController');
const { authenticate } = require('../middleware/auth');

// All routes require authentication
router.use(authenticate);

// Get today's status
router.get('/today', attendanceController.getTodayStatus);

// Punch in
router.post('/punch-in', attendanceController.punchIn);

// Punch out
router.post('/punch-out', attendanceController.punchOut);

// Get history
router.get('/history', attendanceController.getHistory);

// Get monthly stats
router.get('/stats', attendanceController.getStats);

// Admin reports (master/admin only)
router.get('/admin/daily', attendanceController.getAdminDailyReport);
router.get('/admin/monthly', attendanceController.getAdminMonthlyReport);
router.get('/admin/user-detail', attendanceController.getAdminUserDetail);

module.exports = router;
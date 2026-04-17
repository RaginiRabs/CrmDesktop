const express = require('express');
const router = express.Router();
const loanController = require('../controllers/loanController');

// Create loan
router.post('/', loanController.createLoan);

// Get all loans
router.get('/', loanController.getAllLoans);

// Get loan stats
router.get('/stats', loanController.getLoanStats);

// Get loan by ID
router.get('/:id', loanController.getLoanById);

// Update loan
router.put('/:id', loanController.updateLoan);

// Delete loan
router.delete('/:id', loanController.deleteLoan);

module.exports = router;

const Loan = require('../models/Loan');

// Create loan
exports.createLoan = async (req, res) => {
  try {
    const clientCode = req.headers['x-client-db'];
    if (!clientCode) {
      return res.status(400).json({ success: false, message: 'Client code required' });
    }

    const { applicant_name, applicant_phone, applicant_email, loan_amount, loan_type } = req.body;

    if (!applicant_name || !applicant_phone || !loan_amount || !loan_type) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields: applicant_name, applicant_phone, loan_amount, loan_type',
      });
    }

    const result = await Loan.create({
      ...req.body,
      created_by: req.user?.id || 'system',
      client_code: clientCode,
    });

    res.status(result.success ? 201 : 400).json(result);
  } catch (err) {
    console.error('Create loan error:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Get all loans
exports.getAllLoans = async (req, res) => {
  try {
    const clientCode = req.headers['x-client-db'];
    if (!clientCode) {
      return res.status(400).json({ success: false, message: 'Client code required' });
    }

    const filters = {
      status: req.query.status,
      search: req.query.search,
      loan_type: req.query.loan_type,
      page: parseInt(req.query.page) || 1,
      limit: parseInt(req.query.limit) || 20,
    };

    const result = await Loan.getAll(filters, clientCode);
    res.json(result);
  } catch (err) {
    console.error('Get all loans error:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Get loan by ID
exports.getLoanById = async (req, res) => {
  try {
    const clientCode = req.headers['x-client-db'];
    if (!clientCode) {
      return res.status(400).json({ success: false, message: 'Client code required' });
    }

    const result = await Loan.getById(req.params.id, clientCode);
    res.status(result.success ? 200 : 404).json(result);
  } catch (err) {
    console.error('Get loan by ID error:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Update loan
exports.updateLoan = async (req, res) => {
  try {
    const clientCode = req.headers['x-client-db'];
    if (!clientCode) {
      return res.status(400).json({ success: false, message: 'Client code required' });
    }

    const result = await Loan.update(req.params.id, req.body, clientCode);
    res.json(result);
  } catch (err) {
    console.error('Update loan error:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Delete loan
exports.deleteLoan = async (req, res) => {
  try {
    const clientCode = req.headers['x-client-db'];
    if (!clientCode) {
      return res.status(400).json({ success: false, message: 'Client code required' });
    }

    const result = await Loan.delete(req.params.id, clientCode);
    res.json(result);
  } catch (err) {
    console.error('Delete loan error:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

// Get loan stats
exports.getLoanStats = async (req, res) => {
  try {
    const clientCode = req.headers['x-client-db'];
    if (!clientCode) {
      return res.status(400).json({ success: false, message: 'Client code required' });
    }

    const result = await Loan.getStats(clientCode);
    res.json(result);
  } catch (err) {
    console.error('Get loan stats error:', err);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

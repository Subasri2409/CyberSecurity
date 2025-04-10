const express = require('express');
const User = require('../models/user');
const Incident = require('../models/Incident');
// const Report = require('../models/Report');
const { authenticate, authorizeAdmin } = require('../middleware/authMiddleware');

const router = express.Router();

// Get all users
router.get('/users', authenticate, authorizeAdmin, async (req, res) => {
    try {
        const users = await User.find().select('-password_hash');
        res.json(users);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete a user
router.delete('/users/:id', authenticate, authorizeAdmin, async (req, res) => {
    try {
        await User.findByIdAndDelete(req.params.id);
        res.json({ message: 'User deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get all incidents
router.get('/incidents', authenticate, authorizeAdmin, async (req, res) => {
    try {
        const incidents = await Incident.find();
        res.json(incidents);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update incident status
router.put('/incidents/:id', authenticate, authorizeAdmin, async (req, res) => {
    try {
        const { status } = req.body;
        await Incident.findByIdAndUpdate(req.params.id, { status });
        res.json({ message: 'Incident status updated' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get reports summary
router.get('/reports', authenticate, authorizeAdmin, async (req, res) => {
    try {
        const reports = await Report.find();
        res.json(reports);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;

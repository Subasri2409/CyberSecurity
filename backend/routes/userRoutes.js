const express = require('express');
const Incident = require('../models/Incident');
const Alert = require('../models/Alert');
const { authenticate } = require('../middleware/authMiddleware');

const router = express.Router();

// Report an incident
router.post('/report', authenticate, async (req, res) => {
    try {
        const { incident_type, description } = req.body;
        const newIncident = new Incident({
            user_id: req.user.userId,
            incident_type,
            description,
            status: 'pending',
        });
        await newIncident.save();
        res.status(201).json({ message: 'Incident reported successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get user's reported incidents
router.get('/incidents', authenticate, async (req, res) => {
    try {
        const incidents = await Incident.find({ user_id: req.user.userId });
        res.json(incidents);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get scam alerts
router.get('/alerts', authenticate, async (req, res) => {
    try {
        const alerts = await Alert.find();
        res.json(alerts);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;

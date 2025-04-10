const express = require("express");
const ScamAlert = require("../models/ScamAlert");
const { authenticate } = require("../middleware/authMiddleware");

const router = express.Router();

// Get all scam alerts
router.get("/alerts", authenticate, async (req, res) => {
    try {
        const alerts = await ScamAlert.find();
        res.json(alerts);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;

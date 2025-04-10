const express = require("express");
const Notification = require("../models/Notification");
const { authenticate } = require("../middleware/authMiddleware");

const router = express.Router();

// Get all notifications for the logged-in user
router.get("/notifications", authenticate, async (req, res) => {
    try {
        const notifications = await Notification.find({ user_id: req.user.userId });
        res.json(notifications);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;

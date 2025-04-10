const express = require("express");
const Incident = require("../models/Incident");
const { authenticate } = require("../middleware/authMiddleware");

const router = express.Router();

// Report a new incident
router.post("/report", authenticate, async (req, res) => {
    try {
        const { incident_type, description } = req.body;
        const newIncident = new Incident({
            user_id: req.user.userId,
            incident_type,
            description,
            status: "pending",
        });

        await newIncident.save();
        res.status(201).json({ message: "Incident reported successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});
const storage = multer.diskStorage({
    destination: "./uploads/",
    filename: (req, file, cb) => {
      cb(null, Date.now() + path.extname(file.originalname)); // Rename file
    },
  });
  
  const upload = multer({ storage });
  
  // REPORT INCIDENT
  router.post("/report", upload.single("incidentImage"), async (req, res) => {
    try {
      const { title, description } = req.body;
      const incidentImage = req.file ? req.file.filename : null;
  
      const newIncident = new Incident({
        title,
        description,
        incidentImage,
      });
  
      await newIncident.save();
      res.status(200).json({ msg: "Incident reported successfully!" });
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });
  
  
// Get all incidents of the logged-in user
router.get("/my-incidents", authenticate, async (req, res) => {
    try {
        const incidents = await Incident.find({ user_id: req.user.userId });
        res.json(incidents);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;

const mongoose = require("mongoose");

const IncidentSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String, required: true },
  incidentImage: { type: String, required: false }, // Image filename stored
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Incident", IncidentSchema);

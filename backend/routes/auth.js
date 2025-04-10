const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");

const router = express.Router();

// User Registration
router.post("/register", async (req, res) => {
  const { name, email, phone_number, gender, password, role } = req.body;

  try {
    let user = await User.findOne({ email });
    if (user) return res.status(400).json({ msg: "User already exists" });

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    user = new User({ name, email, phone_number, gender, password: hashedPassword, role });

    await user.save();
    res.status(201).json({ msg: "User registered successfully" });

  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

// User Login
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    let user = await User.findOne({ email });
    if (!user) return res.status(400).json({ msg: "User not found" });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ msg: "Invalid credentials" });

    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET, { expiresIn: "1h" });

    res.json({ token, role: user.role });
  } catch (err) {
    res.status(500).json({ msg: err.message });
  }
});

// Middleware for Role-based Access
const authMiddleware = (roles) => (req, res, next) => {
  const token = req.header("Authorization");
  if (!token) return res.status(401).json({ msg: "No token, authorization denied" });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    if (!roles.includes(decoded.role)) return res.status(403).json({ msg: "Access Denied" });

    req.user = decoded;
    next();
  } catch (err) {
    res.status(401).json({ msg: "Invalid Token" });
  }
};

router.get("/admin", authMiddleware(["admin"]), (req, res) => {
  res.json({ msg: "Admin access granted" });
});

module.exports = router;

const express = require("express");
const multer = require("multer");
const cors = require("cors");
const path = require("path");
const fs = require("fs");

const app = express();
app.use(cors());
app.use(express.json());

// Create uploads directory if it doesn't exist
const uploadDir = path.join(__dirname, "uploads");
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Configure multer storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "_" + Math.round(Math.random() * 1e9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  },
});

const upload = multer({ storage });

// Upload endpoint
app.post("/upload-id", upload.fields([{ name: "frontId" }, { name: "backId" }]), (req, res) => {
  try {
    const frontFile = req.files["frontId"]?.[0];
    const backFile = req.files["backId"]?.[0];

    if (!frontFile || !backFile) {
      return res.status(400).json({ message: "Both front and back ID files are required." });
    }

    res.json({
      message: "ID uploaded successfully",
      frontUrl: `http://localhost:3000/uploads/${frontFile.filename}`,
      backUrl: `http://localhost:3000/uploads/${backFile.filename}`,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Server error" });
  }
});

// Serve uploaded files
app.use("/uploads", express.static(uploadDir));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
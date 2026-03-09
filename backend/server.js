const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");

const app = express();

app.use(cors());
app.use(express.json());

if (!process.env.FIREBASE_KEY) {
  console.error("FIREBASE_KEY environment variable is missing.");
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_KEY)),
});

const db = admin.firestore();

app.get("/", (req, res) => {
  res.send("UNIEVENT Backend çalışıyor 🚀");
});

app.get("/api/events", async (req, res) => {
  try {
    const snapshot = await db.collection("events").get();

    const data = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(data);
  } catch (error) {
    console.error("Error fetching events:", error);
    res.status(500).json({ error: "Hata oluştu" });
  }
});

app.get("/api/events/:id", async (req, res) => {
  try {
    const eventId = req.params.id;

    const doc = await db.collection("events").doc(eventId).get();

    if (!doc.exists) {
      return res.status(404).json({ error: "Etkinlik bulunamadı" });
    }

    const eventData = {
      id: doc.id,
      ...doc.data(),
    };

    res.json(eventData);
  } catch (error) {
    console.error("Error fetching event details:", error);
    res.status(500).json({ error: "Hata oluştu" });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
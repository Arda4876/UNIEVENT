const express = require("express");
const admin = require("firebase-admin");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

admin.initializeApp({
  credential: admin.credential.cert(
    JSON.parse(process.env.FIREBASE_KEY)
  ),
});

const db = admin.firestore();

app.get("/", (req, res) => {
  res.send("UNIEVENT Backend çalisiyor");
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
    console.error(error);
    res.status(500).send("Hata oluştu");
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
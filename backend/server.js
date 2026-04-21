const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");
const bcrypt = require("bcrypt"); // Şifreleme için eklendi

const app = express();

app.use(cors());
app.use(express.json());

// Firebase Yetkilendirme Kontrolü
if (!process.env.FIREBASE_KEY) {
  console.error("FIREBASE_KEY environment variable is missing.");
  process.exit(1);
}

// Firebase Başlatma
admin.initializeApp({
  credential: admin.credential.cert(JSON.parse(process.env.FIREBASE_KEY)),
});

const db = admin.firestore();

// --- TEMEL UÇ NOKTA ---
app.get("/", (req, res) => {
  res.send("UNIEVENT Backend çalışıyor 🚀");
});

// --- ETKİNLİK (EVENTS) UÇLARI ---

// 1. Tüm etkinlikleri getir veya isme göre ara
app.get("/api/events", async (req, res) => {
  try {
    const searchQuery = req.query.search;
    const snapshot = await db.collection("events").get();

    let events = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    // Arama (Search) Altyapısı
    if (searchQuery) {
      const searchLower = searchQuery.toLowerCase();
      events = events.filter((event) =>
        event.title.toLowerCase().includes(searchLower)
      );
    }

    res.json(events);
  } catch (error) {
    console.error("Error fetching events:", error);
    res.status(500).json({ error: "Hata oluştu" });
  }
});

// 2. Sadece belirli bir etkinliğin detaylarını getir
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

// --- AUTH (KAYIT VE GİRİŞ) UÇLARI ---

// 1. KAYIT OL (Register) API'si
app.post("/api/auth/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ error: "Lütfen ad, e-posta ve şifre alanlarını doldurun." });
    }

    const usersRef = db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (!snapshot.empty) {
      return res.status(400).json({ error: "Bu e-posta adresi zaten kullanımda." });
    }

    // Şifreyi güvenli hale getir
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);

    const newUser = {
      name: name,
      email: email,
      password: hashedPassword,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    const docRef = await usersRef.add(newUser);
    res.status(201).json({ message: "Kayıt başarıyla oluşturuldu", userId: docRef.id });

  } catch (error) {
    console.error("Kayıt hatası:", error);
    res.status(500).json({ error: "Kayıt işlemi sırasında bir hata oluştu." });
  }
});

// 2. GİRİŞ YAP (Login) API'si
app.post("/api/auth/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: "Lütfen e-posta ve şifrenizi girin." });
    }

    const usersRef = db.collection("users");
    const snapshot = await usersRef.where("email", "==", email).get();

    if (snapshot.empty) {
      return res.status(404).json({ error: "Bu e-posta adresine ait kullanıcı bulunamadı." });
    }

    let userData;
    let userId;
    snapshot.forEach(doc => {
      userId = doc.id;
      userData = doc.data();
    });

    // Şifre karşılaştırması
    const isPasswordValid = await bcrypt.compare(password, userData.password);

    if (!isPasswordValid) {
      return res.status(401).json({ error: "Hatalı şifre girdiniz." });
    }

    res.status(200).json({ 
      message: "Giriş başarılı", 
      user: { id: userId, name: userData.name, email: userData.email } 
    });

  } catch (error) {
    console.error("Giriş hatası:", error);
    res.status(500).json({ error: "Giriş işlemi sırasında bir hata oluştu." });
  }
});

// --- SUNUCU BAŞLATMA ---
const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
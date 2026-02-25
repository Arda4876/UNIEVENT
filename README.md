# UniEventAI

**UniEventAI**, Türkiye genelindeki tüm üniversitelerin web sitelerinden, kulüp sayfalarından ve duyuru panellerinden etkinlik, seminer, konferans ve kulüp faaliyetleri bilgilerini otomatik olarak toplayan (Web Scraping) yapay zekâ destekli bir mobil platformdur.

Toplanan ham veriler, Doğal Dil İşleme (NLP) ile sınıflandırılır (konu, tarih, yer). Yapay zekâ, öğrencilerin ilgi alanlarına, bulundukları şehre ve geçmiş etkileşimlerine göre kişiselleştirilmiş etkinlik önerileri sunar. Etkinliklerin dışarıdan katılıma açık olup olmadığı belirtilir ve biletli etkinlikler için doğrudan bilet alım linki kullanıcıya sunulur.

## Proje Amacı ve Hedefler
- Türkiye genelindeki üniversite etkinliklerinin bilgi kirliliği ve erişim zorluğu nedeniyle öğrencilere ulaşamaması sorununu çözmek.
- Nihai hedef: Türkiye'deki tüm üniversite web sitelerinden etkinlik verilerini otomatik toplayıp (Scraping), öğrencilerin ilgi alanlarına göre yapay zekâ destekli kişiselleştirilmiş öneriler sunan, dışarıdan katılım ve biletleme linki gibi kritik bilgileri içeren, dijital, ulusal ve etkileşimli bir mobil etkinlik platformu oluşturmaktır.

## Kullanılacak Teknolojiler
- Yazılım: **Flutter** (mobil), **Python** (AI / Scrapers), **Node.js** (backend)
- Veritabanı: **Firebase** / **MongoDB**
- Diğer Araçlar: GitHub, Figma, Canva, OpenAI API

## Klasör Yapısı (ilk öneri)
- `mobile/flutter_app` — Flutter/Dart uygulaması
- `backend/nodejs` — Node.js API
- `ai/python` — Scraper, NLP ve öneri model kodları
- `data/raw` ve `data/processed` — ham ve işlenmiş veriler
- `docs` — proje dokümantasyonu
- `designs` — tasarım dosyaları
- `infra` — deployment / docker
- `scripts` — yardımcı scriptler
- `tests` — testler
- `.github` — CI/CD workflow

## Hızlı Başlangıç
1. Flutter ortamı kurun (SDK + IDE).  
2. Python ortamı oluşturun ve `ai/python/requirements.txt` dosyasındaki bağımlılıkları kurun.  
3. Backend için Node.js kurun ve `backend/README.md` içindeki yönergeleri takip edin.

---

> Daha fazla detayı `docs/PROJECT.md` içinde bulabilirsiniz.

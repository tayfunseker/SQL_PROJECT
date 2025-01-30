# 📊 SQL ile E-Ticaret Verisi Üzerinde Gelişmiş Analizler

Bu proje, bir e-ticaret veri seti üzerinde **RFM Analizi**, **Satış Analizi**, **Müşteri Analizi**, **Satıcı Analizi** ve **Ödeme Tipleri Analizi** içeren SQL sorgularını içermektedir. 

## 🚀 Projede Yapılan Analizler

### 1️⃣ Sipariş Analizi
- Aylık sipariş dağılımı ve sipariş durumlarına göre analiz
- Ürün kategorisi bazında sipariş trendleri ve özel günlerde (Yılbaşı, Sevgililer Günü, Black Friday vb.) en çok satılan kategorilerin belirlenmesi
- Haftanın günleri ve ayın günleri bazında sipariş analizleri

### 2️⃣ Müşteri Analizi
- En çok sipariş verilen şehirlerin analizi (Her müşterinin en çok sipariş verdiği şehir baz alınarak)
- Müşterilerin sipariş alışkanlıklarına göre segmentasyonu

### 3️⃣ Satıcı Analizi
- En hızlı teslimat yapan satıcıların belirlenmesi (ortalama teslim süresi baz alınarak)
- Kategori bazında en fazla ürün satan satıcıların belirlenmesi
- Satıcıların sipariş sayıları ile ürün yorumları ve puanlamalarının ilişkilendirilmesi

### 4️⃣ Ödeme Analizi
- Taksit sayısı fazla olan müşterilerin bölgesel dağılımı
- Ödeme tipine göre başarılı sipariş sayısı ve toplam ödeme tutarlarının analizi
- Kategori bazında tek çekim ve taksitli ödeme alışkanlıklarının karşılaştırılması

### 5️⃣ RFM Analizi
- **Recency (En son sipariş tarihi baz alınarak hesaplandı)**
- **Frequency (Tekrarlayan sipariş sayısı baz alındı)**
- **Monetary (Müşterilerin toplam harcama tutarları hesaplandı)**
- **Müşteriler 5’li segmentlere ayrılarak (NTILE(5)) RFM skoru oluşturuldu.**
- **Müşterilerin RFM skorlarına göre segmente edilmesi yapıldı.**

## 📁 Kullanılan SQL Teknikleri
✅ **CTE (Common Table Expressions) ve WITH kullanımı**  
✅ **JOIN ile çoklu tablo analizleri**  
✅ **GROUP BY ve HAVING ile istatistiksel analizler**  
✅ **CASE WHEN ile koşullu segmentasyon**  
✅ **NTILE ile müşteri segmentasyonu**  
✅ **AGE ve DATE_TRUNC ile zaman bazlı analizler**  
✅ **ROW_NUMBER ve PARTITION BY ile sıralama işlemleri**  

## 📌 Veri Kaynakları
Bu çalışmada kullanılan veri seti, bir e-ticaret platformundan alınmıştır. Veri seti; siparişler, müşteriler, satıcılar, ödeme işlemleri ve ürün kategorileri gibi çeşitli tablolar içermektedir.

## 📊 Çıktıların Görselleştirilmesi
SQL ile elde edilen sonuçlar **Excel, Power BI ** gibi araçlarla görselleştirilerek trend analizleri yapılmıştır.

## 📎 Kullanım
Bu SQL sorgularını **PostgreSQL** üzerinde çalıştırarak benzer analizleri kendi veri setiniz üzerinde gerçekleştirebilirsiniz.

**📢 Projeye katkıda bulunmak isterseniz pull request gönderebilirsiniz!**  

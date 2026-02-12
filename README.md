Dengan menerapkan prinsip Single Responsibility Principle, setiap komponen dalam proyek memiliki tanggung jawab yang jelas. Controller hanya menangani logika dan perhitungan, sedangkan View hanya menangani tampilan dan interaksi pengguna.

Ketika saya menambahkan fitur History Logger, saya tidak perlu mengubah struktur utama aplikasi secara besar-besaran. Saya cukup menambahkan mekanisme pencatatan riwayat di dalam Controller tanpa mengganggu kode pada View. Karena logika sudah terpusat di Controller, setiap aksi seperti increment, decrement, dan reset bisa langsung dicatat tanpa perlu menyentuh bagian UI. Hal ini membuat proses pengembangan lebih terstruktur, mudah dipahami, dan mengurangi risiko bug.

SRP membantu dalam
- Menambah fitur tanpa merusak kode yang sudah ada.
- Menjaga kode tetap rapi dan terorganisir.
- Mempermudah debugging dan pengembangan lanjutan.
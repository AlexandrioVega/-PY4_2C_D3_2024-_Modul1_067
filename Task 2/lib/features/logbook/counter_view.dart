import 'package:flutter/material.dart';
import 'package:logbook_app_001/features/logbook/counter_controller.dart';
import 'package:logbook_app_001/features/onboarding/onboarding_view.dart';

class CounterView extends StatefulWidget {
  // Tambahkan variabel final untuk menampung nama
  final String username;

  // Update Constructor agar mewajibkan (required) kiriman nama
  const CounterView({super.key, required this.username});


  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();
  final TextEditingController _stepTextController = TextEditingController(text: '1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Gunakan widget.username untuk menampilkan data dari kelas utama
        title: Text("Logbook: ${widget.username}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Kita siapkan tombol logout di sini untuk Fase 3 nanti
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 1. Munculkan Dialog Konfirmasi
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Logout"),
                    content: const Text("Apakah Anda yakin? Data yang belum disimpan mungkin akan hilang."),
                    actions: [
                      // Tombol Batal
                      TextButton(
                        onPressed: () => Navigator.pop(context), // Menutup dialog saja
                        child: const Text("Batal"),
                      ),
                      // Tombol Ya, Logout
                      TextButton(
                        onPressed: () {
                          // Menutup dialog
                          Navigator.pop(context); 
                          
                          // 2. Navigasi kembali ke Onboarding (Membersihkan Stack)
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const OnboardingView()),
                            (route) => false,
                          );
                        },
                        child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },

          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Total Hitungan"),
            Text(
              '${_controller.counter}',
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: 140,
              child: TextField(
                controller: _stepTextController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  labelText: 'Step',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  final step = int.tryParse(value);
                  if (step != null) {
                    _controller.changeStep(step);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controller.decrement();
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 12),
                
                ElevatedButton(
                  onPressed: _confirmReset,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 12),
                
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _controller.increment();
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Riwayat Aktivitas (5 Terakhir)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),
            Expanded(
              child: _controller.history.isEmpty
                  ? const Center(
                      child: Text("Belum ada aktivitas"),
                    )
                  : ListView.builder(
                      itemCount: _controller.history.length,
                      itemBuilder: (context, index) {
                        final item = _controller.history[index];
                        Color textColor;

                        switch (item.type) {
                          case ActivityType.increment:
                            textColor = Colors.greenAccent.shade700;
                            break;
                          case ActivityType.decrement:
                            textColor = Colors.red.shade500;
                            break;
                          case ActivityType.reset:
                            textColor = Colors.orange.shade400;
                            break;
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: textColor.withOpacity(0.08),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: textColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.message,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
  void _confirmReset() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Konfirmasi Reset"),
        content: const Text(
          "Apakah Anda yakin ingin mereset semua data?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 

              setState(() {
                _controller.reset();
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8),
                      Text("Data berhasil direset"),
                    ],
                  ),
                  backgroundColor: Colors.orange.shade400,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              "Ya",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
}

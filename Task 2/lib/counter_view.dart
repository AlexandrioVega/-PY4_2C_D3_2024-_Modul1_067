import 'package:flutter/material.dart';
import 'counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();
  final TextEditingController _stepTextController = TextEditingController(text: '1');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LogBook: Versi SRP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Total Hitungan"),
            Text(
              '${_controller.value}',
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
                const SnackBar(
                  content: Text("Data berhasil direset"),
                  duration: Duration(seconds: 2),
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

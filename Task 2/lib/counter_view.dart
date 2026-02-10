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
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(_controller.history[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      
      floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          heroTag: 'decrement',
          onPressed: () => setState(() {
            _controller.decrement();
          }),
          child: const Icon(Icons.remove),
        ),
        const SizedBox(width: 12),
        
        FloatingActionButton(
          heroTag: 'reset',
          onPressed: () => setState(() {
            _controller.reset();
          }),
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 12),

        FloatingActionButton(
          heroTag: 'increment',
          onPressed: () => setState(() {
            _controller.increment();
          }),
          child: const Icon(Icons.add),
        ),
        ],
      ),
    );
  }
}

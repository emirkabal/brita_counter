import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const BritaApp());
}

class BritaApp extends StatelessWidget {
  const BritaApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Brita Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 2, 62, 117)),
        useMaterial3: true,
      ),
      home: const FilterLifetime(title: 'Water Filter Counter'),
    );
  }
}

class FilterLifetime extends StatefulWidget {
  const FilterLifetime({super.key, required this.title});

  final String title;

  @override
  State<FilterLifetime> createState() => _FilterLifetimeState();
}

class _FilterLifetimeState extends State<FilterLifetime> {
  int liters = 0;
  final TextEditingController _controller = TextEditingController(text: '5');

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      liters = prefs.getInt('liters_total') ?? 0;
      _controller.text = prefs.getString('liters_increment') ?? '5';
    });
  }

  void _saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('liters_total', liters);
    prefs.setString('liters_increment', _controller.text);
  }

  String get _filterLifeLabel {
    if (liters == 150) {
      return 'Filtre değişimi gerekli';
    } else if (liters >= 120) {
      return 'Filtre değişimi yaklaşıyor';
    } else {
      return 'Filtre sağlıklı';
    }
  }

  Color get _filterLifeColor {
    if (liters == 150) {
      return const Color.fromARGB(255, 172, 18, 18);
    } else if (liters >= 120) {
      return const Color.fromARGB(255, 45, 131, 211);
    } else {
      return const Color.fromARGB(255, 2, 62, 117);
    }
  }

  void _incrementCounter() {
    setState(() {
      int val = int.tryParse(_controller.text) ?? 0;

      if (liters + val > 150) {
        liters = 150;
        return;
      }

      liters += val;

      _saveState();
    });
  }

  void _decrementCounter() {
    setState(() {
      int val = int.tryParse(_controller.text) ?? 0;

      if (liters - val < 0) {
        liters = 0;
        return;
      }

      liters -= val;

      _saveState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/brita.png', height: 64),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _filterLifeLabel,
              style: TextStyle(
                color: _filterLifeColor,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Filtrelenen su miktarı:',
            ),
            Text(
              '$liters L',
              style: TextStyle(
                fontSize: 48,
                color: _filterLifeColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _decrementCounter,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: const Text('Çıkar',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 172, 18, 18),
                      fixedSize: const Size(100, 56),
                      padding: EdgeInsets.zero),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 125,
                  height: 56,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Litre Girin',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: const Text('Ekle',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 2, 62, 117),
                    fixedSize: const Size(100, 56),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Text(
        'Bu uygulama Brita\'ya bağlı bir uygulama değildir. www.emirkabal.com',
        style: TextStyle(color: Colors.black54, fontSize: 14, height: 2),
        textAlign: TextAlign.center,
      ),
    );
  }
}

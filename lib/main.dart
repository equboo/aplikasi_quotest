// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuotesProvider(),
      child: MaterialApp(
        title: 'Quotes Inspiratif Harian',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: QuotesScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class QuotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quotes Inspiratif Harian',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quotesProvider.dailyQuote,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  quotesProvider.generateRandomQuote();
                },
                child: Text('Dapatkan Kutipan Baru'),
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  quotesProvider.toggleFavorite();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuotesProvider with ChangeNotifier {
  List<String> _quotes = [
    'Hidup adalah petualangan berani atau tidak sama sekali.',
    'Kesempatan tidak terjadi begitu saja. Kamu yang menciptakannya.',
    'Masa depan adalah milik mereka yang percaya pada keindahan mimpi mereka.',
  ];

  String _dailyQuote =
      'Hidup adalah petualangan berani atau tidak sama sekali.';
  bool _isFavorite = false;

  String get dailyQuote => _dailyQuote;
  bool get isFavorite => _isFavorite;

  void generateRandomQuote() {
    int newIndex = (DateTime.now().millisecondsSinceEpoch % _quotes.length);
    _dailyQuote = _quotes[newIndex];
    notifyListeners();
  }

  void toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFavorite = !_isFavorite;
    await prefs.setBool('isFavorite', _isFavorite);
    notifyListeners();
  }
}

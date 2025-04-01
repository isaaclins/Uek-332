import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello HTTP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 93, 0, 255)),
      ),
      home: const HelloHttpPage(),
    );
  }
}

class HelloHttpPage extends StatefulWidget {
  const HelloHttpPage({super.key});

  @override
  State<HelloHttpPage> createState() => _HelloHttpPageState();
}

class _HelloHttpPageState extends State<HelloHttpPage> {
  bool _isLoading = false;
  String _response = '';

  Future<void> _sendHttpRequest() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    final url = Uri.parse('https://httpbin.org/post');
    final payload = {
      'deviceTime': DateTime.now().toIso8601String(),
      'deviceInfo': 'Flutter OS ${Theme.of(context).platform}',
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _response = 'JSON: ${responseData['json']}';
        });
      } else {
        setState(() {
          _response = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _response = 'Network error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello HTTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _sendHttpRequest,
              child: const Text('Hello HTTP Service'),
            ),
            if (_isLoading) const CircularProgressIndicator(),
            if (_response.isNotEmpty) Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_response),
            ),
          ],
        ),
      ),
    );
  }
}

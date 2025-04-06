import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clipboard/clipboard.dart'; // ✅ ② インポート追加

void main() {
  runApp(SummarizerApp());
}

class SummarizerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Summarizer',
      theme: ThemeData(
        fontFamily: 'NotoSansJP',
      ),
      home: SummarizerPage(),
    );
  }
}

class SummarizerPage extends StatefulWidget {
  @override
  _SummarizerPageState createState() => _SummarizerPageState();
}

class _SummarizerPageState extends State<SummarizerPage> {
  final _controller = TextEditingController();
  String _summary = '';
  List<String> _keywords = [];
  bool _loading = false;

  Future<void> _summarizeText() async {
    setState(() {
      _loading = true;
      _summary = '';
      _keywords = [];
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/summarize');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": _controller.text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _summary = data['summary'];
          _keywords = List<String>.from(data['keywords']);
        });
      } else {
        setState(() {
          _summary = 'エラーが発生しました。';
        });
      }
    } catch (e) {
      setState(() {
        _summary = '通信エラーが発生しました。';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('自動要約＆キーワード抽出')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'ここに文章を入力してください',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _summarizeText,
              child: Text(_loading ? '処理中...' : '要約する'),
            ),
            SizedBox(height: 24),
            if (_summary.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    '📝 要約:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.copy),
                    tooltip: 'コピー',
                    onPressed: () {
                      FlutterClipboard.copy(_summary).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("要約をコピーしました！")),
                        );
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                _summary,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '🔑 キーワード:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              for (var kw in _keywords)
                Text(
                  '・$kw',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

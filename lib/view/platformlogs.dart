import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlatformLogsPage extends StatefulWidget {
  @override
  _PlatformLogsPageState createState() => _PlatformLogsPageState();
}

class _PlatformLogsPageState extends State<PlatformLogsPage> {
  List<String>? _platformLogs;

  @override
  void initState() {
    super.initState();
    _loadPlatformLogs();
  }

  Future<void> _loadPlatformLogs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _platformLogs = prefs.getStringList('platform_logs');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Logs'),
      ),
      body: _platformLogs == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _platformLogs!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_platformLogs![index]),
                );
              },
            ),
    );
  }
}

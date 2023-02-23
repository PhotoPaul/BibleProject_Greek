import 'dart:convert';

import 'package:bibleproject_greek/screens/widgets/reading_plan_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../configuration.dart';

class ReadingPlans extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReadingPlansState();
}

class _ReadingPlansState extends State<ReadingPlans> {
  bool _mounted = true;
  List<dynamic> _readingPlans = [];

  Future<List<dynamic>> _fetchReadingPlans() async {
    List _fetchedReadingPlans = [];

    http.Response response;
    var url = Uri.parse(API_URL + "?action=getPlans");
    try {
      response = await http.get(url);
      _fetchedReadingPlans = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
    return _fetchedReadingPlans;
  }

  Future<List<dynamic>> _fetchStoredReadingPlans() async {
    List<dynamic> _updatedReadingPlans;
    final sharedPrefs = await SharedPreferences.getInstance();
    final _storedReadingPlans = sharedPrefs.getString("readingPlans");
    if (_storedReadingPlans != null) {
      _updatedReadingPlans = jsonDecode(_storedReadingPlans);
    } else {
      _updatedReadingPlans = [];
    }
    return _updatedReadingPlans;
  }

  _storeReadingPlans(List<dynamic> _readingPlans) {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setString("readingPlans", jsonEncode(_readingPlans));
    });
  }

  _getReadingPlans() async {
    if (_readingPlans.length == 0) {
      List<dynamic> _fetchedReadingPlans = await _fetchStoredReadingPlans();
      setState(() {
        _readingPlans = _fetchedReadingPlans;
      });
    }
    _fetchReadingPlans().then((_fetchedReadingPlans) {
      if (_mounted) {
        setState(() {
          _readingPlans = _fetchedReadingPlans;
        });
      }
      _storeReadingPlans(_fetchedReadingPlans);
    });
  }

  @override
  void deactivate() {
    _mounted = false;
    super.deactivate();
  }

  @override
  void initState() {
    super.initState();
    _getReadingPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: RefreshIndicator(
        onRefresh: () async {
          _getReadingPlans();
        },
        child: ListView.builder(
            itemCount: _readingPlans.length,
            itemBuilder: (BuildContext context, int index) {
              return ReadingPlanWidget(data: _readingPlans[index]);
            }),
      ),
    );
  }
}

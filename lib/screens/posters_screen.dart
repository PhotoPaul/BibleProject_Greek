import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/poster_widget.dart';
import '../configuration.dart';

class PackagesScreen extends StatefulWidget {
  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  bool _mounted = true;
  List<dynamic> _packagelists = [];

  Future<List<dynamic>> _fetchPackagelists() async {
    List _fetchedPackagelists = [];

    http.Response response;
    var url = Uri.parse(API_URL + "?action=getPosters");
    try {
      response = await http.get(url);
      _fetchedPackagelists = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
    return _fetchedPackagelists;
  }

  Future<List<dynamic>> _fetchStoredPackagelists() async {
    List<dynamic> _updatedPackagelists;
    final sharedPrefs = await SharedPreferences.getInstance();
    final _storedPackagelists = sharedPrefs.getString("packagelists");
    if (_storedPackagelists != null) {
      _updatedPackagelists = jsonDecode(_storedPackagelists);
    } else {
      _updatedPackagelists = [];
    }
    return _updatedPackagelists;
  }

  _storePackagelists(List<dynamic> _packagelists) {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setString("packagelists", jsonEncode(_packagelists));
    });
  }

  _getPackagelists() async {
    if (_packagelists.length == 0) {
      List<dynamic> _fetchedPackagelists = await _fetchStoredPackagelists();
      setState(() {
        _packagelists = _fetchedPackagelists;
      });
    }
    _fetchPackagelists().then((_fetchedPackagelists) {
      if (_mounted) {
        setState(() {
          _packagelists = _fetchedPackagelists;
        });
      }
      _storePackagelists(_fetchedPackagelists);
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
    _getPackagelists();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: RefreshIndicator(
        onRefresh: () async {
          _getPackagelists();
        },
        child: ListView.builder(
            itemCount: _packagelists.length,
            itemBuilder: (BuildContext context, int i) {
              if (_packagelists[i]["videos"][0]["poster"] != null)
                return Column(
                  children: [
                    Text(_packagelists[i]["title"]),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: _packagelists[i]["videos"].length,
                        itemBuilder: (BuildContext context, int j) {
                          if (_packagelists[i]["videos"][j]["poster"] != null)
                            return PosterWidget(
                                data: _packagelists[i]["videos"][j]);
                          return null;
                        })
                  ],
                );
              return null;
            }),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bibleproject_greek/screens/widgets/playlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../configuration.dart';
import '../types/Playlist.dart';

class PlaylistsScreen extends StatefulWidget {
  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  bool _mounted = true;
  List<Poster> _playlists = [];

  Future<List<Poster>> _fetchPlaylists() async {
    List<Poster> _fetchedPlaylists = [];
    http.Response response;
    var url = Uri.parse(
        "https://www.googleapis.com/youtube/v3/playlists?part=snippet&maxResults=100&channelId=$YT_CHANNEL_ID&key=$YT_API_KEY");
    try {
      response = await http.get(url);
      var _playlistsJSON = json.decode(response.body)["items"];

      for (var i = 0; i < _playlistsJSON.length; i++) {
        _fetchedPlaylists.add(new Poster(
            id: _playlistsJSON[i]["id"],
            title: _playlistsJSON[i]["snippet"]["title"],
            description: _playlistsJSON[i]["snippet"]["description"],
            thumbnail: _playlistsJSON[i]["snippet"]["thumbnails"]["maxres"]
                ["url"]));
      }
      // Swap the first two items in the list
      if (_fetchedPlaylists.length >= 2) {
        _fetchedPlaylists
            .replaceRange(0, 2, [_fetchedPlaylists[1], _fetchedPlaylists[0]]);
      }
      return _fetchedPlaylists;
    } on http.ClientException catch (_) {
      // print("browser offline");
    } on SocketException catch (_) {
      // print("device offline");
    } catch (e) {
      // print("other error");
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Αποτυχία σύνδεσης με την βιβλιοθήκη πολυμέσων'),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: "ΑΝΑΝΕΩΣΗ",
        onPressed: () {
          _fetchPlaylists();
        },
      ),
    ));

    return [].map((val) => Poster.fromJson(val)).toList();
  }

  Future<List<Poster>> _fetchStoredPlaylists() async {
    List<Poster> _updatedPlaylists;
    final sharedPrefs = await SharedPreferences.getInstance();
    final _storedPlaylistsJSON = sharedPrefs.getString("playlists");
    if (_storedPlaylistsJSON != null) {
      List<dynamic> decodedList = jsonDecode(_storedPlaylistsJSON);
      _updatedPlaylists =
          decodedList.map((val) => Poster.fromJson(val)).toList();
    } else {
      _updatedPlaylists = [].map((val) => Poster.fromJson(val)).toList();
    }
    return _updatedPlaylists;
  }

  _storePlaylists(List<Poster> _updatedPlaylists) {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setString("playlists", jsonEncode(_updatedPlaylists));
    });
  }

  Future _getPlaylists() async {
    if (_playlists.length == 0) {
      List<Poster> _fetchedPlaylists = await _fetchStoredPlaylists();
      setState(() {
        _playlists = _fetchedPlaylists;
      });
    }

    _fetchPlaylists().then((_fetchedPlaylists) {
      if (_mounted) {
        setState(() {
          _playlists = _fetchedPlaylists;
        });
      }
      _storePlaylists(_fetchedPlaylists);
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
    _getPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RefreshIndicator(
          onRefresh: () async {
            _getPlaylists();
          },
          child: ListView.builder(
              itemCount: _playlists.length,
              itemBuilder: (BuildContext context, int index) {
                return PlaylistWidget(data: _playlists[index]);
              }),
        ),
      ),
    );
  }
}

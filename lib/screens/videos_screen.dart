import 'dart:io';

import 'package:bibleproject_greek/screens/widgets/video_widget.dart';
import 'package:bibleproject_greek/types/Video.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import '../configuration.dart';

class VideosPage extends StatefulWidget {
  final String playlistId;
  final String playlistTitle;
  VideosPage(this.playlistId, this.playlistTitle);

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool _mounted = true;
  List<Poster> _videos = [];

  Future<List<Poster>> _fetchVideos() async {
    List<Poster> _fetchedVideos = [];
    http.Response response;
    var url = Uri.parse(
        "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=100&playlistId=${widget.playlistId}&key=$YT_API_KEY");
    try {
      response = await http.get(url);
      var _videosJSON = json.decode(response.body)["items"];

      for (var i = 0; i < _videosJSON.length; i++) {
        if (_videosJSON[i]["snippet"]["thumbnails"].length != 0) {
          _fetchedVideos.add(new Poster(
              id: _videosJSON[i]["snippet"]["resourceId"]["videoId"],
              title: _videosJSON[i]["snippet"]["title"],
              description: _videosJSON[i]["snippet"]["description"],
              thumbnail: _videosJSON[i]["snippet"]["thumbnails"]["maxres"]
                  ["url"]));
        }
      }

      return _fetchedVideos;
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
          _fetchVideos();
        },
      ),
    ));

    return [].map((val) => Poster.fromJson(val)).toList();
  }

  Future<List<Poster>> _fetchStoredVideos() async {
    List<Poster> _updatedVideos;
    final sharedPrefs = await SharedPreferences.getInstance();
    final _storedVideosJSON =
        sharedPrefs.getString('playlist_${widget.playlistId}');
    if (_storedVideosJSON != null) {
      List<dynamic> decodedList = jsonDecode(_storedVideosJSON);
      _updatedVideos = decodedList.map((val) => Poster.fromJson(val)).toList();
    } else {
      _updatedVideos = [].map((val) => Poster.fromJson(val)).toList();
    }
    return _updatedVideos;
  }

  _storeVideos(List<Poster> _updatedVideos) {
    SharedPreferences.getInstance().then((sharedPrefs) {
      sharedPrefs.setString(
          'playlist_${widget.playlistId}', jsonEncode(_updatedVideos));
    });
  }

  Future _getVideos() async {
    if (_videos.length == 0) {
      List<Poster> _fetchedVideos = await _fetchStoredVideos();
      setState(() {
        _videos = _fetchedVideos;
      });
    }

    _fetchVideos().then((_fetchedVideos) {
      if (_mounted) {
        setState(() {
          _videos = _fetchedVideos;
        });
      }
      _storeVideos(_fetchedVideos);
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
    _getVideos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistTitle),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RefreshIndicator(
          onRefresh: () async {
            _getVideos();
          },
          child: ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoWidget(data: _videos[index]);
              }),
        ),
      ),
    );
  }
}

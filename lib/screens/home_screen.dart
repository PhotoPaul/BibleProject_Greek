import 'package:bibleproject_greek/configuration.dart';
import 'package:bibleproject_greek/screens/playlists_screen.dart';
import 'package:bibleproject_greek/screens/posters_screen.dart';
import 'package:bibleproject_greek/screens/reading_plans_screen.dart';
import 'package:bibleproject_greek/screens/video.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  DateTime _lastPop;
  int _selectedIndex = 0;

  List<dynamic> _pages = [
    {"title": "Σειρές", "widget": PlaylistsScreen()},
    {"title": "Αφίσες", "widget": PackagesScreen()},
    {"title": "Σχέδια", "widget": ReadingPlans()},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _fbmInit() async {
    _firebaseMessaging.getNotificationSettings().then((settings) {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // print(settings.authorizationStatus);
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        _firebaseMessaging.requestPermission();
      }
    });
    var token = await _firebaseMessaging.getToken();
    var url = Uri.parse(API_URL + "?action=refreshDeviceToken&token=" + token);
    http.get(url);
  }

  @override
  initState() {
    super.initState();
    _fbmInit();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() {
      DateTime now = DateTime.now();
      if (_lastPop == null || now.difference(_lastPop) > Duration(seconds: 4)) {
        _lastPop = now;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Έξοδος από την εφαρμογή;'),
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: "ΕΠΙΒΕΒΑΙΩΣΗ",
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ));
        return Future.value(false);
      }
      return Future.value(true);
    }

    // This is used to handle remote messages that arrive while the app is terminated
    _firebaseMessaging.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoScreen(message.data["videoId"])),
        );
      }
    });

    // This is used to handle remote messages that arrive while the app is on the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoScreen(message.data["videoId"])),
      );
    });

    // This is used to handle remote messages that arrive while the app is on the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoScreen(message.data["videoId"])),
      );
    });

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Row(children: [
            Expanded(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_pages[_selectedIndex]["title"]))),
            // InkWell(
            //   child: Icon(Icons.notifications),
            //   onTap: () {
            //     // _firebaseInit();
            //   },
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            InkWell(
              child: FaIcon(
                FontAwesomeIcons.youtube,
              ),
              onTap: () async {
                final ytUrl =
                    "https://www.youtube.com/@BibleProjectGreek/videos";
                launchUrl(Uri.parse(ytUrl),
                    mode: LaunchMode.externalNonBrowserApplication);
              },
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
                child: Icon(Icons.facebook),
                onTap: () async {
                  final fbUrl = "fb://page/113234198276003";
                  final webUrl = "https://www.facebook.com/BibleProjectGreek";
                  try {
                    bool launched = await launchUrl(Uri.parse(fbUrl));
                    if (!launched) {
                      await launchUrl(Uri.parse(webUrl),
                          mode: LaunchMode.externalNonBrowserApplication);
                    }
                  } catch (e) {
                    await launchUrl(Uri.parse(webUrl),
                        mode: LaunchMode.platformDefault);
                  }
                }),
            SizedBox(
              width: 10,
            ),
            InkWell(
              child: Icon(Icons.share),
              onTap: () async {
                final gpsUrl =
                    "https://play.google.com/store/apps/details?id=com.pavmeg.dev.bibleproject_greek";
                Share.share(
                    'Κάνε λήψη της εφαρμογής από το Google Play Store:\n\nBibleProject - Ελληνικά\n$gpsUrl',
                    subject: 'Εφαρμογή BibleProject - Ελληνικά');
              },
            ),
            SizedBox(
              width: 10,
            ),
          ]),
          centerTitle: true,
        ),
        body: _pages[_selectedIndex]["widget"],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.video_collection),
              label: 'Βίντεο',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.collections),
              label: 'Αφίσες',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Σχέδια',
            ),
          ],
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}

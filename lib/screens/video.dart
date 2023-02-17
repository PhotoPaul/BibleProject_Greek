import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class VideoScreen extends StatefulWidget {
  String id;

  VideoScreen(this.id);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  YoutubePlayerController _controler;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    _controler = YoutubePlayerController(
        initialVideoId: widget.id,
        flags: YoutubePlayerFlags(
          autoPlay: true,
        ));

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controler,
      onEnded: (metadata) {
        Navigator.pop(context);
      },
    );
  }
}

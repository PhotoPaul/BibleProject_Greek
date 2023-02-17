import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PosterWidget extends StatelessWidget {
  final dynamic data;

  PosterWidget({this.data});

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                data["title"],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Stack(
            children: [
              ClipRRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.4,
                  child: ClipRect(
                    child: CachedNetworkImage(
                      imageUrl: "https://wsrv.nl/?h=720&url=" + data["poster"],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('ΛΗΨΗ'),
                onPressed: () {
                  var url = Uri.parse(data["poster"]);
                  launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('ΚΟΙΝΟΠΟΙΗΣΗ'),
                onPressed: () {
                  Share.share(
                      'Κάνε λήψη αυτής της αφίσας από το BibleProject:\n\n${data["title"]}\n${data["poster"]}\n\n',
                      subject: 'BibleProject - ${data["title"]}');
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

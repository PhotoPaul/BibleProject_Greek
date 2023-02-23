import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadingPlanWidget extends StatelessWidget {
  final dynamic data;

  ReadingPlanWidget({this.data});

  String parseDescription(String description) {
    return description.split("\n")[0];
  }

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                child: ClipRect(
                  child: CachedNetworkImage(
                    imageUrl: data["thumbnail"],
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      var url = Uri.parse(data["url"]);
                      launchUrl(url,
                          mode: LaunchMode.externalNonBrowserApplication);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(parseDescription(data["description"])),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('ΠΡΟΒΟΛΗ'),
                onPressed: () {
                  var url = Uri.parse(data["url"]);
                  launchUrl(url,
                      mode: LaunchMode.externalNonBrowserApplication);
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('ΚΟΙΝΟΠΟΙΗΣΗ'),
                onPressed: () {
                  Share.share(
                      'Ακολούθησε αυτό το σχέδιο από το BibleProject:\n\n${data["title"]}\n${data["url"]}\n\n',
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

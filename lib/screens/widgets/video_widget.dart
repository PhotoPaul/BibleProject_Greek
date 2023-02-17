import 'package:bibleproject_greek/types/Video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../video.dart';

class VideoWidget extends StatelessWidget {
  final Poster data;

  VideoWidget({this.data});

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
                  bottomLeft:
                      Radius.circular(data.description.isEmpty ? 20 : 0),
                  bottomRight:
                      Radius.circular(data.description.isEmpty ? 20 : 0),
                ),
                child: ClipRect(
                  child: CachedNetworkImage(
                    imageUrl: data.thumbnail,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoScreen(data.id)),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          data.description.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(parseDescription(data.description)),
                )
              : SizedBox(
                  height: 0,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('ΠΡΟΒΟΛΗ'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoScreen(data.id)),
                  );
                },
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('ΚΟΙΝΟΠΟΙΗΣΗ'),
                onPressed: () {
                  Share.share(
                      'Παρακολούθησε αυτό το βίντεο από το BibleProject:\n\n${data.title}\nhttps://www.youtube.com/watch?v=${data.id}\n\n',
                      subject: 'BibleProject - ${data.title}');
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

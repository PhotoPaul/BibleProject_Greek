import 'package:bibleproject_greek/screens/videos_screen.dart';
import 'package:bibleproject_greek/types/Playlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistWidget extends StatelessWidget {
  final Poster data;

  PlaylistWidget({this.data});

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
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.51,
                  // heightFactor: 0.65,
                  child: ClipRect(
                    child: CachedNetworkImage(
                      imageUrl: data.thumbnail,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
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
                            builder: (context) =>
                                VideosPage(data.id, data.title)),
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
                  child: Text(data.description),
                )
              : SizedBox(
                  height: 0,
                ),
        ],
      ),
    );
  }
}

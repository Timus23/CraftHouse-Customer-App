import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:customer/components/pages/chewie_list_item.dart';
import 'package:customer/components/quiz.dart';

class Playlist extends StatefulWidget {
  final plink1;
  final plink2;
  final plink3;
  final pname;

  const Playlist({this.plink1, this.plink2, this.plink3, this.pname});

  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red,
          title: InkWell(child: Text(widget.pname)),
        ),
        body: new ListView(
          children: <Widget>[
            // ChewieListItem(
            //   videoPlayerController: VideoPlayerController.network(
            //     widget.plink1,
            //   ),
            //   looping: true,
            // ),
            // ChewieListItem(
            //   videoPlayerController: VideoPlayerController.network(
            //     widget.plink2,
            //   ),
            // ),
            // ChewieListItem(
            //   videoPlayerController: VideoPlayerController.network(
            //     widget.plink3,
            //   ),
            // ),
            Divider(),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Feel like taking a quiz ",
                      style: TextStyle(
                          color: Colors.grey, fontStyle: FontStyle.italic)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => new Quiz1()));
                    },
                    child: Text("Start", style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

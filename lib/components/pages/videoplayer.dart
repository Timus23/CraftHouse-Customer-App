import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:customer/components/quiz.dart';
import 'package:flutter/material.dart';

import 'package:flutter_youtube_player/flutter_youtube_player.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Course extends StatefulWidget {
  Map<String, dynamic> courseItem;
  Map<String, String> config;
  Course({@required this.courseItem, @required this.config});
  @override
  State<StatefulWidget> createState() {
    return CourseState();
  }
}

class CourseState extends State<Course> {
  Map<String, bool> playerState = {};
  String _currentPlayer;
  List<dynamic> videoDetail = [];
  @override
  void initState() {
    videoDetail = widget.courseItem['videos'];
    setInitialPlayerState();
    super.initState();
  }

  setInitialPlayerState() {
    for (var course in videoDetail) {
      playerState[course['id'].toString()] = false;
    }
  }

  Widget buildyoutubeplayer(String link) {
    return FlutterYoutubePlayer(
      apiKey: "AIzaSyBqidtXlsy2A-c0YNj1oYKXZyz27jCD-k4",
      videoId: link,
    );
  }

  void setPlayerState(String name) {
    if (_currentPlayer != null) {
      playerState[_currentPlayer] = false;
    }
    if (_currentPlayer == name) {
      playerState[_currentPlayer] = false;
      return;
    }
    playerState[name] = true;
    _currentPlayer = name;
  }

  Widget buildPlayer(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        playerState[videoDetail[index]['id'].toString()]
            ? buildyoutubeplayer(videoDetail[index]['video_url'])
            : Container(),
        Ink(
          color: playerState[videoDetail[index]['id'].toString()]
              ? Colors.green
              : Colors.white,
          child: ListTile(
            title: Text(index.toString() + '. ' + videoDetail[index]['title']),
            trailing: playerState[videoDetail[index]['id'].toString()]
                ? Text('playing')
                : Text(''),
            onTap: () {
              Map<String, dynamic> body = {
                'course_id': widget.courseItem['id'],
                'user_id': widget.courseItem['user_id'],
                'video_id': videoDetail[index]['id']
              };
              http
                  .post(Server.watchList,
                      headers: widget.config, body: json.encode(body))
                  .then((http.Response res) {
                if (res.statusCode == 200 || res.statusCode == 201) {
                  Map<String, dynamic> data = json.decode(res.body);
                  setState(() {
                    widget.courseItem['progress'] = data['progress'];
                  });
                }
              }).catchError((err) {
                Toast.show('Net Unavailable', context);
              });
              setState(() {
                setPlayerState(videoDetail[index]['id'].toString());
              });
            },
          ),
        ),
        Divider()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: videoDetail.length,
        itemBuilder: buildPlayer,
      ),
      bottomNavigationBar: Container(
        height: 200,
        child: ListView(
          children: <Widget>[
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                  child: new Text("Feel like taking a quiz ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25,
                          fontStyle: FontStyle.italic)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (widget.courseItem['courseTaken']) {
                        Toast.show(
                            'You have already taken the course', context);
                      } else {
                        var url = Server.courses +
                            widget.courseItem['id'].toString() +
                            '/taketest/';
                        http
                            .get(url, headers: widget.config)
                            .then((http.Response res) {
                          if (res.statusCode == 200) {
                            List<dynamic> testQuestion = json.decode(res.body);
                            print(testQuestion);
                            if (testQuestion.length == 0) {
                              Toast.show("Sorry No Test Available!!", context);
                            } else if (testQuestion[0]['question'].length ==
                                0) {
                              Toast.show("Sorry No Test Available!!", context);
                            } else {
                              Navigator.push<double>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => new Quiz(
                                        test: testQuestion[0],
                                        config: widget.config,
                                        courseId:
                                            widget.courseItem['id'].toString(),
                                        userID: widget.courseItem['user_id']
                                            .toString(),
                                      ),
                                ),
                              ).then((value) {
                                setState(() {
                                  widget.courseItem['progress'] = value;
                                  widget.courseItem['courseTaken'] = true;
                                });
                              });
                            }
                          }
                        }).catchError((err) {
                          Toast.show('Net Unavailable', context);
                        });
                      }
                    },
                    child: Text("Start", style: TextStyle(color: Colors.white)),
                    color: Colors.red,
                  ),
                )
              ],
            ),
            Divider(),
            new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 0.0, 5.0),
                  child: new Text(
                      "You have completed " +
                          widget.courseItem['progress'].toString() +
                          " of course. ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontStyle: FontStyle.italic)),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: new LinearPercentIndicator(
                    width: 100.0,
                    lineHeight: 15.0,
                    percent: widget.courseItem['progress'] / 100,
                    backgroundColor: Colors.blueGrey,
                    progressColor: Colors.red,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

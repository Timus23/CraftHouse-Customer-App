import 'dart:convert';

import 'package:customer/ServerAddress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

var finalScore = 0;
var questionNumber = 0;
var quiz = CraftQuiz();

class CraftQuiz {
  var images = ["a", "b", "c", "d", "e", "a", "b", "c", "d", "e"];
}

class Quiz extends StatefulWidget {
  final Map<String, dynamic> test;
  final Map<String, String> config;
  final String userID;
  final String courseId;
  Quiz(
      {@required this.test,
      @required this.config,
      @required this.courseId,
      @required this.userID});
  @override
  State<StatefulWidget> createState() {
    return QuizState();
  }
}

class QuizState extends State<Quiz> {
  List<dynamic> question = [];
  @override
  void initState() {
    question = widget.test['question'];
    print(question);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(20.0)),
                Container(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Question ${questionNumber + 1} of ${question.length}",
                        style: TextStyle(fontSize: 22.0),
                      ),
                      Text(
                        "Score: $finalScore",
                        style: TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                ),

                //image
                Padding(padding: EdgeInsets.all(10.0)),

                Image.asset(
                  "images/${quiz.images[questionNumber]}.jpg",
                ),

                Padding(padding: EdgeInsets.all(10.0)),

                Text(
                  question[questionNumber]['question'],
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),

                Padding(padding: EdgeInsets.all(10.0)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //button 1
                    MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (question[questionNumber]['correct_answer']
                                .toString() ==
                            '1') {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: Text(
                        question[questionNumber]['option1'],
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),

                    //button 2
                    MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (question[questionNumber]['correct_answer']
                                .toString() ==
                            '2') {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: Text(
                        question[questionNumber]['option2'],
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                Padding(padding: EdgeInsets.all(10.0)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //button 3
                    MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (question[questionNumber]['correct_answer']
                                .toString() ==
                            '3') {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: Text(
                        question[questionNumber]['option3'],
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),

                    //button 4
                    MaterialButton(
                      minWidth: 120.0,
                      color: Colors.blueGrey,
                      onPressed: () {
                        if (question[questionNumber]['correct_answer']
                                .toString() ==
                            '4') {
                          debugPrint("Correct");
                          finalScore++;
                        } else {
                          debugPrint("Wrong");
                        }
                        updateQuestion();
                      },
                      child: Text(
                        question[questionNumber]['option4'],
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),

                Padding(padding: EdgeInsets.all(15.0)),

                Container(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                        minWidth: 240.0,
                        height: 30.0,
                        color: Colors.red,
                        onPressed: resetQuiz,
                        child: Text(
                          "Quit",
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ))),
              ],
            ),
          ),
        ));
  }

  void resetQuiz() {
    setState(() {
      http
          .get(Server.courses + widget.courseId + '/', headers: widget.config)
          .then((http.Response res) {
        if (res.statusCode == 200) {
          questionNumber = 0;
          finalScore = 0;
          var progress = json.decode(res.body)['progress'];
          Navigator.pop(context, progress);
        }
      }).catchError((err) {
        Toast.show('Net Unavailable', context);
      });
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == question.length - 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Summary(
                  score: finalScore,
                  config: widget.config,
                  courseId: widget.courseId,
                  userID: widget.userID,
                ),
          ),
        );
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatelessWidget {
  final Map<String, String> config;
  final String userID;
  final String courseId;
  final int score;
  Summary(
      {Key key,
      @required this.score,
      @required this.config,
      @required this.courseId,
      @required this.userID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red,
          title: Text('Results'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  "Final Score: $score",
                  style: TextStyle(fontSize: 35.0),
                ),
              ),
              Padding(padding: EdgeInsets.all(30.0)),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  Map<String, dynamic> body = {
                    'course_id': courseId,
                    'user_id': userID,
                    'total_question': questionNumber + 1,
                    'score': finalScore
                  };
                  http
                      .post(Server.submitReport,
                          headers: config, body: json.encode(body))
                      .then((http.Response res) {
                    if (res.statusCode == 201 || res.statusCode == 200) {
                      Map<String, dynamic> pro = json.decode(res.body);
                      questionNumber = 0;
                      finalScore = 0;
                      Navigator.pop(context);
                      Navigator.of(context).pop(pro['progress']);
                    } else {
                      Toast.show('Server Unavailable', context);
                    }
                  }).catchError((err) {
                    Toast.show('Net Unavailable', context);
                  });
                },
                child: Text(
                  "Finish",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

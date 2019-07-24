// import 'package:flutter/material.dart';
// import 'package:flutter_app/components/quiz.dart';
// import 'package:flutter_youtube_player/flutter_youtube_player.dart';



// class Playvideo extends StatefulWidget {
//   @override
//   _PlayvideoState createState() => _PlayvideoState();
// }

// class _PlayvideoState extends State<Playvideo> {
//    String link = "k71tGJZHBXQ";
//   @override
//   void initState() {
//     super.initState();
//   }
//     var videos_list = [
//     {
//       "number": "November Rain",
//       "ID": "8SbUC-UaAxE",
//     },
//     {
//      "number": "sweet Child o mine",
//       "ID": "WrAV5EVI4tU", 
//     },
//     {
//      "number": "Patience",
//       "ID": "ErvgV4P6Fzc", 
//     },
//     {
//      "number": "Paradise City",
//       "ID": "Rbm6GXllBiw", 
//     },
//     {
//       "number":"Welcome to the jungle",
//       "ID":"o1tj2zJ2Wvg",
//     }
//   ];
//   @override
//   Widget build(BuildContext context) {
//             return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.red,
//           title: Text("Video"),
//         ),
//         body: ListView(
//           children: <Widget>[
//            FlutterYoutubePlayer(
//                 apiKey: "AIzaSyBqidtXlsy2A-c0YNj1oYKXZyz27jCD-k4",
//                 videoId: 'n0EfX0frQjc',
//               ),
               

//               Divider(),
//               Container(height: 300,
//               padding: const EdgeInsets.fromLTRB(60.0, 20.0, 60.0, 20.0),
//                 child:
//                new ListView.builder(
//                   itemCount: videos_list.length,
//                   itemBuilder: (context, int index) {
//                   return RaisedButton(
//                     color: Colors.red,
//                   onPressed: () {
//                   setState(() {
//                      link = videos_list[index]['ID'];
//                   });
//                 },
//                 child: Text(videos_list[index]['number'],style: TextStyle(color: Colors.white),),
//               );
//             }),),

            
//           Divider(),
//           new Row(
//             children: <Widget>[
//               Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
//                 child: new Text("Feel like taking a quiz ",style :TextStyle(color: Colors.grey,fontSize: 25,fontStyle: FontStyle.italic)),
//               ),
//               Padding(padding: EdgeInsets.all(5.0),
//                 child: RaisedButton(
//                    onPressed: () {
//                      Navigator.push(context,MaterialPageRoute(builder: (context)=> new Quiz1()));
//                       },
//                   child: Text(
//                      "Start",style :TextStyle(color: Colors.white)
//                     ),
//                     color: Colors.red,
//                   )
//               )
//             ],
//           ),
//           ],
//         ));
//   }
// }
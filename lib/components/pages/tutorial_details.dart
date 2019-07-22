import 'package:flutter/material.dart';
import 'package:customer/components/pages/tutorial_playlist.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';


class TutorialDetails extends StatefulWidget {
  final tutorial_detail_name;
  final tutorial_detail_price;
  final tutorial_detail_artist;
  final tutorial_detail_description;
  final tutorial_detail_picture;
  final tutorial_detail_length;
  final tutorial_detail_link1;
  final tutorial_detail_link2;
  final tutorial_detail_link3;
  final tutorial_detail_avg_rating;
  final tutorial_detail_toolsrequired;

  const TutorialDetails({
    this.tutorial_detail_name,
    this.tutorial_detail_artist,
    this.tutorial_detail_description,
    this.tutorial_detail_length,
    this.tutorial_detail_picture,
    this.tutorial_detail_price,
    this.tutorial_detail_link1,
    this.tutorial_detail_link2,
    this.tutorial_detail_link3,
    this.tutorial_detail_avg_rating,
    this.tutorial_detail_toolsrequired
  });
  @override
  _TutorialDetailsState createState() => _TutorialDetailsState();
}

class _TutorialDetailsState extends State<TutorialDetails> {
  var rating =0.0;



  @override
  Widget build(BuildContext context) {
    var link1 = widget.tutorial_detail_link1;
    var link2 = widget.tutorial_detail_link2;
    var link3 = widget.tutorial_detail_link3;
    var name = widget.tutorial_detail_name;
  
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: 
             Text(widget.tutorial_detail_name),
      ),
      body: new ListView(
        children: <Widget>[
          Container(
            height: 300,
            child: Center(
              child: Image.asset(widget.tutorial_detail_picture),
            ),
          ),
          Row(
            children: <Widget>[
                      Expanded(
                        child: new SmoothStarRating(
                        color: Colors.red,
                        borderColor: Colors.red,
                        rating: widget.tutorial_detail_avg_rating.toDouble(),
                        size: 20,
                        starCount: 5,
                        spacing: 2.0,
                      )),
                      Expanded(
                        child: new Text(
                          "\$${widget.tutorial_detail_price}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ),
                    ],
          ),
          Divider(),
          new ListTile(
            title: new Text("Tutorial Details"),
            subtitle: new Text(widget.tutorial_detail_description),
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Artist Name ",style :TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.tutorial_detail_artist,style: TextStyle(color: Colors.red)),
              )
            ],
          ),
           new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Tutorial Length",style :TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.tutorial_detail_length,style: TextStyle(color: Colors.red,)),
              )
            ],
          ),
           new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Tools required",style :TextStyle(color: Colors.grey)),
              ),
              //to add brand name
              Padding(padding: EdgeInsets.all(5.0),
                child: new Text(widget.tutorial_detail_toolsrequired,style: TextStyle(color: Colors.red,)),
              )
            ],
          ),
           new Row(
            children: <Widget>[
              //the size button
              Expanded(
                child: MaterialButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> new Playlist(
                        plink1 : link1,
                        plink2 : link2,
                        plink3 : link3,
                        pname : name,
                        
                      )));
                },
                    color: Colors.red,
                    textColor: Colors.white,
                    elevation: 0.2,
                    child: new Text("Buy now")
                ),
              ),
             


            ],
          ),
          Divider(),
          new Row(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(12.0, 5.0, 5.0, 5.0),
                child: new Text("Rate this tutorial ",style :TextStyle(color: Colors.grey)),
              ),
              Padding(padding: EdgeInsets.all(5.0),
                child: SmoothStarRating(
                  color: Colors.red,
                  borderColor: Colors.red,
                  rating: rating,
                  size: 30,
                  starCount: 5,
                  spacing: 2.0,
                  onRatingChanged: (value) {
                    setState(() {
                    rating = value;
                   });
                  },
               )
              ),
              Padding(padding: EdgeInsets.all(5.0),
              child: RaisedButton(
                   onPressed: () {
                      },
                  child: Text(
                     "Submit",style :TextStyle(color: Colors.white)
                    ),
                    color: Colors.red,
                  )
              )
              
            ]
          ),
           
         
           Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Text("Tutorial Reviews ",style :TextStyle(color: Colors.redAccent,fontSize: 30,fontStyle: FontStyle.italic)),
          ),
          
          

          //REview product section
          Container(
            height: 340.0,
            child: review(),
          )
          
        ],
        

        
      ),
       
    );
  }
}


class review extends StatefulWidget {
  @override
  _reviewState createState() => _reviewState();
}

class _reviewState extends State<review> {
  var reviews_list=[
    {
      "user":"andy",
      "view":"Nice tutorial",},
      {
        "user":"james",
        "view":"good tutorial",
      }
      ];
  @override
  Widget build(BuildContext context) {
     return new ListView.builder(
        itemCount: reviews_list.length,
        itemBuilder: (context, int index){
          return  ListTile(
            title: new Text(reviews_list[index]['user'],style :TextStyle(color: Colors.red)),
            subtitle: new Text(reviews_list[index]['view']),
          );
        }
    );
  }

}

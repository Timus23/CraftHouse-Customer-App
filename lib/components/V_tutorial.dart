import 'package:flutter/material.dart';
import 'package:customer/components/pages/tutorial_details.dart';


class V_tutorial extends StatefulWidget {
  @override
  _V_tutorialState createState() => _V_tutorialState();
}

class _V_tutorialState extends State<V_tutorial> {
   var tutorial_list =[
    {
         "name": "Guns n Roses",
         "picture":"images/gnr.jpg",
         "price":12000,
         "artist":"Guns n Roses",
         "length":"2 hours",
         "description":"This is the tutorial description",
         "link1":"https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
         "link2":"https://r3---sn-vgqsknez.googlevideo.com/videoplayback?source=youtube&mime=video%2Fmp4&itag=22&key=cms1&requiressl=yes&beids=[9466592]&ratebypass=yes&fexp=9466586,23724337&ei=g3jiWvfCL4O_8wScopaICA&signature=43C209DD37289D74DB39A9BBF7BC442EAC049426.14B818F50F4FA686C13AF5DD1C2A498A9D64ECC9&fvip=3&pl=16&sparams=dur,ei,expire,id,initcwndbps,ip,ipbits,ipbypass,itag,lmt,mime,mip,mm,mn,ms,mv,pl,ratebypass,requiressl,source&ip=54.163.50.118&lmt=1524616041346022&expire=1524813027&ipbits=0&dur=1324.768&id=o-AJvotKVxbyFDCz5LQ1HWQ8TvNoHXWb2-86a_50k3EV0f&rm=sn-p5qyz7s&req_id=e462183e4575a3ee&ipbypass=yes&mip=96.244.254.218&redirect_counter=2&cm2rm=sn-p5qe7l7s&cms_redirect=yes&mm=34&mn=sn-vgqsknez&ms=ltu&mt=1524791367&mv=m",
         "link3":"https://www.youtube.com/watch?v=o1tj2zJ2Wvg",
         "toolsrequired":"Slash,Adler,Izzy,Duff,Axl",
         "avg_rating":4.0,
    },
    ];
  @override
  Widget build(BuildContext context) {
     return GridView.builder(
        itemCount: tutorial_list.length,
        
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext,int index){
          return Single_tutorial(
            tutorial_name: tutorial_list[index]['name'],
            tutorial_picture: tutorial_list[index]['picture'],
            tutorial_price: tutorial_list[index]['price'],
            tutorial_toolsrequired: tutorial_list[index]['toolsrequired'],
            tutorial_artist: tutorial_list[index]['artist'],
            tutorial_length:tutorial_list[index]['length'],
            tutorial_description: tutorial_list[index]['description'],
            tutorial_link1: tutorial_list[index]['link1'],
            tutorial_link2: tutorial_list[index]['link2'],
            tutorial_link3: tutorial_list[index]['link3'],
            tutorial_avg_rating: tutorial_list[index]['avg_rating'],
          );
        });
  }
}



class Single_tutorial extends StatelessWidget {
  final tutorial_name;
  final tutorial_picture;
  final tutorial_price;
  final tutorial_toolsrequired;
  final tutorial_artist;
  final tutorial_length;
  final tutorial_description;
  final tutorial_link1;
  final tutorial_link2;
  final tutorial_link3;
  final tutorial_avg_rating;

  Single_tutorial(
  {
  this.tutorial_name,
  this.tutorial_picture,
  this.tutorial_price,
  this.tutorial_toolsrequired,
  this.tutorial_artist,
  this.tutorial_length,
  this.tutorial_description,
  this.tutorial_link1,
  this.tutorial_link2,
  this.tutorial_link3,
  this.tutorial_avg_rating
   }
  );

  @override
  Widget build(BuildContext context) {
   return Card(
      child: Hero(tag: new Text("hero 1"),child: Material(
        child: InkWell(onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(
          //passing the values of product to product_details page
            builder: (context)=> new TutorialDetails(
          tutorial_detail_name: tutorial_name,
          tutorial_detail_price: tutorial_price,
          tutorial_detail_artist: tutorial_artist,
          tutorial_detail_description: tutorial_description,
          tutorial_detail_picture:tutorial_picture,
          tutorial_detail_length:tutorial_length,
          tutorial_detail_toolsrequired:tutorial_toolsrequired,
          tutorial_detail_link1: tutorial_link1,
          tutorial_detail_link2: tutorial_link2,
          tutorial_detail_link3: tutorial_link3,
          tutorial_detail_avg_rating: tutorial_avg_rating,

         )
         )),
        child: GridTile(
            footer: Container(
              color: Colors.white,
              child: new Row(children: <Widget>[
                Expanded(
                  child: Text(tutorial_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0),),
                ),
                new Text("\$${tutorial_price}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
              ],)
            ),
            child: Image.asset(tutorial_picture,
            fit: BoxFit.cover,)),
        ),
      ),),
    );
  }
}
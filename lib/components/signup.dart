import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Signup extends StatefulWidget {
   @override
   _SignupState createState() => _SignupState();
 }
 
 class _SignupState extends State<Signup> {
   final _formKey = GlobalKey<FormState>();
   Container _buildLoginForm() {
    return Container(
          padding: EdgeInsets.all(20.0),
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: RoundedDiagonalPathClipper(),
                child: Container(
                  height: 900,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 90.0,),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                               maxLength: 32,
                              validator: validateName,
                          style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            hintText: "First Name",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.perm_identity, color: Colors.red,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.red.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          maxLength: 32,
                          validator: validateName,
                          style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            hintText: "Last Name",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.perm_identity, color: Colors.red,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.red.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 32,
                          validator: validateEmail,
                          style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            hintText: "Email address",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.email, color: Colors.red,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.red.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          maxLength: 20,
                            validator: (String arg) {
                            if(arg.length < 5)
                            return 'Password must be more than 5 character';
                            else
                            return null;
                           },
                          style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.red,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.red.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          maxLength: 20,
                            validator: (String arg) {
                            if(arg.length < 5)
                            return 'Password must be more than 5 character';
                            else
                            return null;
                           },
                          style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            hintText: "Confirm password",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock, color: Colors.red,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.red.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: validateMobile,
                          style: TextStyle(color: Colors.red),
                          decoration: InputDecoration(
                            hintText: "Phone Number",
                            hintStyle: TextStyle(color: Colors.red.shade200),
                            border: InputBorder.none,
                            icon: Icon(Icons.contact_phone, color: Colors.red,)
                          ),
                        )
                      ),
                      Container(child: Divider(color: Colors.red.shade400,), padding: EdgeInsets.only(left: 20.0,right: 20.0, bottom: 10.0),),
                      SizedBox(height: 10.0,),
                      
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.red.shade600,
                    child: Icon(Icons.person),
                  ),
                ],
              ),
              Container(
                height: 900,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: (){
                       if(_formKey.currentState.validate()){
                        
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                    child: Text("Sign Up", style: TextStyle(color: Colors.white70)),
                    color: Colors.red,
                  ),
                ),
              )
            ],
          ),
        );
   }
    String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Mobile is Required";
    } else if(value.length != 10){
      return "Mobile number must 10 digits";
    }else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  String validateEmail(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if(!regExp.hasMatch(value)){
      return "Invalid Email";
    }else {
      return null;
    }
}
   @override
   Widget build(BuildContext context) {
     return Scaffold(body: Form(
       key: _formKey,
      child: 
        Container(
      color: Colors.red.shade100,
      child: ListView(
        children: <Widget>[
          
          _buildLoginForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                onPressed: (){
                  Navigator.pop(context);
                },
                backgroundColor: Colors.red,
                child: Icon(Icons.arrow_back),
              ) 
            ],
          )
        ],
      ),
     ),),);
   }
  }
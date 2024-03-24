import 'package:google_fonts/google_fonts.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';


class successful_login extends StatefulWidget {
  successful_login({required this.messsage});
  var messsage;
  @override
  State<successful_login> createState() => _successful_loginState();
}

class _successful_loginState extends State<successful_login> {

  void next_page(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }
  @override
  void initState(){
    Future.delayed(const Duration(milliseconds: 5000),next_page);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.30),
        height:double.infinity,
        width:double.infinity,
        color:Colors.white,
        child:Center(
          child:Column(
            children: [
              Icon(Icons.check_circle,size:150,color:Colors.green,),
              SizedBox(height:50,),
              Text("${widget.messsage}",style:GoogleFonts.dmSans(fontWeight:FontWeight.w900,fontSize:25,color:Colors.green),)
            ],
          ),
        ),
      ),
    );
  }
}

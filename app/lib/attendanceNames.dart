import 'dart:async';
import 'dart:io';

import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_upload/platform_interface.dart';
import 'package:webview_flutter_upload/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/register.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:app/successful.dart';


class attendanceNames extends StatefulWidget {
  attendanceNames({required this.data});
  var data=[];
  @override
  State<attendanceNames> createState() => _attendanceNamesState();
}

class _attendanceNamesState extends State<attendanceNames> {

  @override
  Widget build(BuildContext context) {
    print("-------------------------------------------");
    print(widget.data);
    return Scaffold(
      body:Container(
        padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.06,left:20,right:20),
        width:double.infinity,
        height:double.infinity,
        color:Colors.white,
        child:Column(
          children: [
            GestureDetector(
              onTap:(){
                Navigator.pop(context);
              },
              child: Align(
                alignment:Alignment.topLeft,
                child:Container(
                  padding:EdgeInsets.only(left:5),
                    child: Icon(Icons.arrow_back)
                ),
              ),
            ),
            SizedBox(height:20,),
            for(var i in widget.data)student_card(name:i[0], matric_no:i[1],time:i[2])
          ],
        ),
      )
    );
  }
}


class student_card extends StatefulWidget {
  student_card({required this.name,required this.matric_no,required this.time});

  String name ;
  String matric_no;
  var time;

  @override
  State<student_card> createState() => _student_cardState();
}

class _student_cardState extends State<student_card> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor:Colors.black,
      color:Colors.white,
      elevation:3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin:EdgeInsets.only(bottom:20),
      child:Container(
        height:MediaQuery.of(context).size.height*0.09,
        padding:EdgeInsets.only(left:20,right:20),
        child: Row(
          children: [
            CircleAvatar(
              radius:22,
              backgroundColor:Colors.white,
              child: CircleAvatar(
                backgroundColor:Colors.white,
                radius:19,
                child:Icon(Icons.person,color:Colors.green),
              ),
            ),
            SizedBox(width:15,),
            Column(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("${widget.name.toUpperCase()}",style:GoogleFonts.montserrat(fontWeight:FontWeight.w600),),
                    SizedBox(width:10,),
                    Text(widget.matric_no,style:GoogleFonts.montserrat(fontWeight:FontWeight.w400),)
                  ],
                ),
                Text(widget.time,style:GoogleFonts.montserrat(fontWeight:FontWeight.w400),)
              ],
            ),
            Expanded(child:SizedBox()),
            Icon(Icons.cancel_outlined,color:Colors.white)
          ],
        ),
      ),
    );
  }
}


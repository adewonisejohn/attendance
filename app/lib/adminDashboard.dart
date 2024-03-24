import 'dart:async';
import 'dart:io';

import 'package:app/attendanceNames.dart';
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

class dashboard extends StatefulWidget {

  dashboard({required this.data});
  var data=[];
  @override
  State<dashboard> createState() => _dashboardState();
}

class _dashboardState extends State<dashboard> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width:double.infinity,
        padding:EdgeInsets.only(left:20,right:20),
        color:Colors.white,
        child:Column(
          children: [
            SizedBox(height:MediaQuery.of(context).size.height*0.07,),
            Text("Attendance list",style:GoogleFonts.dmSans(fontSize:20,fontWeight:FontWeight.bold),),
            SizedBox(height:MediaQuery.of(context).size.height*0.02,),
            Column(
              children:[for(var i  in widget.data)attendance_list_card(name:i.toString()) ],
            )

          ],
        ),
      ),
    );
  }
}


class attendance_list_card extends StatefulWidget {
  attendance_list_card({required this.name});

  String name ;

  @override
  State<attendance_list_card> createState() => _attendance_list_cardState();
}

class _attendance_list_cardState extends State<attendance_list_card> {
  var address ="192.168.235.137:5000";
  bool is_loading=false;
  bool error=false;
  var error_message="";

  void submit_form(var name) async {
    final formData = FormData.fromMap({
      'name':name,
    });
    var response = await Dio().post("http://$address/admin/getattendance",data:formData,options: Options(
      followRedirects: false,
      contentType: Headers.formUrlEncodedContentType,
      validateStatus: (status) { return status! < 500; },)
    );
    var data=response.data;
    setState(() {
      is_loading=false;
    });
    if(data["status"]==false){
      print("an error occured while getting attendance");
    }else{
      print("about to print data");
      print(data['data']);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => attendanceNames(data:data['data'],)),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        print(widget.name);
        submit_form(widget.name);
      },
      child: Card(
        shadowColor:Colors.black,
        color:Colors.white,
        elevation:2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        margin:EdgeInsets.only(bottom:20),
        child:Container(
          height:MediaQuery.of(context).size.height*0.09,
          width:MediaQuery.of(context).size.width*1,
          padding:EdgeInsets.only(left:20,right:20),
          child:Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              Text(widget.name.toUpperCase(),style:GoogleFonts.dmSans(fontWeight:FontWeight.w500),),
            ],
          ),
        ),
      ),
    );
  }
}


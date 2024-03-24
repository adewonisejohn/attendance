import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_upload/platform_interface.dart';
import 'package:webview_flutter_upload/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/register.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:app/successful.dart';
import 'package:app/adminSignin.dart';
import 'package:app/adminDashboard.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      //home:dashboard(data:['-2023-5-8.csv', 'com302-2023-6-16.csv'],)
      home:start_page()
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  bool web_page_error=false;

  var matric_number = "";

  var password = "";
  var _image;
  var _image_path;
  var address ="192.168.235.137:5000";
  bool is_loading=false;
  bool error=false;
  var error_message="";
  var course_code="";


  void pick_image(int type) async{
    final image;
    if(type==0){
      image = await ImagePicker().pickImage(source:ImageSource.gallery);
    }else{
      image = await ImagePicker().pickImage(source:ImageSource.camera);

    }
    if(image==null) return;
    final imageTemporary = File(image.path);
    setState(() {
      this._image=imageTemporary;
      this._image_path=image.path;
    });
    print(_image_path);
  }

  void submit_form(var matric_no,var student_password,var image,var course) async {
    if(image!=null && matric_no!="" && student_password!=""){
      setState(() {
        is_loading=true;
      });
      final formData = FormData.fromMap({
        'password':student_password,
        'matric_no':matric_no,
        'image': await MultipartFile.fromFile(image,filename: 'current.jpeg'),
        'course':course
      });
      var response = await Dio().post("http://$address/login",data:formData,options: Options(
        followRedirects: false,
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) { return status! < 500; },)
      );
      var data=response.data;
      setState(() {
        is_loading=false;
      });
      if(data["status"]==false){
        setState(() {
          error=true;
          error_message=data["message"];
        });
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => successful_login(messsage:data["message"],)),
        );
      }
      print("--------------------data-----------------");
      print(data);
    }else{
      setState(() {
        error=true;
        error_message="Fill in your details";
      });
    }


  }
  void sign_out(var matric_no,var student_password,var image,var course) async {
    if(image!=null && matric_no!="" && student_password!=""){
      setState(() {
        is_loading=true;
      });
      final formData = FormData.fromMap({
        'password':student_password,
        'matric_no':matric_no,
        'image': await MultipartFile.fromFile(image,filename: 'current.jpeg'),
        'course':course
      });
      var response = await Dio().post("http://$address/signout",data:formData,options: Options(
        followRedirects: false,
        contentType: Headers.formUrlEncodedContentType,
        validateStatus: (status) { return status! < 500; },)
      );
      var data=response.data;
      setState(() {
        is_loading=false;
      });
      if(data["status"]==false){
        setState(() {
          error=true;
          error_message=data["message"];
        });
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => successful_login(messsage:data["message"],)),
        );
      }
      print("--------------------data-----------------");
      print(data);
    }else{
      setState(() {
        error=true;
        error_message="Fill in your details";
      });
    }


  }



  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Container(
          padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.11),
          color:Colors.white,
          height:double.infinity,
          width:double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("SIGN IN",style:GoogleFonts.dmSans(fontWeight:FontWeight.w900,fontSize:28,textStyle:TextStyle(letterSpacing:1)),),
                SizedBox(height:70,),
                Container(
                  width:MediaQuery.of(context).size.width*0.8,
                  child:TextField(
                    cursorColor:Colors.black,
                    onChanged:(value){
                      setState(() {
                        print(value);
                        matric_number=value;
                      });
                    },

                    style:GoogleFonts.quicksand(color:Colors.grey,fontSize:18),
                    decoration:const InputDecoration(

                      isDense:true,
                      contentPadding:EdgeInsets.all(20),

                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color:Color(0xFFf0f0f0), width: 2.0),
                      ),
                      prefixIcon:Icon(Icons.numbers,color:Colors.grey,size:20,),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFFf0f0f0), width: 2.0
                        ),
                      ),
                      filled:true,
                      border:InputBorder.none,
                      fillColor:Color(0xffebebeb),

                      labelText:"Matric number",
                      labelStyle:TextStyle(
                          color:Colors.grey,
                        fontWeight:FontWeight.w700
                      ),
                    ),
                  ),
                ),
                SizedBox(height:20,),
                Container(
                  width:MediaQuery.of(context).size.width*0.8,
                  child:TextField(
                    obscureText:true,
                    cursorColor:Colors.black,
                    onChanged:(value){
                      setState(() {
                        print(value);
                        password=value;
                      });
                    },

                    style:GoogleFonts.quicksand(color:Colors.grey,fontSize:18),
                    decoration:const InputDecoration(

                      isDense:true,
                      contentPadding:EdgeInsets.all(20),

                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color:Color(0xFFf0f0f0), width: 2.0),
                      ),
                      prefixIcon:Icon(Icons.lock,color:Colors.grey,size:20,),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Color(0xFFf0f0f0), width: 2.0
                        ),
                      ),
                      filled:true,
                      border:InputBorder.none,
                      fillColor:Color(0xffebebeb),

                      labelText:"Password",
                      labelStyle:TextStyle(
                          color:Colors.grey,
                          fontWeight:FontWeight.w700
                      ),
                    ),
                  ),
                ),
                SizedBox(height:25,),
                SizedBox(
                  width:MediaQuery.of(context).size.width*0.8,
                  height:30,
                  child: Align(
                    alignment:Alignment.topRight,
                    child:Text("Forgot password ?",style:GoogleFonts.dmSans(color:Colors.blueAccent),),
                  ),
                ),
                Container(
                  width:MediaQuery.of(context).size.width*0.8,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:(){
                          pick_image(1);
                        },
                        child: CircleAvatar(
                          backgroundColor:_image_path!=null?Color(0xff6fb554):Colors.grey,
                          radius:25,
                          child:CircleAvatar(
                            radius:22,
                            backgroundColor:Colors.white,
                            child:Center(
                              child:Icon(Icons.camera,size:40,color:Colors.black38)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width:25,),
                      GestureDetector(
                        onTap:(){
                          pick_image(0);
                        },
                        child: CircleAvatar(
                          backgroundColor:_image_path!=null?Color(0xff6fb554):Colors.grey,
                          radius:25,
                          child:CircleAvatar(
                            radius:22,
                            backgroundColor:Colors.white,
                            child:Center(
                                child:Icon(Icons.image,size:35,color:Colors.black38)
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width:30,),
                      Expanded(
                        child:Container(
                          width:MediaQuery.of(context).size.width*0.8,
                          child:TextField(
                            cursorColor:Colors.black,
                            onChanged:(value){
                              setState(() {
                                course_code=value;
                                print(value);
                              });
                            },

                            style:GoogleFonts.quicksand(color:Colors.grey,fontSize:18),
                            decoration:const InputDecoration(

                              isDense:true,
                              contentPadding:EdgeInsets.all(20),

                              enabledBorder: const OutlineInputBorder(
                                borderSide: const BorderSide(color:Color(0xFFf0f0f0), width: 4.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color:Color(0xFFf0f0f0), width: 2.0
                                ),
                              ),
                              filled:true,
                              border:InputBorder.none,
                              fillColor:Colors.white,

                              hintText:"Course Code",
                              labelStyle:TextStyle(
                                  color:Colors.black,
                                  fontWeight:FontWeight.w800
                              ),
                            ),
                          ),
                        ),

                      )
                    ],
                  ),
                ),
                SizedBox(height:MediaQuery.of(context).size.height*0.04),
                error?Container(
                  margin:EdgeInsets.only(bottom:MediaQuery.of(context).size.height*0.04),
                  width:MediaQuery.of(context).size.width*0.8,
                  child: Row(
                    children: [
                      Icon(Icons.warning,color:Colors.red),
                      SizedBox(width:20,),
                      Text("${error_message}",style:GoogleFonts.montserrat(color:Colors.red,fontSize:15))
                    ],
                  ),
                ):SizedBox(),
                Center(
                  child: Container(
                    width:MediaQuery.of(context).size.width*0.8,
                    child: TextButton(
                      style:TextButton.styleFrom(
                        backgroundColor:Color(0xff6fb554),
                        primary:Colors.white,
                        minimumSize:Size(MediaQuery.of(context).size.width*0.09,MediaQuery.of(context).size.height*0.07,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),

                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text(
                            'SIGN IN',style:GoogleFonts.montserrat(fontSize:17,fontWeight:FontWeight.bold,color:Colors.white),
                          ),
                          SizedBox(width:10,),
                        ],
                      ),
                      onPressed: () {
                        submit_form(matric_number,password,_image_path,course_code);
                      },
                    ),
                  ),
                ),
                SizedBox(height:10,),
                Center(
                  child: Container(
                    width:MediaQuery.of(context).size.width*0.8,
                    child: TextButton(
                      style:TextButton.styleFrom(
                        backgroundColor:Color(0xff6fb554),
                        primary:Colors.white,
                        minimumSize:Size(MediaQuery.of(context).size.width*0.09,MediaQuery.of(context).size.height*0.07,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),

                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text(
                            'SIGN OUT',style:GoogleFonts.montserrat(fontSize:17,fontWeight:FontWeight.bold,color:Colors.white),
                          ),
                          SizedBox(width:10,),
                        ],
                      ),
                      onPressed: () {
                        sign_out(matric_number,password,_image_path,course_code);
                      },
                    ),
                  ),
                ),
                SizedBox(height:20,),
                Center(
                  child:Row(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text('Or',style:GoogleFonts.montserrat(fontSize:18,fontWeight:FontWeight.w400),),
                      SizedBox(width:5,),
                      GestureDetector(
                        onTap:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => register()),
                          );
                        },
                        child: Text('register',style:GoogleFonts.montserrat(fontSize:18,fontWeight:FontWeight.w700,decoration:TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
          is_loading?Container(
            height:double.infinity,
            width:double.infinity,
            color:Colors.white70,
            child:Center(
              child:CircularProgressIndicator(
                color:Colors.green,
              ),
            ),
          ):SizedBox(),

        ],
      )
    );
  }
}


class start_page extends StatefulWidget {
  const start_page({Key? key}) : super(key: key);

  @override
  State<start_page> createState() => _start_pageState();
}

class _start_pageState extends State<start_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height:double.infinity,
        width:double.infinity,
        decoration:BoxDecoration(
          image:DecorationImage(
            image:AssetImage("assets/class2.jpg"),
            fit:BoxFit.cover
          )
        ),
        child:Column(
          children: [
            SizedBox(height:MediaQuery.of(context).size.height*0.3,),
            Center(
              child:Text("Computer Science",style:GoogleFonts.dmSans(fontWeight:FontWeight.w500,color:Colors.white,fontSize:28,textStyle:TextStyle(
                  shadows: <Shadow>[
              Shadow(
              offset: Offset(2.0, 2.0),
                blurRadius: 3.0,
                color: Colors.black,
              ),
                  Shadow(
                    offset: Offset(2.0, 2.0),
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
              ])
            ),
              ),
            ),
            Center(
              child:Text("Attendance Monitoring",style:GoogleFonts.dmSans(fontWeight:FontWeight.w500,color:Colors.white,fontSize:28,textStyle:TextStyle(
                  letterSpacing:0.5,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black,
                    ),
                    Shadow(
                      offset: Offset(2.0, 2.0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    ),
                  ]
              )
              ),),
            ),
            Center(
              child:Text("System",style:GoogleFonts.dmSans(fontWeight:FontWeight.w500,color:Colors.white,fontSize:28,textStyle:TextStyle(letterSpacing:0.5)),),
            ),
            SizedBox(height:MediaQuery.of(context).size.height*0.1,),
            Center(
              child: Container(
                width:MediaQuery.of(context).size.width*0.8,
                margin:EdgeInsets.only(bottom:10),
                child: TextButton(
                  style:TextButton.styleFrom(
                    backgroundColor:Color(0xff6fb554),
                    primary:Colors.white,
                    minimumSize:Size(MediaQuery.of(context).size.width*0.09,MediaQuery.of(context).size.height*0.09,),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),

                  child: Row(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text(
                        'REGISTER',style:GoogleFonts.montserrat(fontSize:17,fontWeight:FontWeight.bold,color:Colors.white),
                      ),
                      SizedBox(width:10,),
                    ],
                  ),
                  onPressed: () {
                    print("register");
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>register()),
                    );
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                width:MediaQuery.of(context).size.width*0.8,
                margin:EdgeInsets.only(bottom:10),
                child: TextButton(
                  style:TextButton.styleFrom(
                    backgroundColor:Color(0xff6fb554),
                    primary:Colors.white,
                    minimumSize:Size(MediaQuery.of(context).size.width*0.09,MediaQuery.of(context).size.height*0.09,),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),

                  child: Row(
                    crossAxisAlignment:CrossAxisAlignment.center,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text(
                        'SIGN IN ',style:GoogleFonts.montserrat(fontSize:17,fontWeight:FontWeight.bold,color:Colors.white),
                      ),
                      SizedBox(width:10,),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );                  },
                ),
              ),
            ),
            Center(
              child:Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Container(
                    width:MediaQuery.of(context).size.width*0.3,
                    margin:EdgeInsets.only(bottom:5),
                    child: TextButton(
                      style:TextButton.styleFrom(
                        backgroundColor:Color(0xff6fb554),
                        primary:Colors.white,
                        minimumSize:Size(MediaQuery.of(context).size.width*0.09,MediaQuery.of(context).size.height*0.07,),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),

                      child: Row(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          Text(
                            'SIGN IN AS ADMIN',style:GoogleFonts.montserrat(fontSize:10,fontWeight:FontWeight.bold,color:Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => adminSign()),
                        );                  },
                    ),
                  ),
                  SizedBox(width:10,),
                  Container(
                    width:MediaQuery.of(context).size.width*0.345,
                    margin:EdgeInsets.only(bottom:5),
                    child: Center(
                      child: TextButton(
                        style:TextButton.styleFrom(
                          backgroundColor:Color(0xff6fb554),
                          primary:Colors.white,
                          minimumSize:Size(MediaQuery.of(context).size.width*0.092,MediaQuery.of(context).size.height*0.07,),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),

                        child: Row(
                          crossAxisAlignment:CrossAxisAlignment.center,
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Text(
                              'SIGN IN AS LECTURER',style:GoogleFonts.montserrat(fontSize:10,fontWeight:FontWeight.bold,color:Colors.white),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => adminSign()),
                          );                  },
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}

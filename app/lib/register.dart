import 'package:google_fonts/google_fonts.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';



class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  var matric_number = "";
  var password = "";
  var full_name="";
  var course_code="";

  var _image;
  var _image_path;
  var address ="192.168.235.137:5000";
  bool is_loading=false;
  bool error=false;
  var error_message="";

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

  void submit_form(var fullName,var matric_no,var student_password,var image) async {

    if(image!=null && matric_no!="" && student_password!="" && fullName!=""){
      setState(() {
        is_loading=true;
      });
      final formData = FormData.fromMap({
        'full_name':fullName,
        'password':student_password,
        'matric_no':matric_no,
        'image': await MultipartFile.fromFile(image,filename: 'current.jpeg'),
      });
      var response = await Dio().post("http://$address/signup",data:formData,options: Options(
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>MyHomePage()),
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
  Widget build(BuildContext context) {
    return Scaffold(
        body:Stack(
          children: [Container(
            padding:EdgeInsets.only(top:MediaQuery.of(context).size.height*0.10),
            color:Colors.white,
            height:double.infinity,
            width:double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("REGISTER",style:GoogleFonts.dmSans(fontWeight:FontWeight.w900,fontSize:28,textStyle:TextStyle(letterSpacing:1)),),
                  SizedBox(height:40,),
                  Container(
                    width:MediaQuery.of(context).size.width*0.8,
                    child:TextField(
                      cursorColor:Colors.black,
                      onChanged:(value){
                        setState(() {
                          full_name=value;
                          print(value);
                        });
                      },

                      style:GoogleFonts.quicksand(color:Colors.grey,fontSize:18),
                      decoration:const InputDecoration(

                        isDense:true,
                        contentPadding:EdgeInsets.all(20),

                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color:Color(0xFFf0f0f0), width: 2.0),
                        ),
                        prefixIcon:Icon(Icons.person,color:Colors.grey,size:20,),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Color(0xFFf0f0f0), width: 2.0
                          ),
                        ),
                        filled:true,
                        border:InputBorder.none,
                        fillColor:Color(0xffebebeb),

                        labelText:"Full name",
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
                      cursorColor:Colors.black,
                      onChanged:(value){
                        setState(() {
                          matric_number=value;
                          print(value);
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
                          password=value;
                          print(value);
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
                        Text("$error_message",style:GoogleFonts.montserrat(color:Colors.red,fontSize:15))
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
                              'REGISTER',style:GoogleFonts.montserrat(fontSize:17,fontWeight:FontWeight.bold,color:Colors.white),
                            ),
                            SizedBox(width:10,),
                          ],
                        ),
                        onPressed: () {
                          submit_form(full_name,matric_number,password,_image_path);
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
                        Text('Already registered ?',style:GoogleFonts.montserrat(fontSize:18,fontWeight:FontWeight.w400),),
                        SizedBox(width:5,),
                        GestureDetector(
                          onTap:(){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),
                            );
                          },
                          child: Text('Login',style:GoogleFonts.montserrat(fontSize:18,fontWeight:FontWeight.w700,decoration:TextDecoration.underline),
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
            ):SizedBox(),],
        )

    );
  }
}

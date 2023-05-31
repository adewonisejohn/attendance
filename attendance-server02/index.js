var express = require('express');
var app = express();
var mysql  = require('mysql');
const bodyParser=require("body-parser");
const multer = require('multer');
const path = require("path");
const fs = require("fs");
var csvParse= require('csv-parse');
var new_records=null;


app.use(express.json())
app.use(bodyParser.urlencoded({extended:true}));


app.use(express.static(__dirname+'/public'));

var image_new_name = null

const { spawn } = require('child_process');
const { strict } = require("assert");
var image_new_name_register="";
var student_list=[];





const storage_register = multer.diskStorage({
    destination : (req, file, cb)=>{
        cb(null,__dirname+'/database')
    },

    filename: (req, file,cb)=>{
       
        image_new_name_register=Date.now()+".jpeg";
        console.log("---------------------------------------------");
        console.log(image_new_name_register);
        console.log("-----------------------------------------------");
        cb(null,image_new_name_register)
    
    }
})

const upload_register = multer({storage:storage_register})


const storage = multer.diskStorage({
    destination : (req, file, cb)=>{
        cb(null,__dirname+'/images')
    },

    filename: (req, file,cb)=>{
        console.log(file)
        image_new_name=Date.now()+ path.extname(file.originalname);
        cb(null,"current_image.jpeg")
    
    }
})

const upload = multer({storage:storage})

var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : '',
    database : 'attendance'
  });

  try{
    connection.connect();
    console.log("Database connected");

  }catch(e){
    console.log(e)
  }


  function scan_face(face_location){
    var python = spawn('python3',
    [
        './python-files/compare-face.py',
        face_location
    ]);
    python.stdout.on('data',async function(data){
        try{
            result=data.toString().trim();
            console.log("---------result is below : ---------")
            if(result=="1"){
                console.log("face is recognized");
                res.sendFile(__dirname+"/public/sucessful.html")
            }else if(result == "2"){
                console.log("face not detected");
            }else{
                console.log("user not found")
            }
            
        }catch(eror){
            console.error(eror)
            console.log("an error occured")
        }
        
    
    });

    python.on('close',function(data){
        console.log("python execution done")
    })

  }
   



app.get("/",function(req,res){
    res.sendFile("index.html");
    res.end()
});

app.get("/signup",function(req,res){
    res.sendFile(__dirname+"/public/signup.html");
});


class Student_sign {
    constructor(name = "", id="", date="", course_code="") {
        this.course_code=course_code;
        this.name = name;
        this.id = id;
        this.date = date;
    }
    saveAsCSV() {
        const csv = `${this.name},${this.id},${this.date}\n`;
        try {
            fs.appendFileSync("./attendance-folder/"+this.course_code.toLowerCase()+".csv", csv);
        } catch (err) {
            console.error(err);
        }
    }
}



app.post("/login",upload.single('image'),function(req,res){
    var password = req.body.password;
    var matric_no = req.body.matric_no;
    var course=req.body.course;


    const date = new Date(); 

    let year= date.getFullYear().toString(); 
    let month=date.getMonth().toString(); 
    let day= date.getDate().toString(); 


    console.log(year+month+day); 



    var sql = "SELECT * FROM students WHERE matric_no = ? and password = ?";
    connection.query(sql,[matric_no,password],function (err, result) {
        if (err){
            console.log(err)
        }else{
            if(result.length>0){
                var name = result[0].full_name;
                var matric_no = result[0].matric_no;
                var python = spawn('python3',
                [
                    './python-files/compare-face.py',
                    result[0].face_location
                ]);
                python.stdout.on('data',async function(data){
                    try{
                        result=data.toString().trim();
                        console.log("---------result is below : ---------")
                        if(result=="1"){
                            console.log("face is recognized");
                            var today = new Date();
                            var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                            if(fs.existsSync("./attendance-folder/"+course+"-"+year+"-"+month+"-"+day+".csv") == false){
                                const students = new Student_sign("Full name","Matric number","Sign in time",course+"-"+year+"-"+month+"-"+day);
                                students.saveAsCSV();
                                const students2 = new Student_sign(name,matric_no,time.toString(),course+"-"+year+"-"+month+"-"+day);
                                students2.saveAsCSV();
                            }else{
                                const students = new Student_sign(name,matric_no,time.toString(),course+"-"+year+"-"+month+"-"+day);
                                students.saveAsCSV();
                            }
                            
                            res.json({
                                "status":true,
                                "message":"Signed in successfully"
                            })
                        }else if(result == "2"){
                            console.log("face not detected");
                            res.json({
                                "status":false,
                                "message":"face not detected"
                            })

                        }else{
                            res.json({
                                "status":false,
                                "message":"face not recognized"
                            })
                        }
                        
                    }catch(eror){
                        console.error(eror)
                        console.log("an error occured")
                        //res.sendFile(__dirname+"/public/index.html");
                        res.json({
                                "status":false,
                                "message":"An error occured"
                            })

                    }
                    
                
                });
            
                python.on('close',function(data){
                    console.log("python execution done")
                })
            }else{
                res.json(
                    {
                        "status":false,
                        "message":"Invalid credentials"
                    }
                )
            }
        }
    });

});

app.post("/signup",upload_register.single('image'),function(req,res){
    console.log(req.body)
    var values =[[req.body.full_name,req.body.matric_no,req.body.password,image_new_name_register]]
    var sql = "INSERT INTO students (full_name,matric_no,password,face_location) VALUES ?";
    connection.query(sql,[values],function (err, result) {
        if (err){
            console.log(err)
            res.json({
                "status":false,
                "message":"An error occured"
            })
            
        }else{
            var python = spawn('python3',
            [
                './python-files/detect-face.py',
                image_new_name_register
            ]);
            python.stdout.on('data',async function(data){
                var result = data.toString().trim()
                if(result=="1"){
                    console.log("face detected");
                    res.json({
                        "status":true
                    })
                }else{
                    console.log("face not detected")
                     res.json({
                        "status":false,
                        "message":"Face not detected"
                    })

                }
            });

            python.on('close',function(data){
                console.log("python execution closed")
            })

        }
    });
})



app.post("/signout",upload.single('image'),function(req,res){
    var password = req.body.password;
    var matric_no = req.body.matric_no;
    var course=req.body.course;


    const date = new Date(); 
    let year= date.getFullYear().toString(); 
    let month=date.getMonth().toString(); 
    let day= date.getDate().toString(); 
    console.log(year+month+day); 



    function student_sign_out(student_name,signout_time,attendance_name){
        class Student_sign {
            constructor(name = "", id="", date="",signout_time="", course_code="") {
                this.course_code=course_code;
                this.name = name;
                this.id = id;
                this.date = date;
                this.signout_time=signout_time
            }
            saveAsCSV() {
                const csv = `${this.name},${this.id},${this.date},${this.signout_time}\n`;
                try {
                    fs.appendFileSync('./attendance-folder/'+attendance_name, csv);
                } catch (err) {
                    console.error(err);
                }
            }
        }
        
        
        var parser = csvParse.parse({columns: false}, function (err, records) {
            var gotten_index=null;
            console.log(records.length);

            for(var x =0;x<records.length;x++){
                if(records[x][0]==student_name){
                    console.log("gotten the index");
                    console.log(records[x])
                    gotten_index=x
                }
            }
            records[gotten_index][3]=signout_time
            new_records=records;
            console.log(new_records)
        
            fs.unlinkSync('./attendance-folder/'+attendance_name);
            try {
                for(var i in new_records[0]){
                    
                    try{
                        var details = new_records[i]
                        const students = new Student_sign(details[0],details[1],details[2],details[3],signout_time,attendance_name);
                        students.saveAsCSV();
        
                    }catch(e){
                        console.log("not found")
                    }
                }
            } catch (err) {
                console.error(err);
            }
        
        
        });
        
        
        
        fs.createReadStream('./attendance-folder/'+attendance_name).pipe(parser);
    }



    var sql = "SELECT * FROM students WHERE matric_no = ? and password = ?";
    connection.query(sql,[matric_no,password],function (err, result) {
        if (err){
            console.log(err)
        }else{
            if(result.length>0){
                var name = result[0].full_name;
                var matric_no = result[0].matric_no;
                var python = spawn('python3',
                [
                    './python-files/compare-face.py',
                    result[0].face_location
                ]);
                python.stdout.on('data',async function(data){
                    try{
                        result=data.toString().trim();
                        console.log("---------result is below : ---------")
                        if(result=="1"){
                            console.log("face is recognized");
                            var today = new Date();
                            var time = today.getHours() + ":" + today.getMinutes() + ":" + today.getSeconds();
                            student_sign_out(name,time.toString(),course+"-"+year+"-"+month+"-"+day+".csv")
                            res.json({
                                "status":true,
                                "message":"Signed out successfully"
                            })
                        }else if(result == "2"){
                            console.log("face not detected");
                            res.json({
                                "status":false,
                                "message":"face not detected"
                            })

                        }else{
                            res.json({
                                "status":false,
                                "message":"face not recognized"
                            })
                        }
                        
                    }catch(eror){
                        console.error(eror)
                        console.log("an error occured")
                        //res.sendFile(__dirname+"/public/index.html");
                        res.json({
                                "status":false,
                                "message":"An error occured"
                            })

                    }
                    
                
                });
            
                python.on('close',function(data){
                    console.log("python execution done")
                })
            }else{
                res.json(
                    {
                        "status":false,
                        "message":"Invalid credentials"
                    }
                )
            }
        }
    });

});

app.listen(5000,function(){
    console.log("server started on port 5000")
});
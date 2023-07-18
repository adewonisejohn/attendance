var route = require('express').Router();
const bodyParser=require("body-parser");
const multer = require('multer');
const path = require("path");
const fs = require("fs");
var csvParse= require('csv-parse');
const { parse } = require("csv-parse");

var list=[]


const attendance_name_list=[]

const folderPath = './attendance-folder';



function getList(){
    fs.readdirSync(folderPath).map(fileName => {
        attendance_name_list.push(fileName)
    })
    return attendance_name_list
}

console.log(getList())

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

const upload_register = multer({storage:storage_register});



route.post("/signin",upload_register.single('image'),(req,res)=>{
    res.json({
        'status':true,
        'data':attendance_name_list
    })
});

route.post("/getattendance",upload_register.single('image'),(req,res)=>{
    var name = req.body.name;
    console.log(name)

    try{
         fs.createReadStream("./attendance-folder/"+name)
        .pipe(parse({ delimiter: ",", from_line: 2 }))
        .on("data", function (row) {
            list.push(row)

        })
        .on("end",function(){
            console.log(list)
            res.json({
                "status":true,
                "data":list
                
            })
            list=[]

        })
        .on("error",function(){
            res.json({
                "status":false,
            })
        });
    }
    catch(e){
        res.json({
            "status":false
        })
    }

   
})


module.exports=route




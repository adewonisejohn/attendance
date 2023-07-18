const fs = require('fs');

const list=[]

const folderPath = './attendance-folder';

function getList(){
    fs.readdirSync(folderPath).map(fileName => {
        list.push(fileName)
    })
    return list
}



console.log(getList())









var shell = require('shelljs');
var http = require('http');

var server = http.createServer((request, response)=>{
    if(request.method === 'POST'){
        var body = '';
        request.on('data', (data)=>{
            body += data;
            var obj = JSON.parse(body);
            if(obj.commandType=="init"){
                var userHostName = shell.exec('echo "$USER@$HOSTNAME"').stdout.split("\n")[0];
                var workingDirectory = shell.exec('echo ":$PWD"').stdout.split("\n")[0];
                var command_stdout = "";
                var command_stderr = "";
                response.end(
                    `{
                        "userHostName": "${userHostName}",
                        "workingDirectory": "${workingDirectory}",
                        "stdout":"${command_stdout}",
                        "stderr":"${command_stderr}"
                    }`
                    );
            }
            else if(obj.commandType=="execute"){
                try{
                    var commandResult= shell.exec(obj.command);
                    console.log(commandResult.stdout.replace("\n", "\\n"))
                    var command_stdout = commandResult.stdout.replace("\n", "\\n");
                    var command_stderr = commandResult.stderr.replace("\n", "\\n");
                    var userHostName = shell.exec('echo "$USER@$HOSTNAME"').stdout.split("\n")[0];
                    var workingDirectory = shell.exec('echo "$PWD"').stdout.split("\n")[0];
                    response.end(
                        `{
                            "userHostName": "${userHostName}",
                            "workingDirectory": "${workingDirectory}",
                            "stdout":"${command_stdout}",
                            "stderr":"${command_stderr}"
                        }`
                        );
                }
                catch(e){
                    response.end(
                        `Something went wrong...${e}`
                    );
                }
                
            }
            
        })
    }
})

const port = 5768;
server.listen(port, "localhost");
console.log(`Listening http://localhost:${port}`)

// shell.cd("/home/mngazy/Desktop/YoctoGUI");
// // shell.exec("git clone git://git.yoctoproject.org/poky");
// console.log(shell.exec("pwd"));
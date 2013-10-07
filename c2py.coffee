###
	Module dependencies.
###
express = require("express")
http = require("http")
path = require("path")
uuid = require("uuid")

app = express()
spawn = require("child_process").spawn
python = spawn("python", ["main.py"])


# this 'boots' python
python.stdin.write JSON.stringify({ "code": "" }) + "\n"


# all environments
app.set "port", process.env.PORT or 3000
app.set "views", __dirname + "/views"
app.set "view engine", "ejs"
app.use express.favicon()
app.use express.logger("dev")
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join(__dirname, "public"))

# development only
app.use express.errorHandler()  if "development" is app.get("env")
sendToProcessServer = (data) ->
    data = JSON.stringify(data)
    python.stdin.write data + "\n"

python.stdout.on "data", (data) ->
    data = data.toString().split('\n')[0]
    data = JSON.parse(data)
    if data._id != undefined
        callbacks[data._id](data)
        delete callbacks[data._id]
    else
        console.log "did not have callback _id"

callbacks = {}

app.post "/", (req, res) ->
    code = req.body.code
    data = { "code": code, _id: uuid.v4() }
    callbacks[data._id] = (data) ->
        res.json(data)
    sendToProcessServer data, (data) ->
        console.log data


    
http.createServer(app).listen app.get("port"), ->
    console.log "Express server listening on port " + app.get("port")

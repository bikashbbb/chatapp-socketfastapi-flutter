# we are setting up the sockets and using those here !
import socketio
from fastapi_socketio import SocketManager
from fastapi import FastAPI, WebSocket,WebSocketDisconnect,Depends
from fastapi.responses import HTMLResponse
from datetime import datetime
import json
from crud.chatcrud import Db_handler
from validators.schemas import MessageRead
from db import get_db
from sqlalchemy.orm import Session
import ast

app = FastAPI()

html = """
<!DOCTYPE html>
<html>
    <head>
        <title>Chat</title>
    </head>
    <body>
        <h1>WebSocket Chat</h1>
        <form action="" onsubmit="sendMessage(event)">
            <input type="text" id="messageText" autocomplete="off"/>
            <button>Send</button>
        </form>
        <ul id='messages'>
        </ul>
        <script>
            var ws = new WebSocket("ws://localhost:8000/ws");
            ws.onmessage = function(event) {
                var messages = document.getElementById('messages')
                var message = document.createElement('li')
                var content = document.createTextNode(event.data)
                message.appendChild(content)
                messages.appendChild(message)
            };
            function sendMessage(event) {
                event.preventDefault();
                var input = document.getElementById("messageText");
                var data = {
                    data: input.value,
                    type: "msg"
                };
                var jsonString = JSON.stringify(data);
                ws.send(jsonString);
                input.value = '';
            }
        </script>
    </body>
</html>
"""


@app.get("/")
async def get():
    return HTMLResponse(html)
# some one will hit this end point and they will connect with us ! and we will keep on emiting data

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket,db: Session = Depends(get_db),uid:str= "bik"):
    await manager.connect(websocket)
    db_handler= Db_handler()
    try:
        # when trying to send msg to disconnected ws it throws error !
        while True:
            data = await websocket.receive_text()
            # Convert the string to a dictionary using ast.literal_eval()
            #data_dict = ast.literal_eval(data)
            data = json.loads(data)
            if data['type'] == "msg":
            
                #await manager.send_personal_message(f"You wrote: {data}", websocket)
                db_created =  db_handler.create_message(db=db,msg=data['data'],username=uid)
                if(db_created):
                    await manager.broadcast(db_handler.response_data(data['data'], uid))
                else:
                    await manager.broadcast(db_handler.response_data("Invalid user or empty message", uid))
            else:
                await manager.broadcast(db_handler.response_data(data['data'], uid),type = "T")
            # save to db 

    except WebSocketDisconnect:
        # when disconnet hunxa we remove the socket ! and done 
        print("connection lost with user")
        manager.disconnect(websocket)
        await manager.broadcast(db_handler.response_data("User left the server !", uid))


class ConnectionManager:
    def __init__(self):
        # global var 
        self.active_connections: list[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def send_personal_message(self, message: str, websocket: WebSocket):
        await websocket.send_text(message)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = ConnectionManager()
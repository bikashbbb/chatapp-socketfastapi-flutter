
""" # socketsio client side, app banayera i am familiar with so much things to become a better backend dev
import socketio
import asyncio

sio_client =  socketio.AsyncClient()

@sio_client.event
async def connect():
    print(" i am connected")

@sio_client.event
async def disconnect():
    print(" i am disconnected")

async def main():
    await sio_client.connect("ws://localhost:8000",
    socketio_path='/ws'
    )
    # Emit a message using the "send_msg" event
    await sio_client.emit("chat_message", {"uid": 1, "message": "Hello, server!",'lado':"lad22"})
    await sio_client.wait()
    await sio_client.disconnect()
    

asyncio.run(main())

 """
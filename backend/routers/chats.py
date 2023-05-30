from fastapi import APIRouter,Depends,HTTPException,status,WebSocket
from sqlalchemy.orm import Session
from db import get_db
#from validators.schemas import User
from models.models import Userss
from fastapi import APIRouter,Depends,HTTPException,status,Response
from sqlalchemy.orm import Session
from db import get_db
from crud.chatcrud import Db_handler
from validators.schemas import MessageResponse

router = APIRouter(
    prefix="/chats",
)

chatcrud = Db_handler()

# we write this with indentation 20 entries at a time !
@router.get("/",response_model=list[MessageResponse])
def getAll_chats(db:Session = Depends(get_db),skip:int= 0, limit:int= 20):
    all_msgs = chatcrud.get_messages(db,skip=skip,limit=limit)
    return all_msgs
   
@router.post("/po")
def post_Chat():
    pass



# we will have two functions for now one to get the chat another to post ! we will use a socket here
# lets have a websocket shit !


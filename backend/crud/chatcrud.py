import json
from sqlalchemy.orm import Session
from models.models import Messages,Userss
import  validators.schemas as schemas
from datetime import datetime
from sqlalchemy import desc

class Db_handler:

    def __init__(self):
        pass

    def response_data(self,data,uid,type = "msg"):
        return json.dumps({
                "msg":
                    data, "time" :str(datetime.now()), "uid": uid,
                    "type": type
                })
                
    def get_message(self,db: Session, message_id: int):
        return db.query(Messages).filter(Message.id == message_id).first()

    def get_messages(self,db: Session, skip: int = 0, limit: int = 10)-> Messages:
        return db.query(Messages).order_by(desc(Messages.time)).offset(skip).limit(limit).all()

    def create_message(self,db: Session, msg,username)-> bool:
        try:
            if not msg.strip():  # Check if msg is not empty or whitespace only
                return False

            user = db.query(Userss).filter(Userss.username == username).first()
            print(f"the user{user}")
            db_message =Messages(msg=msg, user_id=username)
            db.add(db_message)
            db.commit()
            db.refresh(db_message)
            return True
        except Exception as e:
            print(e)
            return False

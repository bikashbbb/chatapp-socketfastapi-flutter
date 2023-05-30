from db import Base
from sqlalchemy import Column, Integer, String, Boolean,TIMESTAMP,ForeignKey,DateTime
from datetime import datetime 

class Userss(Base):
    __tablename__ = "users"
    username =  Column(String, nullable = False,primary_key= True)
    password =  Column(String, nullable = False)

class Messages(Base):
    __tablename__ = "messages"
    id =  Column(Integer, primary_key= True,autoincrement=True)
    msg =  Column(String, nullable = False)
    user_id = Column(String, ForeignKey("users.username"),nullable=False)
    time = Column(DateTime, nullable = False,default=datetime.now)
    # is read vanne option hallna parxa


    
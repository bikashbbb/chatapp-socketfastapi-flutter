# schemas are used within our app to take or provide response ! validator
from pydantic import BaseModel
from pydantic import Field
from datetime import datetime

class _UserBase(BaseModel):
    name: str
    
class UserRequest(_UserBase):
    password: str = Field(
        min_length=8)

class MessageBase(BaseModel):
    msg: str
    user_id: str

class MessageRequest(MessageBase):
    pass

class MessageRead(MessageBase):
    id: int
    time: datetime

class MessageResponse(MessageRead):
    class Config:
        # this lets class to talk the db class we created else, it accepts json 
        orm_mode = True



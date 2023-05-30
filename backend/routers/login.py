# so this file will contain the api's data for login shit ! will we use the jwt token ? no ! 
# we will keep it simple 

from fastapi import APIRouter,Depends,HTTPException,status,Response
from sqlalchemy.orm import Session
from db import get_db
from validators.schemas import UserRequest
from models.models import Userss
from fastapi.responses import JSONResponse

router = APIRouter(
    prefix="/login",
)
# we will have the data stored as it is will just validate in the db, user chai we will create by self.
@router.post("/")
def loginUser(user: UserRequest,db: Session= Depends(get_db)):
    # Use the provided database session (`db`) to perform database operations
    db_userquery = db.query(Userss).filter(Userss.username == user.name).first()
    
    if db_userquery == None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, detail="username or password is invalid")
    if db_userquery.password == user.password:
        return JSONResponse({"output": True,}, status_code=200)
    return JSONResponse({"output": False}, status_code=401)


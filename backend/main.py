# so we are building a chat application that lets user chat in a group if connected at same wifi !
# planning is important 

# api points we need ?
# login wala chaiyo api point first 
from db import engine,Base
from sqlalchemy.orm import Session
import psycopg2
from routers.login import router as lrouter
from routers.chats import router
from routers.soc import app

Base.metadata.create_all(bind= engine)

#app.mount('/socket.io',app=sio_app)

# we have the sql
try:
    conn = psycopg2.connect(host= "localhost",
        database="chatgpt", user="postgres", 
    )
    curser = conn.cursor()
    print(" okey! success")
#exotic: weird, foreign

except Exception as e:
    print("error was:",e)


# we use sqalalchamedy to write py code to sql
# we use psycopg2 to talk with the dbm system !

app.include_router(lrouter)
app.include_router(router)

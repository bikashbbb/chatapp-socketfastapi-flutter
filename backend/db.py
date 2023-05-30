# will handle our code in db/
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

sql_db_url = "postgresql://postgres@localhost/chatgpt"

engine = create_engine(sql_db_url)
# i have to learn about jwt token at the time of making the chatapp project !
# session is used to talk to the db
SessionLocal = sessionmaker(autocommit=False,autoflush=False,bind=engine)
# this base is the sql base , and weve got the psycopg2 to talk with postgres.
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


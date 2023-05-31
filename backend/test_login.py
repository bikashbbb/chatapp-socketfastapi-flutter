from fastapi.testclient import TestClient
from main import app
import pytest
# this is a tester 
client = TestClient(app)

arguments = [{"name": "alex", "password": "iamahero"},
   {"name": "bik", "password": "iamahero"},
   {"name": "bik", "password": "iamaherosahhsa"},
    {"name": "bik", "password": "iamah"},
]

@pytest.mark.parametrize("jsonbody",arguments)
def test_login(jsonbody):
    response = client.post('/login/', json = jsonbody)
    print(response.json())
    assert response.status_code == 200

def test_chats():
    response = client.get('/chats/')
    print(response.json())
    assert response.status_code == 200



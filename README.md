Chat App

Chat App is a real-time chat application built with WebSocket technology. It consists of a FastAPI-based backend server for handling WebSocket connections and a Flutter frontend for the user interface.Its a simple basic application but, scalable 

![Chat App Demo]
<img src="https://github.com/bikashbbb/chatapp-socketfastapi-flutter/assets/63708892/5dc80054-9af6-455e-b305-f533468eff79" alt="Login Screen" width="400" height="auto">


## Screenshots

<img src="https://github.com/bikashbbb/chatapp-socketfastapi-flutter/assets/63708892/eea6d3b8-751e-498f-b18e-1fce6d2bb4a5" alt="Login Screen" width="400" height="auto">

<img src="https://github.com/bikashbbb/chatapp-socketfastapi-flutter/assets/63708892/6495bdb4-5b97-4ac3-91b9-fb826e752f96" alt="Chat Screen" width="400" height="auto">

<img src="https://github.com/bikashbbb/chatapp-socketfastapi-flutter/assets/63708892/1b43924d-bad4-4406-aed4-4e28e14571d7" alt="Screenshot_1685512334" width="400" height="auto">



## Features

- Real-time chat functionality
- User authentication
- WebSocket communication
- Responsive user interface
- 
## Technologies Used

### Backend

- FastAPI: A modern, fast (high-performance) web framework for building APIs with Python.
- WebSocket: A communication protocol that provides full-duplex communication channels over a single TCP connection.

### Frontend

- Flutter: An open-source UI software development kit created by Google for building cross-platform applications.
- WebSocket: A package for WebSocket communication in Flutter.

## Getting Started

To get a local copy of the project up and running, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/bikashbbb/chatapp-socketfastapi-flutter.git
   ```

### Backend Setup

- Navigate to the `backend` folder.
- Install the dependencies:
  ```bash
  pip install -r requirements.txt
  ```
- Start the FastAPI server:
  ```bash
  uvicorn main:app --reload
  ```
make sure to make a user account from the db or update the code . this is just a simple application
### Frontend Setup

- Navigate to the `frontend` folder.
- Install the dependencies:
  ```bash
  flutter pub get
  ```
- Run the app:
  ```bash
  flutter run
  ```

Open the app on your preferred device/emulator and enjoy real-time chatting!

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please feel free to submit a pull request.

## License

This project is licensed under the MIT License.

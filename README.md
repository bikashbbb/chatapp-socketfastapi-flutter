git push -f origin master# Chat App

Chat App is a real-time chat application built with WebSocket technology. It consists of a FastAPI-based backend server for handling WebSocket connections and a Flutter frontend for the user interface.

![Chat App Demo](demo/demo.gif)

## Features

- Real-time chat functionality
- User authentication
- WebSocket communication
- Responsive user interface

## Screenshots

![Login Screen](demo/login.png)
![Chat Screen](demo/chat.png)

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

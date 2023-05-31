import 'dart:async';
import 'dart:convert';

import 'package:chat_ui/consts.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart' as http;

class StreamSocket {
  final _socketResponse = StreamController<String>.broadcast();
  IOWebSocketChannel ioWebSocketChannel;
  StreamSocket(this.ioWebSocketChannel);

/*   final StreamSocket _streamSocket = StreamSocket(IOWebSocketChannel.connect(
        'ws://10.0.2.2:8000/ws?uid=${ChatRoomPage.uid}'));
 */
  StreamSubscription? _liveChatSubscription;

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  void _listenToLiveChat() {
    _liveChatSubscription = ioWebSocketChannel.stream.listen((data) {
      addResponse(data);
    });
  }

  void _cancelLiveChatSubscription() {
    _liveChatSubscription?.cancel();
  }
}

class ChatRoomPage extends StatefulWidget {
  final String uid;

  const ChatRoomPage(this.uid, {super.key});
  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            tabs: const [
              Tab(
                text: 'Live Chat',
              ),
              Tab(text: 'History'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LiveChatSection(widget.uid),
                 HistorySection(
                  widget.uid
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveChatSection extends StatefulWidget {
  final String uid;

  LiveChatSection(
    this.uid, {
    super.key,
  });

  @override
  _LiveChatSectionState createState() => _LiveChatSectionState();
}

class _LiveChatSectionState extends State<LiveChatSection> {
  late StreamSocket _streamSocket;

  @override
  void initState() {
    super.initState();
    _streamSocket = StreamSocket(
        IOWebSocketChannel.connect('ws://10.0.2.2:8000/ws?uid=${widget.uid}'));
    _streamSocket._listenToLiveChat();
  }

  @override
  void dispose() {
    super.dispose();
    //_streamSocket.dispose();
  }

  TextEditingController messageController = TextEditingController();
  List initialdata = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // Existing code..
          child: StreamBuilder(
            stream: _streamSocket.getResponse,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // when a new data is recieved this gets called
                String messages = snapshot.data!;
                initialdata.add(messages);
                return ListView.builder(
                  itemCount: initialdata.length,
                  itemBuilder: (context, i) {
                    return Tile(
                      response: decodeWebSocketResponse(initialdata[i]),
                      uid: widget.uid,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                print(snapshot.data);
                return const Center(
                  child: Text("You can chat live with online friends !"),
                );
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  sendMessage();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Response decodeWebSocketResponse(String response) {
    Map<String, dynamic> decodedData = json.decode(response);
    return Response(
      type: decodedData['type'],
      data: decodedData['msg'],
      time: decodedData['time'],
      uid: decodedData['uid'].toString(),
    );
  }

  void sendMessage() {
    final message = messageController.text;
    _streamSocket.ioWebSocketChannel.sink.add(jsonEncode({
      "data": message,
      "type": "msg",
    }));
    messageController.clear();
  }
}

class Tile extends StatelessWidget {
  final Response response;
  bool splitTime;
  String uid;

  Tile(
      {super.key,
      required this.response,
      this.splitTime = true,
      required this.uid});

  @override
  Widget build(BuildContext context) {
    if (response.type == "msg") {
      List t = [];
      if (splitTime) t = response.time.split(" ");

      bool isThisUser = uid == response.uid;

      return Padding(
        padding: const EdgeInsets.all(2),
        child: ListTile(
            tileColor: isThisUser ? Colors.green[200] : Colors.black12,
            title: isThisUser
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "me",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        splitTime
                            ? t[0] +
                                " " +
                                t[1][0] +
                                t[1][1] +
                                ":" +
                                t[1][3] +
                                t[1][4]
                            : response.time,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        splitTime
                            ? t[0] +
                                " " +
                                t[1][0] +
                                t[1][1] +
                                ":" +
                                t[1][3] +
                                t[1][4]
                            : response.time,
                        style: const TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Text(
                        uid,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
            minLeadingWidth: 0,
            leading: !isThisUser
                ? const SizedBox()
                : const Icon(Icons.account_circle),
            trailing: !isThisUser
                ? const Icon(Icons.account_circle)
                : const SizedBox(),
            subtitle: Text(response.data)),
      );
    }
    return const SizedBox();
  }
}

// lets do multiuser shit

class HistorySection extends StatefulWidget {
  final String uid;
  const HistorySection(this.uid,{Key? key});

  @override
  _HistorySectionState createState() => _HistorySectionState();
}

class _HistorySectionState extends State<HistorySection> {
  List<Response> messageList = [];

  @override
  void initState() {
    super.initState();
    fetchMessageHistory();
  }

  Future<void> fetchMessageHistory() async {
    final url = baseuri + "/chats/"; // Replace with your API endpoint
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<Response> messages = [];
      for (var item in jsonData) {
        messages.add(Response.fromJson(item));
      }
      setState(() {
        messageList = messages;
      });
    } else {
      // Handle error case
      print('Failed to fetch message history');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messageList.length,
      itemBuilder: (context, i) {
        return Tile(
          response: messageList[i],
          splitTime: false,
          uid: widget.uid,
        );
      },
    );
  }
}

class Response {
  String data, time, uid;
  String type;

  Response(
      {required this.data,
      required this.time,
      required this.uid,
      this.type = 'msg'});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      data: json['msg'],
      uid: json['user_id'],
      time: json['time'],
    );
  }
}

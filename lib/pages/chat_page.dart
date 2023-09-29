import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../components/chat_bubble.dart';
import '../components/my_text_field.dart';
import '../services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receivedUserEmail;
  final String receivedUserId;
  const ChatPage({super.key, required this.receivedUserEmail, required this.receivedUserId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  void sendMessage() async{
    //only send if there is something to send
    if (_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receivedUserId, _messageController.text);

      //clear
      _messageController.clear();
    }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(widget.receivedUserEmail),
        backgroundColor: Colors.grey[900],

      ),

      body: Column(
        children: [
          Expanded(
              child: _buildMessageList(),
          ),
          _buildMessageInput(),

          const SizedBox(height: 25,)
        ],
      ),
    );
  }
  //build Message List
  Widget _buildMessageList(){
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receivedUserId, _firebaseAuth.currentUser!.uid),
        builder: (context, snapshot){
        if (snapshot.hasError){
          return(Text('Error${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading....');
          }

        return ListView(
          children: snapshot.data!.docs.map((document)=>
              _buildMessageItem(document)).toList(),
        );
    },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic>data = document.data() as Map<String, dynamic>;

    //align our messages to right and other users to right
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid) ?
    Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ?
          CrossAxisAlignment.end:
          CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid) ?
          MainAxisAlignment.end:
          MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),

            const SizedBox(height: 5,),
            ChatBubble(message: data['message'],),
          ],
        ),
      ),
    );

  }



//message input built
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
              child:MyTextField(
                  controller: _messageController,
                  hintText: 'Enter your message',
                  obscureText: false)),
          //send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward,size: 40,)),
        ],
      ),
    );

}



}



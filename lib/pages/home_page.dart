

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth/auth_service.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign out user
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KuraKani \n by iceyy'),
        backgroundColor: Colors.grey[900],

        /*actions: [
          IconButton(onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),

        ],*/
      ),
      body: _buildUserList(),
      backgroundColor: Colors.grey[400],



      );


  }



  //build a list of users except for current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) =>
              _buildUserListItem(doc))
              .toList(),


        );
      },
    );
  }

//build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map <String, dynamic>;

    //display all users except current
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          //pass clicked user's chat page
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              ChatPage(receivedUserEmail: data['email'],
                receivedUserId: data['uid'],
              ),
          ),
          );
        },
      );
    }
    else {
      return Container();
    }
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:we_talk/components/drawer.dart';
import 'package:we_talk/components/my_text_field.dart';
import 'package:we_talk/helper/helper_methods.dart';
import 'package:we_talk/main.dart';
import 'package:we_talk/pages/home_page.dart';
import 'package:we_talk/pages/profile_page.dart';
import 'package:we_talk/pages/wall_post_new.dart';

import '../services/auth/auth_gate.dart';
import 'chat_page.dart';

class WallPage extends StatefulWidget {
  const WallPage({super.key});

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {

  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController textController = TextEditingController();



  void postMessage(){
    //only post if there is something in the TextField
    if(textController.text.isNotEmpty){
      FirebaseFirestore.instance.collection("UserPosts").add(
        {
          'UserEmail': currentUser.email,
          'Message': textController.text,
          'TimeStamp': Timestamp.now(),
          'Likes' : [],


          }
      );

    }
    //clear textfield
    setState(() {
      textController.clear();
    });
  }

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  void goToProfilePage(){
    ///pop menu drawer
    Navigator.pop(context);
    ///go to profile page
    Navigator.push(context,
        MaterialPageRoute(
          builder: (context)=> ProfilePage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('The Text-Wall'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [

          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
              HomePage()
            ),
            );
          }, icon: Icon(Icons.message))

        ],
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: Column(
        children: [
          //the wall
          Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.
                collection("UserPosts").
                orderBy("TimeStamp",descending: false,).snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        //get the message
                      final post = snapshot.data!.docs[index];
                      return WallPostNew(
                        message: post['Message'],
                        user: post['UserEmail'],
                        postId: post.id,
                        likes:List<String>.from(post['Likes'] ?? []),
                        time: formatDate(post['TimeStamp']),
                      );
                    },
                    );
                  }
                  else if(snapshot.hasError){
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );

                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },

              ),
          ),




          //post message
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                //Textfield
                Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Tmro dimag ma k cha...',
                      obscureText: false,


                    ),

                ),
                //post button
                IconButton(
                    onPressed: postMessage,
                    icon: Icon(Icons.arrow_upward, size: 40, color: Colors.red,)),




              ],
            ),
          ),


          //logged in as
              Text("Logged in as: " + currentUser.email! , style: TextStyle(color: Colors.grey),),

          const SizedBox(
            height: 50,
          ),


       ]
      ),
      );

  }
}

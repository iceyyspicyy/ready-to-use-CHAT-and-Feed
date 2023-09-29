



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_talk/components/like_button.dart';
import 'package:we_talk/components/comment.dart';

import '../components/comment_button.dart';
import '../helper/helper_methods.dart';

class WallPostNew extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;
  final String time;


  const WallPostNew({super.key, required this.message, required this.user, required this.postId, required this.likes, required this.time});

  @override
  State<WallPostNew> createState() => _WallPostNewState();
}

class _WallPostNewState extends State<WallPostNew> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  bool isLiked = false;

  //comment text controller
  final _commentTextController = TextEditingController();


    @override
    void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike(){
      setState(() {
        isLiked = !isLiked;
      });

      //access document in firebase
    DocumentReference postRef = FirebaseFirestore.instance.collection('UserPosts').doc(widget.postId);

    if(isLiked){
      //if liked the user's email is added to 'likes' field
        postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email])
        });
      }else {
      //if unliked, remove the user's email from the likes field
          postRef.update({
            'Likes':FieldValue.arrayRemove([currentUser.email])
          });
      }
    }

    void addComment(String commentText){
      //write comment to firestore under comments collection for the post
      FirebaseFirestore.instance
          .collection("UserPosts")
          .doc(widget.postId)
          .collection("Comments")
          .add({
        "CommentText": commentText,
        "CommentedBy" : currentUser.email,
        "CommentTime": Timestamp.now(),
      });
    }

    //show a dialogbox for adding comment
  void showCommentDialog(){
      showDialog(context: context, builder: (context) =>
      AlertDialog(
        title: const Text('Add comment'),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: 'Write a comment..'),
        ),
        actions: [
          //cancel button
          TextButton(onPressed: (){
            //pop box
            Navigator.pop(context);

            //clear controller
            _commentTextController.clear();
          }
              ,
              child: const Text('Cancel')),
          //save button
          TextButton(onPressed: (){
            //add comment
            addComment(_commentTextController.text);
            //popbox
            Navigator.pop(context);
            //clear
            _commentTextController.clear();
          },
              child: const Text("Save"),),
        ],
      ),
      );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.only(top:25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            width: 20,
          ),
          //wallpost
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //message of wall
              Text(widget.message),
              const SizedBox(height: 5,),
              //user
              Row(
                children: [
                  Text(widget.user, style: TextStyle(color: Colors.grey[400]),),
                  Text(".",style: TextStyle(color: Colors.grey[400])),
                  Text(widget.time,style: TextStyle(color: Colors.grey[400])),
                ],
              )
            ],
          ),
          const SizedBox(height: 20,),

          //buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///like feature
              Column(
                children: [
                  //like button
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  //like count
                  Text(widget.likes.length.toString(),
                    style: TextStyle(color: Colors.grey),),

                ],
              ),
              const SizedBox(width: 10,),

              ///comment feature
              Column(
                children: [
                  //like button
                  CommentButton(
                    onTap: showCommentDialog,
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  //like count
                  Text('0',
                    style: TextStyle(color: Colors.grey),),



                ],
              ),

            ],
          ),

          const SizedBox(
            height:10,
          ),

          //comment under the post
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("UserPosts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("CommentTime", descending: true)
                .snapshots(),
            builder: (context, snapshot)  {
              //show loading circular
              if(!snapshot.hasData){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
              return ListView (
                shrinkWrap: true, //for nested lists
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc){
                  //get comment from firebase
                  final commentData = doc.data() as Map<String, dynamic>;

                  //return comment
                  return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]));
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

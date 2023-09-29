import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_talk/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;

  //all users
  final userCollection =FirebaseFirestore.instance.collection('users');

  //edit field
  Future<void> editField(String field) async{
    String newValue = "";
    await showDialog(

        context: context,
        builder: (context)=> AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit $field", style: TextStyle(color: Colors.white),
          ),
          content: TextField(

            autofocus: true,
            style: TextStyle(color: Colors.white),

            decoration: InputDecoration(
              hintText :"Enter new $field",
              hintStyle: TextStyle(color: Colors.grey),

            ),
            onChanged: (value){
              newValue = value;
            },

          ),
            actions: [
              //cancel button
              TextButton(
                child: const Text('Cancel',
                style: TextStyle(color: Colors.white),),
                onPressed: ()=> Navigator.pop(context),

              ),
              //saving button
              TextButton(
                child: const Text('Save',
                  style: TextStyle(color: Colors.white),),
                onPressed: ()=> Navigator.of(context).pop(newValue),

              ),


          ],

        ),
    );
    //updating in Firestore
    if(newValue.trim().length > 0){
      await userCollection.doc(currentUser.email).update({field: newValue});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('P R O F I L E'),
        backgroundColor: Colors.grey[900],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(currentUser.email).snapshots(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ///profile pic
                Image(image:
                NetworkImage
                ('https://scontent.fktm20-1.fna.fbcdn.net/v/t39.30808-6/282317664_5429139473816820_8362787960324578760_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=a2f6c7&_nc_ohc=esPpsw6oeEYAX9tmGCf&_nc_ht=scontent.fktm20-1.fna&oh=00_AfCfoLg0YgRq_ovStHEs7KwvRoQdZ9ltq7XZdZOh9VOlAA&oe=651858C9'),
                height: 150,),
                Text('I havent added a feature to change photo so just worship me',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.red),),
                
                

                ///user email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(
                    height: 50
                ),


                ///user details
                Padding(
                  padding: const EdgeInsets.only( left: 25),
                  child: Text(
                    'My Details', style: TextStyle(
                      color: Colors.grey[600]
                  ),
                  ),
                ),
                ///username
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'username',
                  onPressed : ()=>editField('username'),
                ),
                ///bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'bio ',
                  onPressed: ()=> editField('bio'),
                ),
                const SizedBox(height: 50,),
                ///userposts
                Padding(padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),)


              ],
            );
          }
          else if (snapshot.hasError){
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }
          return const Center(
              child: CircularProgressIndicator(),);
        },
    )
    );
  }
}

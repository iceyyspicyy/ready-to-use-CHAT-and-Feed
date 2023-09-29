import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final emailController = TextEditingController();
  final passwordController =  TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    if (passwordController.text != confirmPasswordController.text ){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match"),
      ),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);
    try{
      UserCredential userCredential =
      await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text);

      FirebaseFirestore.instance.collection("users").doc(userCredential.user!.email)
      .set({
        'username' : emailController.text.split('@')[0], //splots the email and takes first half
        'bio' : 'Empty bio..',
        'email' : emailController.text,
        'uid': userCredential.user!.uid,
        //can add more

      });
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  //logo
                  const Icon(Icons.flutter_dash, size: 80),
                  const SizedBox(
                    height: 50,
                  ),

                  //create account text
                  const Text("Account banayera KuraKani garne la :)",
                    style: TextStyle(
                        fontSize: 18
                    ),),
                  const SizedBox(
                    height: 50,
                  ),
                  //email text-field
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //password text-

                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,   //hides the password
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  //sign in
                  MyButton(onTap: (){
                    signUp();
                  }, text: 'Sign Up'),
                  const SizedBox(
                    height: 30,
                  ),
                  //Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already a Member? "),
                      SizedBox(height: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login Now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  )


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


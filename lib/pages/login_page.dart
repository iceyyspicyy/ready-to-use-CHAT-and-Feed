import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../components/my_button.dart';
import '../components/my_text_field.dart';
import '../services/auth/auth_service.dart';



class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  Future<void> signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(
          emailController.text,
          passwordController.text);
      }
      catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())));
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
                  Text("Made By:"),


                  //logo
                  Image(image:
                  NetworkImage
                    ('https://scontent.fktm20-1.fna.fbcdn.net/v/t39.30808-6/282317664_5429139473816820_8362787960324578760_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=a2f6c7&_nc_ohc=esPpsw6oeEYAX9tmGCf&_nc_ht=scontent.fktm20-1.fna&oh=00_AfCfoLg0YgRq_ovStHEs7KwvRoQdZ9ltq7XZdZOh9VOlAA&oe=651858C9'),
                  height: 200,

                  ),
                  const SizedBox(
                    height: 50,
                  ),

                  //welcome back
                  const Text("Iceyy ko Chat App ma Swagat cha, Login garnus",
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
                    height: 50,
                  ),

                  //sign in
                  MyButton(onTap: (){
                    signIn();
                  }, text: 'Login'),
                  const SizedBox(
                    height: 30,
                  ),
                  //Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Not a Member? "),
                      SizedBox(height: 4,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                            'Register Now',
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

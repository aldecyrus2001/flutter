import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voting_system/login/login.dart';
import '../assets/widget/button.dart';
import '../assets/widget/text_field.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // for Controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool processing = false;

  void registerUser() async {

    setState(() {
      processing = true;
    });

    var url = Uri.http("https://100.78.140.3/Flutter_Voting_System/query.php?action=register");
    var data = {
      "name":nameController.text,
      "email":emailController.text,
      "password":passwordController.text,
    };

    var res = await http.post(url,body: data);
    if(jsonDecode(res.body) == "account already exists") {
      Fluttertoast.showToast(msg: "account already exist, Please login!", toastLength: Toast.LENGTH_SHORT);

    }
    else {
      if (jsonDecode(res.body) == "true") {
        Fluttertoast.showToast(msg: "account created", toastLength: Toast.LENGTH_SHORT);
      }
      else {
        Fluttertoast.showToast(msg: "error", toastLength: Toast.LENGTH_SHORT);
      }
    }

    setState(() {
      processing = true;
    });

  }

  // bool isLoading = false;
  //
  // void signUpUser() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   String res = await AuthServicews().signUpUser(
  //     email: emailController.text,
  //     password: passwordController.text,
  //     name: nameController.text,
  //   );
  //
  //   // if signup is success, user has been created and navigate to the next screen
  //   // otherwise show the error message
  //   if (res == "success") {
  //     setState(() {
  //       isLoading = false;  // Set isLoading false after navigation
  //     });
  //
  //     // navigate to the next scre
  //     Navigator.of(context)
  //         .pushReplacement(MaterialPageRoute(builder: (context) => adminHomeScreen()));
  //   }
  //   else {
  //     setState(() {
  //       isLoading = false;
  //     });
  //
  //     // Show error message
  //     showSnackBar(context, res);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.8,
                child: Image.asset("lib/assets/images/signup.jpeg"),
              ),
              TextFieldInput(
                  textEditingController: nameController,
                  hintText: "Enter Your Name",
                  icon: Icons.person),
              TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Enter Your Email",
                  icon: Icons.email),
              TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Enter Your Password",
                  isPass: true,
                  icon: Icons.lock),
              MyButton(onTab: registerUser, text: "Sign Up"),
              SizedBox(
                height: height / 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Have an account?",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      " Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

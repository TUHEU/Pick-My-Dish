import 'package:flutter/material.dart';
import 'package:pick_my_dish/Screens/login_screen.dart';
import 'package:pick_my_dish/Services/api_service.dart';
import 'package:pick_my_dish/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
   final TextEditingController _fullNameController = TextEditingController();
   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _confirmPasswordController = TextEditingController();
  
  void _register() async {
    if (_fullNameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all fields', style: text),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match', style: text),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
    );

    try {
      bool success = await ApiService.register(
        _fullNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      Navigator.pop(context); // Hide loading

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful! Please login.', style: text),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed', style: text),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Hide loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e', style: text),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("assets/login/background.png"),
            fit: BoxFit.cover,
          ),
        ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                     Colors.transparent,
                     Colors.black,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,

                  )
                  )
                ),

              Padding(padding: EdgeInsets.all(30),
              child: Center(
                child: SingleChildScrollView(
                child: Column(
                  children: [
                  SizedBox(height: 20,),
                      //logo
                  Image.asset('assets/login/logo.png'),
                
                  SizedBox(height: 10),

                  Text(
                    "PICK MY DISH",
                    style: title,
                    ),

                  Text(
                    "Cook in easy way",
                    style: text,
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Register",
                    style: title,
                  ),

                  SizedBox(height: 15),   
              
                  Row(
                    children: [
                      Icon(Icons.person,
                      color: Colors.white,
                      size: iconSize,),
                      SizedBox(width: 10,),
                      Expanded(child:
                      TextField(
                        style: text,
                        controller: _fullNameController,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          hintStyle: placeHolder,
                        ),
                      ),
                    )],
                  ) ,

                  SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(Icons.email,
                      color: Colors.white,
                      size: iconSize,),
                      SizedBox(width: 10,),
                      Expanded(child:
                      TextField(
                        style: text,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          hintStyle: placeHolder,
                        ),
                      ),
                    )],
                  ),

                  SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(Icons.key,
                      color: Colors.white,
                      size: iconSize,),
                      SizedBox(width: 10,),
                      Expanded(child:
                      TextField(
                        style: text,
                        obscureText: !isPasswordVisible,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: placeHolder,
                          suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        ),
                      ),
                    )],
                  ),

                  SizedBox(height: 5),

                  Row(
                    children: [
                      Icon(Icons.key,
                      color: Colors.white,
                      size: iconSize,),
                      SizedBox(width: 10,),
                      Expanded(child:
                      TextField(
                        style: text,
                        controller: _confirmPasswordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          hintStyle: placeHolder,
                          suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        ),
                      ),
                    )],
                  ),

                  SizedBox(height: 20),

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.g_mobiledata, color: Colors.red, size: iconSize),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Your color
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Register",
                      style:  title,
                    ),
                  ),
                  
                  SizedBox(height: 100),

                  Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already Registered? ",
                        style: footer,),
                     GestureDetector(
                      onTap: () {
                        // Navigate to login screen
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        "Login Now",
                        style: footerClickable
                      ),
                    ),
                      
                    ],
                  ),
                ),
                ),
                ]
                ),
              ),
              ),
            ),
          ],
        ),
      ),
              );
  }
}
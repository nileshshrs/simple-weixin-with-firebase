import 'package:flutter/material.dart';
import 'package:weixin/utils/loading_dialog.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:weixin/viewmodels/registration_view_model.dart';
import 'package:weixin/views/login_screen.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "/registration";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isUsernameValid = false;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _updateUsernameValidity(String value) {
    setState(() {
      _isUsernameValid = value.length >= 3;
    });
  }

  void _updateEmailValidity(String value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    setState(() {
      _isEmailValid = emailRegex.hasMatch(value);
    });
  }

  void _updatePasswordValidity(String value) {
    setState(() {
      _isPasswordValid = value.length >= 6;
    });
  }

  void _updateConfirmPasswordValidity(String value) {
    setState(() {
      _isConfirmPasswordValid = value.length >= 6 && value == _passwordController.text;
    });
  }

  void _showFlushbar(BuildContext context, String message, bool isSuccess) {
    Flushbar(
      message: message,
      duration: Duration(seconds: 5),
      backgroundColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
      borderRadius: BorderRadius.circular(10.0),
      boxShadows: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        ),
      ],
      messageText: Text(
        message,
        style: TextStyle(
          color: isSuccess ? Color(0xFF3EB575) : Colors.red,
        ),
      ),
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3EB575), Color(0xFF3EB575)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                      MediaQuery.of(context).size.width,
                      105.0,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 70.0,
                  ),
                  child: ChangeNotifierProvider(
                    create: (context) => RegistrationViewModel(),
                    child: Consumer<RegistrationViewModel>(
                      builder: (context, model, child) {
                        return Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  "Create a new account",
                                  style: TextStyle(
                                    color: Color(0xFF3EB575),
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 30.0,
                                      horizontal: 20.0,
                                    ),
                                    width:
                                    MediaQuery.of(context).size.width - 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _usernameController,
                                          onChanged: _updateUsernameValidity,
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            labelStyle: TextStyle(
                                              color: Colors.black38,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            suffixIcon: Icon(
                                              Icons.person,
                                              color: Color(0xFF3EB575),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your username';
                                            } else if (!_isUsernameValid) {
                                              return 'Username must be at least 4 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: _emailController,
                                          onChanged: _updateEmailValidity,
                                          decoration: InputDecoration(
                                            labelText: 'Email',
                                            labelStyle: TextStyle(
                                              color: Colors.black38,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            suffixIcon: Icon(
                                              Icons.email,
                                              color: Color(0xFF3EB575),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your email';
                                            } else if (!_isEmailValid) {
                                              return 'Please enter a valid email address';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: _passwordController,
                                          onChanged: _updatePasswordValidity,
                                          obscureText: !_isPasswordVisible,
                                          decoration: InputDecoration(
                                            labelText: 'Password',
                                            labelStyle: TextStyle(
                                              color: Colors.black38,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isPasswordVisible =
                                                  !_isPasswordVisible;
                                                });
                                              },
                                              child: Icon(
                                                _isPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Color(0xFF3EB575),
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your password';
                                            } else if (!_isPasswordValid) {
                                              return 'Password must be at least 6 characters';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: _confirmPasswordController,
                                          onChanged:
                                          _updateConfirmPasswordValidity,
                                          obscureText: !_isConfirmPasswordVisible,
                                          decoration: InputDecoration(
                                            labelText: 'Confirm Password',
                                            labelStyle: TextStyle(
                                              color: Colors.black38,
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF3EB575),
                                                  width: 2.0),
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isConfirmPasswordVisible =
                                                  !_isConfirmPasswordVisible;
                                                });
                                              },
                                              child: Icon(
                                                _isConfirmPasswordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Color(0xFF3EB575),
                                              ),
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please confirm your password';
                                            } else if (!_isConfirmPasswordValid) {
                                              return 'Passwords do not match';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 30),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  ?.validate() ==
                                                  true) {
                                                LoadingDialog.showLoadingDialog(
                                                    context, "Registering...");

                                                bool success = await model
                                                    .registerUser(
                                                  username:
                                                  _usernameController.text
                                                      .trim(),
                                                  email: _emailController.text
                                                      .trim(),
                                                  password:
                                                  _passwordController.text
                                                      .trim(),
                                                  confirmPassword:
                                                  _confirmPasswordController
                                                      .text
                                                      .trim(),
                                                );

                                                LoadingDialog.hideLoadingDialog(
                                                    context);

                                                if (success) {
                                                  _usernameController.clear();
                                                  _emailController.clear();
                                                  _passwordController.clear();
                                                  _confirmPasswordController.clear();
                                                  _showFlushbar(
                                                      context,
                                                      "Registration successful, please login!",
                                                      true);
                                                  // Registration successful, navigate or perform other actions
                                                } else {
                                                  _showFlushbar(
                                                      context,
                                                      "Registration failed: Invalid email. Please try again!",
                                                      false);
                                                  // Registration failed, handle accordingly
                                                }
                                              }
                                            },
                                            style: OutlinedButton.styleFrom(
                                              backgroundColor:
                                              Color(0xFF3EB575),
                                              side: BorderSide(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Text(
                                              "Register",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigate to the login screen
                                      Navigator.pushReplacementNamed(
                                          context, LoginScreen.routeName);
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Already have an account?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Color(0xFF3EB575),
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

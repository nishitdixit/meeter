import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'services/emailAuthService.dart';
import 'utils/theme_notifier.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/custom_button.dart';

class SignInSignUpFlow extends StatefulWidget {
  static final String path = "lib/src/pages/login/auth3.dart";

  @override
  _SignInSignUpFlowState createState() => _SignInSignUpFlowState();
}

class _SignInSignUpFlowState extends State<SignInSignUpFlow> {
  ThemeProvider? _themeProvider;
  final TextEditingController usernameInputController = TextEditingController();
  final TextEditingController passwordInputController = TextEditingController();
  final TextEditingController confirmPasswordInputController =
      TextEditingController();
  late int _formsIndex;
  bool error = false;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _formsIndex = 1;
  }

  Future _loginUser() async {
    errorMsg = null;
    print(usernameInputController.text);
    print(passwordInputController.text);
    errorMsg = await EmailAuth().signInWithEmailAndPassword(
        email: usernameInputController.text,
        password: passwordInputController.text);

    if (errorMsg != null) {
      setState(() {
        error = true;
      });
      usernameInputController.clear();
      passwordInputController.clear();
      confirmPasswordInputController.clear();
    } else {
      context.pop();
    }
    return;
  }

  Future _signUpUser() async {
    errorMsg = null;

    errorMsg = await EmailAuth().createUserWithEmailAndPassword(
        email: usernameInputController.text,
        password: passwordInputController.text);
    usernameInputController.clear();
    passwordInputController.clear();
    confirmPasswordInputController.clear();
    if (errorMsg != null) {
      setState(() {
        error = true;
      });
    } else {
      context.pop();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Row(children: [
        Flexible(
            child: Image(
          image: AssetImage('assets/meet_pic1.png'),
        )),
        Container(
          width: context.percentWidth * 30,
          child: AnimatedSwitcher(
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            duration: const Duration(seconds: 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            error = false;
                            _formsIndex = 1;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: _formsIndex == 1
                              ? _themeProvider!.themeMode().themeColor
                              : Colors.white,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 15,
                                color: _formsIndex == 1
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            error = false;
                            _formsIndex = 2;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: _formsIndex == 2
                              ? _themeProvider!.themeMode().themeColor
                              : Colors.white,
                          child: Text(
                            "Signup",
                            style: TextStyle(
                                fontSize: 15,
                                color: _formsIndex == 2
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                error == true
                    ? Container(
                        padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 16.0, left: 16.0),
                        color: Colors.red,
                        child: Text(errorMsg!),
                      )
                    : Container(),
                Container(
                  child: _formsIndex == 1
                      ? LoginForm(
                          usernameInputController: usernameInputController,
                          passwordInputController: passwordInputController,
                          onLoginPressed: () {
                            _loginUser();
                          },
                        )
                      : SignupForm(
                          confirmPasswordInputController:
                              confirmPasswordInputController,
                          usernameInputController: usernameInputController,
                          passwordInputController: passwordInputController,
                          onSignUpPressed: () {
                            _signUpUser();
                          },
                        ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

class LoginForm extends StatelessWidget {
  final TextEditingController usernameInputController;
  final TextEditingController passwordInputController;
  final Function() onLoginPressed;
  final _formKey = GlobalKey<FormState>();

  LoginForm({
    Key? key,
    required this.onLoginPressed,
    required this.usernameInputController,
    required this.passwordInputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CustomTextField(
              controller: usernameInputController,
              hintText: "Enter email",
              validator: (value) {
                if (!value!.contains('@') || !value.endsWith('.com')) {
                  return "Email must contain '@' and end with '.com'";
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            CustomTextField(
              controller: passwordInputController,
              obscureText: true,
              hintText: "Enter password",
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            CustomButton(
              text: 'Login',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  onLoginPressed();
                }
              },
              buttonColor: Colors.red,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final TextEditingController usernameInputController;
  final TextEditingController passwordInputController;
  final TextEditingController confirmPasswordInputController;
  final Function() onSignUpPressed;
  SignupForm({
    Key? key,
    required this.onSignUpPressed,
    required this.usernameInputController,
    required this.passwordInputController,
    required this.confirmPasswordInputController,
  }) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String? password;
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CustomTextField(
              controller: usernameInputController,
              hintText: "Enter email",
              validator: (value) {
                if (!value!.contains('@') || !value.endsWith('.com')) {
                  return "Email must contain '@' and end with '.com'";
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            CustomTextField(
              controller: passwordInputController,
              obscureText: true,
              hintText: "Enter password",
              onChanged: (value) {
                password = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 10.0),
            CustomTextField(
              controller: confirmPasswordInputController,
              obscureText: true,
              hintText: "Confirm password",
              validator: (value) {
                return value != password ? 'Password mismatch' : null;
              },
            ),
            const SizedBox(height: 10.0),
            CustomButton(
              text: 'Signup',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  onSignUpPressed();
                }
              },
              buttonColor: Colors.red,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

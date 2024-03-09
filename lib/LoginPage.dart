import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nymble_music/HomePage.dart';
import 'package:nymble_music/LoginEvet.dart';
import 'package:nymble_music/LoginState.dart';
import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => LoginBloc(FirebaseAuth.instance),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
              return;
            } else if (state is LoginSuccess)
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            // Implement navigation on successful login if necessar
          },
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlutterLogo(size: 100),
                    SizedBox(height: 50),
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 50),
                    _buildEmailField(),
                    SizedBox(height: 20),
                    _buildPasswordField(),
                    SizedBox(height: 20),
                    _buildSignInButton(),
                    SizedBox(height: 20),
                    _buildForgotPasswordButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: 'Email',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        hintText: 'Password',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildSignInButton() {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is LoginLoading
              ? null
              : () {
                  BlocProvider.of<LoginBloc>(context).add(
                    Submitted(
                      email: _emailController.text,
                      password: _passwordController.text,
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: state is LoginLoading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('Sign In'),
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // Handle "Forgot password" action
      },
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.blueGrey),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

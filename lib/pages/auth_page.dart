import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../widgets/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;

  Future<void> _submitAuthForm(
    String email,
    String username,
    String password,
    File? image,
    bool isLoginMode,
    BuildContext ctx,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLoginMode) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await ref.putFile(image!).then((p0) {});
        final url = await ref.getDownloadURL();

        return FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': email,
          'username': username,
          'createdAt': Timestamp.now(),
          'imageUrl': url,
        });
      }
    } on PlatformException catch (err) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(err.message!),
      ));
    } on Exception catch (err) {
      var e = err.toString();

      var error = e.contains("email")
          ? "Something went wrong with this email!"
          : e.contains("password")
              ? "Something went wrong with email or password"
              : e.contains("user-not-found")
                  ? "User not found!"
                  : e.contains("network")
                      ? "Network connection failed!"
                      : "Found a system error on your device!";

      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(error),
        ),
      );
      setState(() {
        _isLoading = false;
      });

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Flutter Chat App'),
      ),
      body: AuthForm(
        inputDataFn: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}

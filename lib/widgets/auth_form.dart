import 'dart:io';
import 'package:flutter/material.dart';
import '../widgets/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(
    String email,
    String username,
    String password,
    File? image,
    bool isLoginMode,
    BuildContext ctx,
  ) inputDataFn;
  const AuthForm(
      {super.key, required this.inputDataFn, required this.isLoading});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _isLoginMode = true;
  var _email = '';
  var _username = '';
  var _password = '';
  final _formKey = GlobalKey<FormState>();
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmitForm() {
    final isFormValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLoginMode) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add an image'),
        ),
      );
      return;
    }

    if (isFormValid) {
      _formKey.currentState!.save();
      widget.inputDataFn(
        _email,
        _username,
        _password,
        _userImageFile,
        _isLoginMode,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (!_isLoginMode)
                      UserImagePicker(imagePickFn: _pickedImage),
                    TextFormField(
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      key: const ValueKey('email'),
                      decoration:
                          const InputDecoration(labelText: 'Email address'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !value.contains('@') ||
                            !value.contains('.') ||
                            value.length < 5) {
                          return 'Please enter an email address';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _email = newValue!;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    if (!_isLoginMode)
                      TextFormField(
                        key: const ValueKey('username'),
                        autocorrect: true,
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 5) {
                            return 'Username should be at least 5 chars long';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _username = newValue!;
                        },
                      ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      key: const ValueKey('password'),
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.length < 8 ||
                            value.length > 32) {
                          return 'Enter min 8 chars long password';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _password = newValue!;
                      },
                    ),
                    const SizedBox(height: 10.0),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                              });
                            },
                            child: Text(_isLoginMode
                                ? 'Create a new account'
                                : 'I have an account'),
                          ),
                          ElevatedButton(
                            onPressed: _trySubmitForm,
                            child: Text(_isLoginMode ? 'Login' : 'Signup'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

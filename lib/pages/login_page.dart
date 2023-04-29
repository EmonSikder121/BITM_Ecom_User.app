import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user_pb_bitm/pages/launcher_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import '../auth/authservice.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import '../providers/notification_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _errMsg = '';
  late UserProvider userProvider;

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  controller: _passwordController,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password(at least 6 characters)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid password';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _authenticate(true);
                },
                child: const Text('Login'),
              ),
              Row(
                children: [
                  const Text('New User?'),
                  TextButton(
                    onPressed: () {
                      _authenticate(false);
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Forgot password',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () {

                    },
                    child: const Text('Click Here'),
                  ),
                ],
              ),
              const Center(child: Text('OR', style: TextStyle(fontSize: 20),),),
              TextButton.icon(
                icon: const Icon(
                  Icons.g_mobiledata,
                  size: 30,
                ),
                onPressed: _signInWithGoogle,
                label: const Text('Sign In with Google'),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errMsg,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate(bool tag) async {
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      final email = _emailController.text;
      final password = _passwordController.text;
      UserCredential userCredential;
      try {
        if(tag) {
          userCredential = await AuthService.login(email, password);
        } else {
          userCredential = await AuthService.register(email, password);
        }

        if(!tag) {
          final userModel = UserModel(
            userId: userCredential.user!.uid,
            email: userCredential.user!.email!,
            userCreationTime: Timestamp.fromDate(userCredential.user!.metadata.creationTime!),
          );
          await userProvider.addUser(userModel);
        }
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, LauncherPage.routeName);

      } on FirebaseAuthException catch (error) {
        EasyLoading.dismiss();
        setState(() {
          _errMsg = error.message!;
        });
      }
    }
  }

  void _signInWithGoogle() async {

  }

  void _loginAsGuest() {

  }

}

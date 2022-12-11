import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Such e-mail is not found'),
          backgroundColor: Colors.red,
        ));
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ));
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Check your e-mail'),
      backgroundColor: Colors.green,
    ));
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        centerTitle: true,
      ),
      body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter an email to reset your password'),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.email)),
                  validator: ((email) {
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email!);
                    if (email.isEmpty) return 'Input E-mail address';
                    if (emailValid == false) {
                      return 'E-mail is not valid';
                    }
                    return null;
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                OutlinedButton.icon(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await resetPassword();
                      }
                    },
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Reset password'))
              ],
            ),
          )),
    ));
  }
}

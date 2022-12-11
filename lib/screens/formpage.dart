import 'package:flutter/material.dart';
import 'package:week_18/helper/helper.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  var _agreement = false;
  // String name = '';
  // String surname = '';
  String email = '';
  String password = '';
  // String phoneNumber = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Registration'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 270,
                        height: 60,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'E-mail address*',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onChanged: (email) => setState(() {
                            this.email = email;
                          }),
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 270,
                        height: 60,
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Password*',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          obscureText: true,
                          onChanged: (password) => setState(() {
                            this.password = password;
                          }),
                          validator: ((password) {
                            if (password!.isEmpty) return 'Input password';
                            return null;
                          }),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: _agreement,
                              onChanged: (bool? value) =>
                                  setState(() => _agreement = value!)),
                          const Text('I accept all terms and conditions')
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              Color color = Colors.red;
                              String text;
                              if (_agreement) {
                                text = 'Regisration successful';
                                color = Colors.green;
                                final success = await FirebaseHelper.signUp(
                                    email, password);
                                if (success) {
                                  Navigator.of(context).pop();
                                }
                              } else {
                                text =
                                    'It is necessary to accept the terms of the agreement';
                                color = Colors.red;
                              }

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(text),
                                backgroundColor: color,
                              ));
                            }
                          },
                          child: const Text('Sign in'))
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

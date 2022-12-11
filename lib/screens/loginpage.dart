import 'package:flutter/material.dart';
import 'package:week_18/helper/helper.dart';
import 'package:week_18/screens/forgotpassword_page.dart';
import 'package:week_18/screens/userpage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
// объявляем переменные
  var remember = true;
  // String name = '';
  // String surname = '';
  // String email = '';
  // String password = '';
  // String phoneNumber = '';
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

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
        title: const Text('Вход в систему'),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controllerEmail,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.email)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controllerPassword,
              decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.password)),
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () async {
                  final email = controllerEmail.text;
                  final password = controllerPassword.text;
                  final success = await FirebaseHelper.login(email, password);
                  if (success) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => UserPage()),
                        (route) => false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Login and password are wrong'),
                      backgroundColor: Colors.red,
                    ));
                  }
                  // changeLaunch(remember);
                },
                icon: const Icon(Icons.login),
                label: const Text('Login')),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ForgotPasswordPage()));
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
                //  переходим на страницу регистрации
                onPressed: () => Navigator.pushNamed(context, '/formpage'),
                child: const Text('Register'))
          ],
        ),
      ),
    ));
  }
}

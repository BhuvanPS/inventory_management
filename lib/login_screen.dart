import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management/homeScreen.dart';
import 'package:inventory_management/providers/auth_provider.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticationError:
        Fluttertoast.showToast(msg:"Failed");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg:"Cancelled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg:"Success");
        break;
      default:
        break;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          TextButton(
              onPressed: () async {
                bool isSuccess = await authProvider.handleSignIn();
                if (isSuccess) {
                  context.pushReplacement('/homeScreen');
                }
              },
              child: const Center(child: Text('SignIn'))),
          Positioned(
              child: authProvider.status == Status.authenticating
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox.shrink())
        ],
      ),
    );
  }
}

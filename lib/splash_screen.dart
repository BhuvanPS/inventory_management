import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management/homeScreen.dart';
import 'package:inventory_management/login_screen.dart';
import 'package:inventory_management/providers/auth_provider.dart';
import 'package:provider/provider.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState(){
    super.initState();


    if (!kIsWeb) checkSignedIn();

  }
  void checkSignedIn()async {
    print('innnn');
    AuthProvider authProvider = context.read<AuthProvider>();
    print('hiii');
    bool isLoggedIn = await authProvider.isLoggedIn();
    if(isLoggedIn){
      print('success');
      context.pushReplacement('/homeScreen');



    }else{
      context.pushReplacement('/loginScreen');
    }

  }
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Padding(
      padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/3),
      child: Column(
        children: [
          Center(
            child: GestureDetector(onTap:(){
              kIsWeb?context.pushReplacement('/homeScreen'):null;
            },
                child: Center(child: Text(kIsWeb?'Continue':'Loading'))),
          ),
        ],
      ),
    )),);
  }
}
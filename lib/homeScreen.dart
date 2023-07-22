import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management/Client.dart';
import 'package:inventory_management/ClientScreen.dart';
import 'package:inventory_management/login_screen.dart';
import 'package:inventory_management/providers/auth_provider.dart';
import 'package:inventory_management/user_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthProvider authProvider;
  String name = 'Sharath Agencies';

  void initState() {
    authProvider = context.read<AuthProvider>();
    defaultTargetPlatform==TargetPlatform.android?getInfo():null;
  }

  void getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      //name = prefs.getString('companyName')!;
    });
    //print('name'+'.........'+name);
  }

  Future<void> handleSignOut() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sure to Exit?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () {
                authProvider.handleSignOut();
                Navigator.pop(context, true);


               context.pushReplacement('/loginScreen');
              },
              child: const Text(
                'Yes',
                style: TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'No',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !kIsWeb?AppBar(title: Text(name), actions: [
        IconButton(
          onPressed: handleSignOut,
          icon: Icon(Icons.logout),
        ),
      ]):null,
      body: GridView(
        padding: EdgeInsets.all(8),
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        children: [
          GestureDetector(
            onTap: () {
              Client.getClients();
            },
            child: Container(
              //padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pinkAccent.withOpacity(0.7),
                    Colors.purpleAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              //padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books),
                    Text('View Proforma'),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book),
                  Text('View Tax Invoices'),
                ],
              ),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.lightBlue.withOpacity(0.7),
                    Colors.greenAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {},
            child: Container(
              //padding: const EdgeInsets.all(30),

              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.7),
                    Colors.blue,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              //padding: const EdgeInsets.all(30),

              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    Text('Add Proforma'),
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
             context.push('/clientScreen');
            },
            child: Container(

              decoration: BoxDecoration(

                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.7),
                    Colors.amber,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.group),
                  Text('View Clients'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              //padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.7),
                    Colors.greenAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.list_alt_outlined),
                  Text('View Products'),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              //padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                // image: DecorationImage(image: NetworkImage(bgurl)),
                gradient: LinearGradient(
                  colors: [
                    Colors.limeAccent.withOpacity(0.7),
                    Colors.greenAccent,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              //padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.fire_truck),
                  Text('View Eway Bills'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

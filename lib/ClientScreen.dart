import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:inventory_management/Client.dart';
import 'package:inventory_management/addClient.dart';
class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  @override
  bool isLoading = false;

  void initState() {
    getClients();
  }

  void getClients() async {
    if (Client.clientsList.isEmpty) {
      setState(() {
        isLoading = true;
      });
      await Client.getClients();
      setState(() {
        isLoading = false;
      });
    }
  }
  double getSize(){
    if(kIsWeb&&defaultTargetPlatform == TargetPlatform.android){

      return MediaQuery.of(context).size.width;}
    if(kIsWeb&&defaultTargetPlatform != TargetPlatform.android){

      return MediaQuery.of(context).size.width*0.45;}
    else {

      return MediaQuery.of(context).size.width;
    }

  }  @override
  Widget build(BuildContext context) {
    print('building......');
    return RefreshIndicator(
      onRefresh: () async {
        Client.clientsList.clear();
        if (Client.clientsList.isEmpty) {
          setState(() {
            isLoading = true;
          });
          await Client.getClients();
        }
        print('hi');

        setState(() {
          isLoading = false;
        });
      },
      child: Scaffold(
        appBar: !kIsWeb?AppBar(title: Text('Clients'), ):null,
        body: !isLoading
            ? Padding(

              padding:  kIsWeb?EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4):EdgeInsets.zero,
              child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(

                  width: getSize(),
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Text(Client.clientsList[index].name),
                      Text(Client.clientsList[index].gstn),
                    ],
                  ),
                );
              },
              itemCount: Client.clientsList.length),
            )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: SpinKitDualRing(
                  color: Colors.black,
                  size: 50.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 35.0),
                child: Text('Please hold on....We are fetching your data'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            context.push('/addClient');
          },
        ),
      ),
    );
  }
}

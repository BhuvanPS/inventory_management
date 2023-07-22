import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  String docId;
  String name;
  Map address;
  String gstn;

  Client(
      {required this.name,
      required this.gstn,
      required this.address,
      required this.docId});

  static List<Client> clientsList = [];
  static getClients() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('clients')
        .where('belongsTo', isEqualTo: 'funa7o2KBAQzebdIOClc08iw5Lj2')
        .get();

    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      clientsList.add(Client(
          name: data['name'],
          gstn: data['gstn'],
          address: data['Address'],
          docId: data['docId']));
    }
  }
}

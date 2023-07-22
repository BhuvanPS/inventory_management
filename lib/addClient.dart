
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_management/Client.dart';
class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {



  TextEditingController nameController = TextEditingController();
  TextEditingController gstnController = TextEditingController();
  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<void> uploadData(

      ) async {

    await FirebaseFirestore.instance.collection("clients").add({
      'name': nameController.text.toUpperCase(),
      'gstn': gstnController.text.toUpperCase(),
      'Address': {
        'Line1': line1Controller.text,
        'Line2': line2Controller.text,
        'pincode': pincodeController.text,
      },
      'belongsTo':'funa7o2KBAQzebdIOClc08iw5Lj2'
    }).then((value) {
      FirebaseFirestore.instance
          .collection('clients')
          .doc(value.id)
          .update({'docId': value.id});

      Client.clientsList.add(Client(name: nameController.text.toUpperCase(), gstn: gstnController.text.toUpperCase(), address: {
        'Line1': line1Controller.text,
        'Line2': line2Controller.text,
        'pincode': pincodeController.text,
      }, docId: value.id));
    });
    print('success');
  }

  void _submit()async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      FocusManager.instance.primaryFocus?.unfocus();
      return;
    } else {
      _formKey.currentState!.save();
      FocusManager.instance.primaryFocus?.unfocus();
      await uploadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added')),
      );


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

  }
  @override
  Widget build(BuildContext context) {
    print('addscreen');
    return Scaffold(
      appBar: !kIsWeb?AppBar(title: const Text('Add Client'), ):null,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const SizedBox(
              height: 10,
            ),
            const Center(
              child:  Text(
                "Enter Customer Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(

              width: getSize(),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 15,
                        cursorColor: Colors.green,
                        controller: gstnController,
                        decoration: InputDecoration(
                          labelText: 'GST Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(),
                          ),
                        ),


                        validator: (value) {
                          RegExp regex = RegExp(
                              r'^[0-9]{2}[A-Za-z]{5}[0-9]{4}[A-Za-z]{1}[1-9A-Za-z]{1}Z[0-9A-Za-z]{1}$');
                          if (value!.length < 15 || !regex.hasMatch(value!)) {
                            return 'Incorrect';
                          }
                          return null;
                        },

                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(),
                          ),
                        ),

                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return 'Enter Text';
                          }
                          return null;
                        },

                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Color(0x7Aeab676),
                        ),


                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(

                            children: [
                              const Text(
                                ' Enter Address',
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              TextFormField(

                                textCapitalization: TextCapitalization.characters,
                                controller: line1Controller,
                                maxLength: 40,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Line 1',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Text';
                                  }
                                  return null;
                                },

                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(

                                textCapitalization: TextCapitalization.characters,
                                controller: line2Controller,
                                maxLength: 40,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Line 2',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty || value == null) {
                                    return 'Enter Text';
                                  }
                                  return null;
                                },

                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(

                                maxLength: 6,

                                keyboardType: TextInputType.number,
                                controller: pincodeController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Pincode',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(),
                                  ),
                                ),
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Enter Text';
                                  }if(value.length<6){
                                    return 'Invalid';
                                  }
                                  return null;
                                },

                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () => _submit(),
                          child: Text('Add'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

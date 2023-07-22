import 'package:flutter/foundation.dart';

class Products with ChangeNotifier{

}

class Product{
  String description;
  double hsn;
  double rate;
  double gstr;
  Product({required this.description,required this.hsn,required this.rate,required this.gstr});

}
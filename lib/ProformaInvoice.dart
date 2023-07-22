import 'package:inventory_management/Client.dart';
import 'package:inventory_management/providers/product_provider.dart';

class ProformaInvoice {
  int invNo;
  DateTime invDate;
  DateTime dueDate;
  Client party;
  Product item;
  double rate;
  double quantity;

  ProformaInvoice(
      {required this.invNo,
      required this.invDate,
      required this.dueDate,
      required this.party,
      required this.item,
      required this.rate,
      required this.quantity});
}

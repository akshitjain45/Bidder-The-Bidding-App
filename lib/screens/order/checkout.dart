import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/razorpayServices.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/keyboard.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Checkout extends StatefulWidget {
  final num amount;
  final Product product;
  Checkout({required this.amount, required this.product});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  bool addressChanged = false;
  TextEditingController addressTextEditingController = TextEditingController();
  bool phoneChanged = false;
  TextEditingController phoneTextEditingController = TextEditingController();
  RazorpayService razorpayService = RazorpayService();

  @override
  void initState() {
    super.initState();
    addressTextEditingController.text = context.read<AppUser>().address ?? "";
    phoneTextEditingController.text = context.read<AppUser>().phoneNo ?? "";
    razorpayService.init(context.read<AppUser>().id ?? "");
  }

  @override
  void dispose() {
    super.dispose();
    razorpayService.clear();
  }

  Widget billItem(String item, String amount) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item,
            style: const TextStyle(fontSize: 11),
          ),
          Text(
            amount,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Checkout")),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const Text(
              "Product",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 1,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                leading: Container(
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: widget.product.id.toString(),
                    child: Image.network(widget.product.images[0]),
                  ),
                ),
                title: Text(
                  widget.product.title,
                  style: TextStyle(color: Colors.black),
                  maxLines: 2,
                ),
                subtitle: Text(
                  widget.product.description,
                  style: TextStyle(
                    fontSize: getProportionateScreenWidth(18),
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Delivery Address",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 3,
              onChanged: (value) {
                setState(() {
                  addressChanged = true;
                });
              },
              validator: (val) => val!.isEmpty
                  ? 'Please enter your delivery address with  PIN code'
                  : null,
              controller: addressTextEditingController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                hintText: "Enter your address here",
                hintStyle: TextStyle(color: kPrimaryColor, fontSize: 15),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(153, 60, 60, 67),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(153, 60, 60, 67),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Contact Number",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 1,
              onChanged: (value) {
                setState(() {
                  phoneChanged = true;
                });
              },
              keyboardType: TextInputType.number,
              validator: (val) =>
                  val!.isEmpty ? 'Please enter your Phone Number' : null,
              controller: phoneTextEditingController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                hintText: "Enter your phone number here",
                hintStyle: TextStyle(color: kPrimaryColor, fontSize: 15),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(153, 60, 60, 67),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(153, 60, 60, 67),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Amount to be paid",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.amount.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ButtonTheme(
              minWidth: MediaQuery.of(context).size.width,
              height: 42,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => kPrimaryColor),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus(); //hides keyboard
                  if (addressChanged || phoneChanged)
                    UserDBServices()
                        .updateData(context.read<AppUser>().id!, data: {
                      "address": addressTextEditingController.text,
                      "phoneNo": phoneTextEditingController.text
                    });
                  razorpayService.openCheckout(
                      widget.amount,
                      widget.product,
                      context,
                      context.read<AppUser>().phoneNo,
                      context.read<AppUser>().email);
                },
                child: const Text('PAY NOW',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Title',
                        fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

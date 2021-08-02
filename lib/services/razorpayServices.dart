import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  late Razorpay _razorPay;
  late num _amount;
  late Product _product;
  late String _uId;
  late BuildContext _prevContext;
  String? _phoneNumber;
  String? _email;

  void init(String uId) {
    _razorPay = Razorpay();

    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handleErrorFailure);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    _uId = uId;
  }

  void clear() {
    _razorPay.clear();
  }

  void openCheckout(
    num amount,
    Product product,
    BuildContext prevContext,
    String? phoneNumber,
    String? email,
  ) {
    _amount = amount;
    _product = product;
    _prevContext = prevContext;
    _phoneNumber = phoneNumber ?? "";
    _email = email ?? "";
    final options = {
      'key': 'rzp_test_',
      'amount': _amount * 100,
      'name': 'Bidder',
      'description': 'Payment for ${_product.title}',
      'prefill': {'contact': _phoneNumber, 'email': _email},
      'external': {
        'wallets': ["paytm"]
      }
    };
    try {
      _razorPay.open(options);
    } catch (e) {
      // print(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //     msg: "Success${response.paymentId}", textColor: Colors.blue);
    handleSuccessUtil(response.paymentId!);
  }

  void handleErrorFailure(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "Error${response.code}  -  ${response.message}");
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(msg: "External wallet${response.walletName}");
  }

  Future handleSuccessUtil(String paymentId) async {
    await OrderDBServices(uid: _uId)
        .makeOrder(product: _product, price: _amount);
    popupgify();
  }

  void popupgify() {
    showDialog(
        context: _prevContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment successful!',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            content: Text("$_amount has been paid for your order."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(_prevContext).pop();
                  Navigator.of(_prevContext).pop();
                },
                child: const Text('Dismiss'),
              ),
            ],
          );
        });
  }
}

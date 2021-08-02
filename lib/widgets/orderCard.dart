import 'package:bidding_app/models/order.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () => Navigator.pushNamed(
          context,
          Routes.orderDetails,
          arguments: order.id!,
        ),
        leading: Container(
          decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Hero(
            tag: order.id.toString(),
            child: Image.network(order.images[0]),
          ),
        ),
        title: Text(
          order.title,
          style: TextStyle(color: Colors.black),
          maxLines: 2,
        ),
        subtitle: Text(
          "₹${order.price}",
          style: TextStyle(
            fontSize: getProportionateScreenWidth(18),
            fontWeight: FontWeight.w600,
            color: kPrimaryColor,
          ),
        ),
      ),
    );
  }
}

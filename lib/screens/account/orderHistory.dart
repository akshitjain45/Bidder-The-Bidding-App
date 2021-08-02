import 'package:bidding_app/models/order.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/orderDbService.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:bidding_app/widgets/orderCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StrmBldr<List<Order>>(
                stream: OrderDBServices(uid: context.watch<AppUser>().id)
                    .fetchMyOrders(),
                noDataWidget:
                    Center(child: Text("You haven't ordered anything yet")),
                builder: (context, value) {
                  return ListView(
                    children:
                        value?.map((e) => OrderCard(order: e)).toList() ?? [],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

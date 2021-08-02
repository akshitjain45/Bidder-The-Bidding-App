import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:bidding_app/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Products"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StrmBldr<List<Product>>(
                stream: ProductDBServices(uid: context.watch<AppUser>().id)
                    .fetchMyProducts(),
                noDataWidget: Center(
                    child: Text("You have not put up any Products for sale")),
                builder: (context, value) {
                  return GridView.count(
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 6.0,
                    crossAxisCount: 2,
                    children:
                        value!.map((e) => ProductCard(product: e)).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimaryColor,
        ),
        child: IconButton(
          padding: EdgeInsets.all(10),
          iconSize: 30,
          color: Colors.white,
          icon: Icon(
            Icons.add,
          ),
          onPressed: () => Navigator.pushNamed(context, Routes.newProduct),
        ),
      ),
    );
  }
}

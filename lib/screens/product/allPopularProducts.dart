import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:bidding_app/widgets/productCard.dart';
import 'package:flutter/material.dart';

class AllPopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Products"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StrmBldr<List<Product>>(
                stream: ProductDBServices().fetchAllProducts(),
                noDataWidget: Center(child: Text("No Popular Products")),
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
    );
  }
}

import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:bidding_app/widgets/productCard.dart';
import 'package:flutter/material.dart';

class PopularProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Popular Products",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, Routes.popularProducts),
                child: Text(
                  "See More",
                  style: TextStyle(color: Color(0xFFBBBBBB)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        StrmBldr<List<Product>>(
          stream: ProductDBServices().fetchAllProducts(),
          noDataWidget: Center(child: Text("No Popular Products")),
          builder: (context, value) {
            return SizedBox(
              height: 170,
              child: value != null
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: value.length > 4 ? 4 : value.length,
                      itemBuilder: (context, index) =>
                          ProductCard(product: value[index]),
                    )
                  : Center(child: Text("No Popular Products")),
            );
          },
        ),
      ],
    );
  }
}

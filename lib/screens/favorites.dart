import 'package:bidding_app/models/product.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/productDbService.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:bidding_app/widgets/commonUI/coustom_bottom_nav_bar.dart';
import 'package:bidding_app/widgets/productCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: StrmBldr<List<Product>>(
                stream: ProductDBServices(uid: context.watch<AppUser>().id)
                    .fetchFavoriteProducts(),
                noDataWidget: Center(child: Text("No Favorite Products")),
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
      bottomNavigationBar: CustomBottomNavBar(index: 1),
    );
  }
}

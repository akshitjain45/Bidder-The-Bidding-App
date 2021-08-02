import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:flutter/material.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Help Center"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text("Contact Us"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.pushNamed(context, Routes.contactUs),
            ),
            ListTile(
              title: Text("About Us"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.pushNamed(context, Routes.aboutUs),
            ),
            ListTile(
              title: Text("FAQs"),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.pushNamed(context, Routes.faqs),
            ),
          ],
        ),
      ),
    );
  }
}

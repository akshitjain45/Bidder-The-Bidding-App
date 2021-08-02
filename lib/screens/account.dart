import 'package:bidding_app/main.dart';
import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/widgets/commonUI/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  signOutPopUp() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Are you sure you want to Logout?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            TextButton(
              onPressed: () {
                _signOut();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future _signOut() async {
    await authService.signOut();
    StreamedApp.rebirth(context);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox.expand(
                  child: Provider.of<AppUser>(context).photoUrl != null
                      ? SvgPicture.network(
                          Provider.of<AppUser>(context).photoUrl!,
                        )
                      : Icon(Icons.account_circle_outlined),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              Provider.of<AppUser>(context).displayName ?? "",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            AccountMenu(
              text: "My Profile",
              icon: Icons.person_outline_rounded,
              press: () => Navigator.pushNamed(context, Routes.viewProfile),
            ),
            AccountMenu(
              text: "My Products",
              icon: Icons.shopping_bag_outlined,
              press: () => Navigator.pushNamed(context, Routes.myProducts),
            ),
            AccountMenu(
              text: "Order History",
              icon: Icons.history,
              press: () => Navigator.pushNamed(context, Routes.orderHistory),
            ),
            AccountMenu(
              text: "Notifications",
              icon: Icons.notifications_none_rounded,
              press: () {},
            ),
            AccountMenu(
              text: "Settings",
              icon: Icons.settings_outlined,
              press: () {},
            ),
            AccountMenu(
              text: "Help Center",
              icon: Icons.help_outline,
              press: () => Navigator.pushNamed(context, Routes.helpCenter),
            ),
            AccountMenu(
              text: "Log Out",
              icon: Icons.logout,
              press: signOutPopUp,
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(index: 2),
    );
  }
}

class AccountMenu extends StatelessWidget {
  const AccountMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        tileColor: Color(0xFFF5F6F9),
        onTap: press,
        leading: Icon(
          icon,
          color: kPrimaryColor,
          size: 22,
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        title: Text(text),
      ),
    );
  }
}

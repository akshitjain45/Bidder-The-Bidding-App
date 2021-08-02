import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:bidding_app/widgets/detailRow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  final ScrollController _controller = ScrollController();

  String? photoUrl;
  Map<String, String>? userDetails;

  bool isScrolledToTop = true;
  void _scrollListener() {
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      if (!isScrolledToTop) {
        setState(() {
          isScrolledToTop = true;
        });
      }
    } else {
      if (_controller.offset > 32 && isScrolledToTop) {
        setState(() {
          isScrolledToTop = false;
        });
      }
    }
  }

  void initialize(AppUser user) {
    setState(() {
      photoUrl = user.photoUrl;
      userDetails = {
        'Display Name': user.displayName ?? '',
        'Gender': user.gender ?? '',
        'Date of Birth':
            (user.dob != null) ? dateFormatter.format(user.dob!) : '',
        'Email': user.email ?? '',
        'Phone Number': user.phoneNo ?? '',
        'Address': user.address ?? '',
      };
    });
  }

  @override
  void initState() {
    AppUser user = context.read<AppUser>();
    initialize(user);
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Your Profile",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: IconButton(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
                onPressed: () async {
                  dynamic isUpdated =
                      await Navigator.pushNamed(context, Routes.editProfile);
                  if (isUpdated != null) {
                    AppUser user = context.read<AppUser>();
                    initialize(user);
                  }
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox.expand(
                        child: photoUrl != null
                            ? SvgPicture.network(photoUrl!)
                            : Icon(Icons.account_circle_rounded),
                      ),
                    ),
                  ),
                ),
              ] +
              [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FB),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  child: Column(
                    children: userDetails!.entries.map((entry) {
                      return DetailRow(
                        detailName: entry.key,
                        detailContent: entry.value,
                      );
                    }).toList(),
                  ),
                ),
              ],
        ),
      ),
    );
  }
}

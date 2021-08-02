import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:bidding_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const _ktextFieldStyle = TextStyle(fontSize: 14);

class EditUserProfile extends StatefulWidget {
  @override
  _EditUserProfileState createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
  DateTime? dateOfBirth;
  String? gender;
  TextEditingController? displayNameController;
  TextEditingController? emailController;
  TextEditingController? phoneNoController;
  TextEditingController? addressController;
  TextEditingController? pincodeController;

  void initialize(AppUser user) {
    displayNameController = TextEditingController(text: user.displayName);
    emailController = TextEditingController(text: user.email);
    phoneNoController = TextEditingController(text: user.phoneNo ?? '');
    dateOfBirth = user.dob;
    gender = (user.gender == '') ? null : user.gender;
    List<String>? splitAddress = user.address?.split(" PIN: ");
    if (splitAddress != null && splitAddress.length > 1) {
      addressController = TextEditingController(text: splitAddress[0]);
      pincodeController = TextEditingController(text: splitAddress[1]);
    } else {
      addressController = TextEditingController(text: '');
      pincodeController = TextEditingController(text: '');
    }
  }

  @override
  void initState() {
    AppUser user = context.read<AppUser>();
    initialize(user);
    super.initState();
  }

  //SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
  updateuserinfo() async {
    String uid = context.read<AppUser>().id!;
    try {
      await UserDBServices().updateData(uid, data: <String, dynamic>{
        "email": emailController!.text,
        "displayName": displayNameController!.text,
        "phoneNo": phoneNoController!.text,
        "address":
            (addressController!.text) + (' PIN: ' + pincodeController!.text),
        "gender": gender,
        "dob": dateOfBirth,
      });
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Your Profile"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListView(
            children: <Widget>[
              EditDetail(
                icon: Icons.person,
                detailname: 'Name',
                child: TextFormField(
                  style: _ktextFieldStyle,
                  keyboardType: TextInputType.text,
                  controller: displayNameController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Display Name cannot be empty';
                    }
                  },
                  decoration:
                      _myInputDecoration(hintText: 'Enter display name'),
                ),
              ),
              EditDetail(
                icon: FontAwesomeIcons.mars,
                detailname: 'Gender',
                child: DropdownButton<String>(
                  hint: Text(
                    'Choose a gender',
                    style: _ktextFieldStyle,
                  ),
                  isDense: false,
                  items: [
                    'Male',
                    'Female',
                    'Non-Binary',
                    'Other',
                    'Prefer not to say',
                  ]
                      .map((e) => DropdownMenuItem<String>(
                            child: Text(
                              '$e',
                              textScaleFactor: 0.9,
                            ),
                            value: '$e',
                          ))
                      .toList(),
                  value: gender,
                  onChanged: (v) {
                    setState(() {
                      gender = v;
                    });
                  },
                ),
              ),
              EditDetail(
                detailname: 'DOB',
                icon: Icons.calendar_today,
                child: GestureDetector(
                  onTap: () async {
                    final temp = await showDatePicker(
                      context: context,
                      initialDate: dateOfBirth ??
                          DateTime.now().subtract(Duration(days: 365 * 11)),
                      firstDate: DateTime(1950),
                      lastDate:
                          DateTime.now().subtract(Duration(days: 365 * 10)),
                    );
                    if (temp == null) {
                      return;
                    }
                    setState(() {
                      dateOfBirth = temp;
                    });
                  },
                  child: Text(
                    '${dateOfBirth != null ? dateFormatter.format(dateOfBirth!) : 'Enter your birthday!'}',
                    style: _ktextFieldStyle,
                  ),
                ),
              ),
              EditDetail(
                icon: Icons.mail,
                detailname: 'Email',
                child: TextFormField(
                  enabled: false,
                  style: _ktextFieldStyle,
                  keyboardType: TextInputType.text,
                  controller: emailController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Email cannot be empty';
                    }
                  },
                  decoration: _myInputDecoration(hintText: 'Enter email'),
                ),
              ),
              EditDetail(
                detailname: 'Phone No',
                icon: Icons.phone,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: phoneNoController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Phone no cannot be empty';
                    } else if (value.length > 13 || value.length < 10) {
                      return 'Enter valid mobile number';
                    }
                  },
                  style: _ktextFieldStyle,
                  decoration:
                      _myInputDecoration(hintText: 'Enter Phone Number'),
                ),
              ),
              EditDetail(
                icon: Icons.home,
                detailname: 'Address',
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      controller: addressController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Address cannot be empty';
                        }
                        if (value.length > 70) {
                          return 'max characters 100';
                        }
                      },
                      minLines: 1,
                      maxLines: 2,
                      style: _ktextFieldStyle,
                      decoration:
                          _myInputDecoration(hintText: 'Enter your address'),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: pincodeController,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Pincode cannot be empty';
                        }
                        if (value.length > 10) {
                          return 'max characters 10';
                        }
                        if (value.length < 6) {
                          return 'Invalid pincode';
                        }
                      },
                      minLines: 1,
                      maxLines: 1,
                      style: _ktextFieldStyle,
                      decoration: _myInputDecoration(hintText: 'Pincode'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: TextButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.resolveWith(
                        (states) => Size.fromHeight(40)),
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => kPrimaryColor),
                  ),
                  child: Text('Save Changes',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    print("pressed");
                    if (_formKey.currentState!.validate()) {
                      updateuserinfo();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditDetail extends StatelessWidget {
  final IconData? icon;
  final String? detailname;
  final Widget? child;
  EditDetail({this.child, this.detailname, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ListTile(
        // horizontalTitleGap: 0,
        shape: RoundedRectangleBorder(),
        tileColor: Color(0xFFF2F7FB),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        // horizontalTitleGap: 0,
        leading: Icon(icon),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$detailname:',
                style: TextStyle(fontSize: 11),
              ),
            ),
            Expanded(
              flex: 5,
              child: child!,
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration _myInputDecoration({String? hintText}) {
  return InputDecoration(
    errorMaxLines: 2,
    errorBorder: UnderlineInputBorder(),
    focusedErrorBorder: UnderlineInputBorder(),
    hintText: hintText,
    border: InputBorder.none,
  );
}

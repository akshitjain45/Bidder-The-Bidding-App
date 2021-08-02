import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Color(0xFF4A3298),
        title: Text('Contact Us',
            style: TextStyle(fontSize: 19, color: Colors.white)),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/icon.png'),
                  radius: 40.0,
                ),
              ),
              Center(
                child: Text(
                  "Bidder Inc.",
                  style: TextStyle(
                    fontSize: 26.0,
                    color: Colors.blueGrey[800],
                  ),
                ),
              ),
              Divider(
                height: 60.0,
                color: Colors.grey,
              ),
              Text('Email ID:',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                  )),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.email,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  InkWell(
                      child: new Text(
                        'bidder@gmail.com',
                        style: TextStyle(
                          color: Colors.indigo[800],
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () => launch('mailto: bidder@gmail.com'))
                ],
              ),
              SizedBox(height: 30.0),
              Text('Phone Number:',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                  )),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.phone,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  InkWell(
                      child: new Text(
                        '9987237549',
                        style: TextStyle(
                          color: Colors.indigo[800],
                          fontSize: 18.0,
                        ),
                      ),
                      onTap: () => launch('tel: 9987237549'))
                ],
              ),
              SizedBox(height: 30.0),
              Text('Address:',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                  )),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.room,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    '221-B Baker Street, London',
                    style: TextStyle(
                      color: Colors.indigo[800],
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Color(0xFF4A3298),
        title: Text('About Us',
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
              SizedBox(height: 10.0),
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
              Text('Artists and Programmers:',
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                    letterSpacing: 2.0,
                    fontSize: 16.0,
                  )),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Akshit Jain',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Bhavya Tewari',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Bhavya Verma',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Gaurav Dubey',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Colors.blueGrey[700],
                  ),
                  SizedBox(width: 15.0),
                  Text(
                    'Yashu Garg',
                    style: TextStyle(
                      color: Colors.blueGrey[900],
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

import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  @override
  _FAQsState createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop()),
          backgroundColor: Color(0xFF4A3298),
          title:
              Text('FAQs', style: TextStyle(fontSize: 19, color: Colors.white)),
          actions: <Widget>[
            new IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: null),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) =>
                EntryItem(data[index]),
            itemCount: data.length,
          ),
        ));
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'I have seen something I like, how can I buy it?',
    <Entry>[
      Entry(
          'Bidder allows you to Make an Offer by providing a price you would be willing to pay against a product you like. The offered prices stays anonymous throughout the period. Once the bidding ends, the product goes to the indivisual that made the highest bid. '),
    ],
  ),
  
  Entry(
    'How much do you charge for Delivery?',
    <Entry>[
      Entry(
          'Delievery fee varies from city to city and is applicable if order value is below a certain amount.'),
    ],
  ),
  Entry(
    'As a seller, how will I know if the buyer has made the payment?',
    <Entry>[
      Entry(
          'All payments are routed through our escrow account. Once the buyer pays the agreed amount, we will notify you via your registered email id and mobile number. This amount will get credited to your bank account once the product has been delivered to the buyer.'),
    ],
  ),
  Entry(
    'I want to deactivate my account. What can i do?',
    <Entry>[
      Entry(
          'Please write us at bidder2604@gmail.com in the event that yo want to deactivate your account'),
    ],
  ),
  Entry(
    'I forgot my password. How do I get a new one?',
    <Entry>[
      Entry(
          'Click “Forgot your password?” link on the Sign In panel and it will display a page to “Create a new Password”.'),
    ],
  ),
  Entry(
    'How much does it cost to post an Ad on Bidder?',
    <Entry>[
      Entry(
          'Bidder is a free service and does not charge you any fees to post Ads. Go ahead and enjoy it.'),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return ListTile(
          title: Text(root.title,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500)));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
        root.title,
        style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
      ),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

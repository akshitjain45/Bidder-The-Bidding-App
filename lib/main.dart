import 'package:bidding_app/models/user.dart';
import 'package:bidding_app/screens/home/homepage.dart';
import 'package:bidding_app/screens/onboarding.dart';
import 'package:bidding_app/services/auth.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:bidding_app/utils/routing/router.dart' as R;
import 'package:bidding_app/utils/size_config.dart';
import 'package:bidding_app/utils/theme.dart';
import 'package:bidding_app/widgets/commonUI/AppStreamBuilder.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider<User>.value(
    // initialData: null as User,
    value: authService.currentUserStream(),
    child: StreamedApp(),
  ));
}

class StreamedApp extends StatefulWidget {
  const StreamedApp({
    Key? key,
  }) : super(key: key);

  @override
  _StreamedAppState createState() => _StreamedAppState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_StreamedAppState>()!.restartApp();
  }
}

class _StreamedAppState extends State<StreamedApp> {
  Key _key = UniqueKey();

  void restartApp() {
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: StreamProvider<AppUser>.value(
        // initialData: AppUser(),
        value: context.watch<User>() != null
            ? UserDBServices().streamData(context.watch<User>()?.uid)
            : null,
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bidder',
      onGenerateRoute: R.Router.generateRoute,
      theme: theme(),
      home: Home(),
    );
  }
}

const platform = const MethodChannel('app.channel.shared.data');

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  void initMessaging() {
    FirebaseMessaging.onBackgroundMessage((message) async {
      print("message : $message");
    });
    FirebaseMessaging.instance.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
  }

  @override
  void initState() {
    super.initState();
    initMessaging();
    // handleShareIntent();
    // Listen to lifecycle events.
    WidgetsBinding.instance!.addObserver(this);
    //secure screenshot
    //    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   WidgetsBinding.instance!.removeObserver(this);
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     handleShareIntent();
  //   }
  // }

  // Future handleShareIntent() async {
  //   var sharedData;
  //   final sharedText = await platform.invokeMethod("getSharedText");
  //   final sharedImage = await platform.invokeMethod("getSharedImage");
  //   sharedData = {
  //     'text': sharedText,
  //     'file': sharedImage,
  //   };
  //   if (sharedData['text'] != null || sharedData['file'] != null) {
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StrmBldr<User?>(
        noDataWidget: OnboardingScreen(),
        stream: authService.currentUserStream(),
        builder: (context, snapshot) {
          return snapshot == null ? OnboardingScreen() : HomePage();
        });
  }
}

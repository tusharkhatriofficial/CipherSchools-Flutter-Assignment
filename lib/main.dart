import 'package:cipherx/providers/expense_provider.dart';
import 'package:cipherx/screens/home_screen.dart';
import 'package:cipherx/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'models/expense.dart';
import 'models/monthly_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Register adapters
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(MonthlyDataAdapter());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
        child: MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CipherX',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  String? _uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoginStatus();
  }

  Future<String?> getUserUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }

  Future<void> checkLoginStatus() async {
    String? uid = await getUserUID();
    setState(() {
      _uid = uid;
      _isLoading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
     if(_isLoading){
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }
     return _uid != null ? HomeScreen() : WelcomeScreen();
  }
}


import 'package:bobkeyflutter/insert.dart';
import 'package:bobkeyflutter/predict.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int i = 0;
  List<Widget> body = [];

  void set(int c) {
    setState(() {
      i = c;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    body = [home(), const InsertData(), PredictModel()];
    print(DateTime.now().millisecondsSinceEpoch);
  }

  Widget home() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(300, 50)),
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.red),
            ),
            onPressed: () {
              set(1);
            },
            icon: const Icon(Icons.new_label),
            label: const Text("Register"),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton.icon(
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.resolveWith(
                  (states) => const Size(300, 50)),
              backgroundColor:
                  MaterialStateProperty.resolveWith((states) => Colors.red),
            ),
            onPressed: () {
              set(2);
            },
            icon: const Icon(Icons.check_box),
            label: const Text("Login"),
          )
        ],
      ),
    );
  }

  get stk => Stack(
        children: [
          Opacity(
            opacity: 0.15,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                // "https://www.thenewsminute.com/sites/default/files/styles/slideshow_image_size/public/Bank_Baroda_entrace_Dubai_March_2008.jpg?itok=BtkXAuXd",
                // "https://1000logos.net/wp-content/uploads/2021/06/Bank-of-Baroda-Logo-history.png",
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9CHjhrm4MvsmPbns7UAybNJlN_zMLbDfjAA&usqp=CAU",
                fit: BoxFit.cover,
              ),
            ),
          ),
          body[i],
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
              onPressed: () {
                set(0);
              },
              icon: const Icon(Icons.home),
              label: const Text("HOME"),
              style: ButtonStyle(foregroundColor: clr)),
        ],
        title: const Text(
          "KeyStroke.io",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ),
      body: kIsWeb
          ? stk
          : SingleChildScrollView(
              child: stk,
            ),
    );
  }
}

var clr = MaterialStateProperty.resolveWith(
  (states) => Colors.white,
);

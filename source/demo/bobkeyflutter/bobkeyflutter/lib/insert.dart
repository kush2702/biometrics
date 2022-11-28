import 'package:flutter/material.dart';

import 'package:bobkeyflutter/functions.dart';

class InsertData extends StatefulWidget {
  const InsertData({super.key});

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  bool down = true;
  // Duration? lastKeyEnterdTime;

  double lastKeyEnterdTime = 0;
  double? _duration;
  List<double> dwell = [];
  List<double> downDown = [];
  List<double> upDown = [];
  List<int> charId = [];

  int question = 0;
  String uid = '';
  bool loading = false;

  int wordcount = 0;

  TextEditingController controller = TextEditingController();

  List<String> questions = [
    "Enter your id",
    "Enter something about yourself",
    "Enter your hobby",
    "Enter about your journey of life",
    "Enter something about family",
    "Enter something about friends",
  ];

  get focusNode => FocusNode(
        canRequestFocus: true,
        onKeyEvent: (node, event) {
          int ctime = DateTime.now().microsecondsSinceEpoch;
          int l = '$ctime'.length - 10;
          int i = 1;
          while (l > 0) {
            i *= 10;
            l--;
          }
          double curTime = ctime / i;

          if (down) {
            controller.text += event.character!;
             controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
            charId.add(event.logicalKey.keyLabel.toUpperCase().codeUnits[0]);
            downDown.add(curTime - lastKeyEnterdTime);
            lastKeyEnterdTime = curTime;
          } else {
            _duration = curTime - lastKeyEnterdTime;
            dwell.add(_duration!);
            upDown.add(downDown.last - dwell.last);

            wordcount++;
          }

          down = !down;
          return KeyEventResult.handled;
        },
      );

  void submit() async {
    if (wordcount < 165) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Write remaining ${165 - wordcount} Letters")));
      return;
    }

    List<String> finalvalues = [];

    for (int i = 0; i < charId.length - 1; i++) {
      finalvalues.add(
          "(${charId[i]},${charId[i + 1]},${dwell[i]},${dwell[i + 1]},${downDown[i]},${upDown[i]})");
    }
    print("\n\n");
    print(finalvalues.sublist(finalvalues.length - 160).length);
    // predict(data);
    setState(() {
      loading = true;
    });
    String res = await insertToDatabase(
        uid, finalvalues.sublist(finalvalues.length - 160));
    // String res="1";
    setState(() {
      loading = false;
    });

    if (res == "1") {
      clear();
      setState(() {
        question++;
      });
    }

    // print(finalvalues);
  }

  void clear() {
    lastKeyEnterdTime = 0;
    dwell = [];
    downDown = [];
    upDown = [];
    charId = [];
    // finalvalues = [];
    controller.clear();
  }

  void saveid() {
    uid = controller.text;
    if (uid.trim().length == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Empty id")));
      return;
    }
    print(uid.length);
    clear();
    setState(() {
      question++;
    });
  }

  dec(String dt) => InputDecoration(
        labelText: dt == "e" ? questions[question] : dt,
        hintText: "Continue writing",
        labelStyle: const TextStyle(color: Colors.red, fontSize: 20,fontWeight: FontWeight.bold),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(width: 1, color: Color.fromARGB(255, 75, 0, 0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(width: 1, color: Color.fromARGB(255, 175, 76, 76)),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide:
              BorderSide(width: 1, color: Color.fromARGB(255, 255, 82, 203)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: loading
          ? const CircularProgressIndicator()
          : question == questions.length
              ? const Text("Thanks for test data")
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (question != 0)
                      const Text(
                        "Please answer to these questions in min 160 words",
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),

                    Container(
                      // height: 300,
                      width: 500,
                      // padding: EdgeInsets.all(50),
                      margin: const EdgeInsets.only(bottom: 20, top: 60),

                      child: TextField(
                        focusNode: focusNode,
                        controller: controller,
                        showCursor: true,
                        decoration: dec("e"),
                        maxLines: null,
                      ),
                    ),
                    /////////////
                    ///
                    ///
                    if (question == 0)
                      Container(
                        // height: 300,
                        width: 500,
                        // padding: EdgeInsets.all(50),
                        margin: const EdgeInsets.only(bottom: 20),

                        child: TextField(
                          showCursor: true,
                          decoration: dec("Name"),
                          maxLines: null,
                        ),
                      ),

                    if (question == 0)
                      Container(
                        // height: 300,
                        width: 500,
                        // padding: EdgeInsets.all(50),
                        margin: const EdgeInsets.only(bottom: 20),

                        child: TextField(
                          showCursor: true,
                          decoration: dec("Email"),
                          maxLines: null,
                        ),
                      ),
                    if (question == 0)
                      Container(
                        // height: 300,
                        width: 500,
                        // padding: EdgeInsets.all(50),
                        margin: const EdgeInsets.only(bottom: 20),

                        child: TextField(
                          showCursor: true,
                          decoration: dec("Phone number"),
                          maxLines: null,
                        ),
                      ),

                    if (question == 0)
                      Container(
                        // height: 300,
                        width: 500,
                        // padding: EdgeInsets.all(50),
                        margin: const EdgeInsets.only(bottom: 20),

                        child: TextField(
                          showCursor: true,
                          decoration: dec("Address"),
                          maxLines: null,
                        ),
                      ),

                    if (question == 0)
                      Container(
                        // height: 300,
                        width: 500,
                        // padding: EdgeInsets.all(50),
                        margin: const EdgeInsets.only(bottom: 20),

                        child: TextField(
                          showCursor: true,
                          decoration: dec("DOB"),
                          maxLines: null,
                        ),
                      ),

                    //////////////////
                    //////////////////
                    ////////////////////////////////////////
                    const SizedBox(
                      height: 50,
                    ),

                    InkWell(
                      onTap: () => question == 0 ? saveid() : submit(),
                      child: Container(
                        width: 200,
                        height: 60,
                        alignment: Alignment.center,
                        //BoxDecoration Widget
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(
                                5.0,
                                5.0,
                              ), //Offset
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ), //BoxDecoration
                      ),
                    ),
                  ],
                ),
    );
  }
}

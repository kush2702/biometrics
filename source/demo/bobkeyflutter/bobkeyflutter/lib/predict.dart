import 'package:bobkeyflutter/functions.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mValue = StateProvider(
  (ref) => "Invalid user",
);
final state = StateProvider<bool>(
  (ref) => false,
);

final validating = StateProvider<bool>(
  (ref) => false,
);

class PredictModel extends ConsumerWidget {
  PredictModel({super.key});

  bool down = true;

  // Duration? lastKeyEnterdTime;
  double lastKeyEnterdTime = 0;

  double? _duration;

  List<double> dwell = [];

  List<double> downDown = [];

  List<double> upDown = [];

  List<double> charId = [];

  int last_index = 0;

  bool validuser = false;

  // bool status = false;

  TextEditingController controller = TextEditingController();

  void predict(List<String> data, WidgetRef ref) async {
    try {
      Response r = await Dio().get('http://192.168.240.36:8000/predict',
          queryParameters: {'data': data.toString()});

      print(r.data);
      if (double.parse(r.data.toString()) > 0.5) {
        // ref.read(mValue.notifier).state="Invalid user";
        ref.read(state.notifier).state = true;
      } else {
        ref.read(state.notifier).state = false;

        // ref.read(mValue.notifier).state="valid user";
      }

      //   .then((value) {
      //   setState(() {
      //     print(value.data);
      //     // if (value.data > 0.5) {
      //     //   status = true;
      //     // } else {
      //     //   status = false;
      //     // }
      //   });
      // }
      // );
    } catch (e) {
      print("object");
      ref.read(state.notifier).state = false;
      // ref.read(validating.notifier).state = false;
    }
  }

  FocusNode focusNode(WidgetRef ref) => FocusNode(
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
            charId.add(
                event.logicalKey.keyLabel.toUpperCase().codeUnits[0] / 254);
            downDown.add(curTime - lastKeyEnterdTime);
            lastKeyEnterdTime = curTime;
          } else {
            _duration = curTime - lastKeyEnterdTime;
            dwell.add(_duration!);
            upDown.add(downDown.last - dwell.last);
            last_index++;
            submit(ref);
          }

          down = !down;

          return KeyEventResult.handled;
        },
      );

  void submit(WidgetRef ref) {
    List<String> finalvalues = [];
    print(last_index);
    
    if (last_index > 31) {

      
      
      for (int k = 0; k < 30; k++) {
        int i = last_index - 31 + k;
        finalvalues.add(
            "(${charId[i]},${charId[i + 1]},${dwell[i]},${dwell[i + 1]},${downDown[i]},${upDown[i]})");
      }
      // print("\n\n\n");
      // print(finalvalues);
      // print("\n\n\n");
      predict(finalvalues, ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(state);
    final validatingStatus = ref.read(validating);
    print(validatingStatus);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            // height: 300,
            width: 500,
            // padding: EdgeInsets.all(50),

            child: TextField(
              focusNode: focusNode(ref),
              controller: controller,
              showCursor: true,
              decoration: dec,
              maxLines: null,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            width: 200,
            height: 60,
            alignment: Alignment.center,
            //BoxDecoration Widget
            decoration: BoxDecoration(
              color: status ? Colors.green : Colors.red,
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
            child:  Text(
                    status ? "Valid user" : "Invalid user",
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ), //BoxDecoration
          ),
          SizedBox(
            height: 30,
          ),
          if (validatingStatus) Text("Realtime validation running"),
            SizedBox(
            height: 30,
          ),
          if (validatingStatus) CircularProgressIndicator()
        ],
      ),
    );
  }
}

////////////////Decoration
///
///
///

const dec = InputDecoration(
  labelText: "Enter more than 30 words here for verify",
  hintText: "Enter your data",
  labelStyle:
      TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(width: 1, color: Color.fromARGB(255, 255, 0, 0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(width: 1, color: Color.fromARGB(255, 175, 76, 76)),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(width: 1, color: Color.fromARGB(255, 255, 82, 203)),
  ),
);

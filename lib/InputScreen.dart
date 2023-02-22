import 'dart:ffi';

import 'package:flutter/material.dart';
import 'soduku.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  List<List<TextEditingController>> controllers = List.generate(
      9, (_) => List.generate(9, (_)=>TextEditingController(), growable: false),
      growable: false);

  Widget? buildBoard() {
    List<Expanded> boardProMax = [];
    for (int i = 0; i < 9; i++) {
      List<Expanded> ff = [];
      for (int j = 0; j < 9; j++) {
        ff.add(Expanded(
          child: Container(

              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
              ),

              child: TextField(
                textInputAction: TextInputAction.next,
                maxLength: 1,
                onChanged: (_) =>FocusScope.of(context).nextFocus(),
                keyboardType: TextInputType.number,
                controller: controllers[i][j],
                decoration: const InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              )),
        ));
      }
      Row r = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: ff,
      );
      boardProMax.add(Expanded(child: r));
    }
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            flex: 11,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                boardProMax[0],
                boardProMax[1],
                boardProMax[2],
                boardProMax[3],
                boardProMax[4],
                boardProMax[5],
                boardProMax[6],
                boardProMax[7],
                boardProMax[8],
              ],
            )),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () => setState(() {
              List<List<int>> soduku =
                  List.generate(9, (_) => List.filled(9, 0, growable: false));
              for (int i = 0; i < 9; i++) {
                for (int j = 0; j < 9; j++) {
                  try {
                    soduku[i][j] = int.parse(controllers[i][j].text.toString());
                  } catch (e) {
                    soduku[i][j] = 0;
                  }
                }
              }
              soduku = Solver.solve(soduku);

              for (int i = 0; i < 9; i++) {
                for (int j = 0; j < 9; j++) {
                  controllers[i][j].text = soduku[i][j].toString();
                }
              }

              var k = controllers;
            }),
            child: const Text("solve"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hint: type  0  in empty cells"),
      ),
      body: buildBoard(),
    );
  }
}

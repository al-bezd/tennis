import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenis/apps/tenis/models/game.dart';
import 'package:tenis/apps/tenis/widgets/field.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TenisGameWidget extends StatefulWidget {
  const TenisGameWidget({super.key});

  @override
  State<TenisGameWidget> createState() => _TenisGameWidgetState();
}

class _TenisGameWidgetState extends State<TenisGameWidget> {
  final tenisGame = TenisGame();

  @override
  void initState() {
    //tenisGame.startNewSet();
    tenisGame.stream.listen((event) {
      if(event==TenisGameState.startSet){
        tenisGame.startNewSet();
      }
      else if(event==TenisGameState.gameOver){
        Future.delayed(
          const Duration(milliseconds: 300),
          (){
            showWinnerAlert();
          });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<TenisGame>.value(
      value: tenisGame,
      child: Row(children: [
          Provider<bool>.value(value: true, child: const FieldWidget(),),
          Provider<bool>.value(value: false, child: const FieldWidget(),)
        ],),
    ) ;
  }

  void showWinnerAlert(){
    AwesomeDialog dialog = AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.success,
            width: 400,
            body: Center(child: Text(
                    '${tenisGame.currentGame!.winner!.name} Winner!',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'Winner',
           
            btnOkOnPress: () {},
            );
        dialog.show();
  }
}
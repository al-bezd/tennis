import 'package:flutter/material.dart';
import 'package:tenis/apps/player/widgets/field.dart';
import 'package:tenis/apps/player/widgets/register.dart';
import 'package:tenis/apps/tenis/models/game.dart';
import 'package:provider/provider.dart';

class FieldWidget extends StatefulWidget {
  const FieldWidget({super.key});

  @override
  State<FieldWidget> createState() => _FieldWidgetState();
}

class _FieldWidgetState extends State<FieldWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gameManager.stream.listen((event) {
      if (event == TenisGameState.addPlayer) {
        setState(() {});
      }
    });
  }

  TenisGame get gameManager => context.watch<TenisGame>();
  bool get isPlayer1 => context.watch<bool>();

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return SizedBox(
      width: sizeScreen.width / 2,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset('assets/img/tennis_place.jpg',
              fit: BoxFit.fill,
              width: sizeScreen.width / 2,
              height: sizeScreen.height),
          Opacity(
            opacity: 0.6,
            child: Container(
              color: isPlayer1 ? Colors.red[100] : Colors.blue[100],
            ),
          ),
          Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [
              gameManager.isPlayersReady
                  ? const PlayerField()
                  : const PlayerRegister()
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tenis/apps/player/models/player.dart';
import 'package:tenis/apps/tenis/models/game.dart';

class PlayerField extends StatefulWidget {
  const PlayerField({super.key});

  @override
  State<PlayerField> createState() => _PlayerFieldState();
}

class _PlayerFieldState extends State<PlayerField> {
  TenisGame get gameManager => context.read<TenisGame>(); 

  bool get isPlayer1=>context.read<bool>(); 

  Player get player => isPlayer1?gameManager.player1!:gameManager.player2!;
  late double quarterTurns;
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateAngleRotationBall();
    gameManager.stream.listen((event) {
      if (event==TenisGameState.addScore){
        setState(() {
          
        });
      }

     });
    //super.didChangeDependencie();
  }

  @override
  Widget build(BuildContext context) {
      return SizedBox(height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(children: [
            Text('name: ${player.name}'),
            const SizedBox(height: 16,),
            Text('surename: ${player.surename}'),
            const Spacer(),
            Column(children: [
              Text('count win games: ${gameManager.getCountWinGames(player)}'),
              const SizedBox(height: 16,),
              !gameManager.isGameOver? Text('current game score: ${gameManager.getCurrentGameScore(player)}'):const SizedBox()
            ],),
            const Spacer(),
            GestureDetector(
              onTap: () {
                updateAngleRotationBall();
                gameManager.makeStep(player);
              },
              child: SizedBox(
                height: 40,
                width: 40,
                child: Transform.rotate(
                  angle: quarterTurns,
                  child: Image.asset( 'assets/img/tennis_ball.png',fit: BoxFit.fitHeight,),) ),
            )

          ],),
        ),
      );
  }

  void updateAngleRotationBall(){
    quarterTurns = Random().nextInt(180).toDouble();
  }
}
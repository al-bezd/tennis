import 'dart:async';
import 'dart:developer';

import 'package:tenis/apps/player/models/player.dart';

enum TenisGameState {addPlayer,addScore,startSet,endSet,gameOver}

class TenisGame{
  

  StreamController streamController=StreamController.broadcast();

  Stream get stream=>streamController.stream;
  
  Player? player1;
  Player? player2;

  GameSet? currentGame;
  List<GameSet> games=[];
  bool isGameOver = false;

  bool get isPlayersReady  => player1!=null && player2!=null;




  void addPlayer({required String name,required String surename, required bool isPlayer1}){
    Player tmp = Player(name: name,surename: surename);
    if (isPlayer1){
      player1 = tmp;
    }else{
      player2 = tmp;
    }
    streamController.add(TenisGameState.addPlayer);
    if (player1!=null && player2!=null){
      streamController.add(TenisGameState.startSet);
    }
  }

  int getCountWinGames(Player player){
    int currentGameResul = 0;
    if (currentGame!.loser!=null && currentGame!.winner!=null){
      currentGameResul=currentGame!.winner==player?1:0;
    }
    return games.fold<int>(
    0, (previousValue, element) => previousValue + (element.winner==player?1:0))+currentGameResul;
  }

  ScoreItem? getCurrentGameScore(Player player){
    int index = currentGame!.score!.scoreItems.lastIndexWhere((element) => element.player==player);
    if (index != -1){
      return currentGame!.score!.scoreItems[index];
    }
    return null;

  }

  void startNewSet(){
    if (currentGame!=null){
      games.add(currentGame!);
    }
    currentGame = GameSet.create();
    if(player1!=null){_initStep(player1!);}
    if(player2!=null){_initStep(player2!);}
  }

  void _initStep(Player player){
    currentGame!.addScore(player:player,newScoreValue:0);
  }

  void makeStep(Player player){
    if (isGameOver){
         return;
    }
    if(player1==null || player2==null){
      return ;
    }
    ScoreItem? currentScore = getCurrentGameScore(player);
    int val = 0;
    if (currentScore!=null){
      val = currentScore.value;
    }
    int diff = 15;

    if (val==30){
      diff=10;
    }

    currentGame!.addScore(player:player,newScoreValue:val+diff);

    
    scanScore();  


    streamController.add(TenisGameState.addScore);
  }

  void scanScore(){
    var valPlayer1 = getCurrentGameScore(player1!);
    var valPlayer2 = getCurrentGameScore(player2!);

    if(valPlayer1.toString()=='A' && valPlayer2.toString()=='A'){
      currentGame!.score!.scoreItems.clear();
      currentGame!.addScore(player:player1!,newScoreValue:40);
      currentGame!.addScore(player:player2!,newScoreValue:40);
    }else if(valPlayer1!.value==70){
      currentGame!.winner = player1!;
      currentGame!.loser = player2!;
      endSet();
    }else if(valPlayer2!.value==70){
      currentGame!.winner = player2!;
      currentGame!.loser = player1!;
      endSet();
    }
  }

  void endSet(){
    scanSetWinner();
    if(!isGameOver){
      streamController.add(TenisGameState.startSet);
    }
    
    
  }

  void gameOver(){
    isGameOver = true;
    streamController.add(TenisGameState.gameOver);
  }


  void scanSetWinner(){
    int setWinCountPlayer1 = getCountWinGames(player1!);
    int setWinCountPlayer2 = getCountWinGames(player2!);

    if (setWinCountPlayer1>=6 || setWinCountPlayer2>=6){
      if (setWinCountPlayer1-setWinCountPlayer2>=2){
        log('player1 win');
        gameOver();
      }else if(setWinCountPlayer2-setWinCountPlayer1>=2){
        log('player2 win');
        gameOver();
      }
    }
  }
}

class GameSet{
  static GameSet create(){
    GameSet game = GameSet();
    game.score = Score.create();
    return game;
  }
  Player? winner;
  Player? loser;

  Score? score;

  bool get isGameEnd=>winner!=null && loser!=null;

  void addScore({required Player player, required int newScoreValue}){
    if (!isGameEnd){
      score!.add(player:player,score:newScoreValue);
    }
    
  }

}

class Score{
  static Score create(){
      return Score();
  }

  List<ScoreItem> scoreItems=[];

  void add({required Player player,required int score}){
    scoreItems.add(ScoreItem(player: player,value: score));
  }
}

class ScoreItem{
  ScoreItem({required this.player,required this.value});
  final DateTime dateCreate = DateTime.now();
  final Player player;
  final int value;

  @override
  String toString() {
    if (value==55){
      return 'A';
    }
    return '$value';
  }

}
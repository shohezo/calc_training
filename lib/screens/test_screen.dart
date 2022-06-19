import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_audio/just_audio.dart';

class TestScreen extends StatefulWidget {
  final int numberOfQuestions;

  TestScreen({required this.numberOfQuestions});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int numberOfRemaining = 0;
  int numberOfCorrect = 0;
  int correctRate = 0;

  int questionLeft = 0;
  int questionRight = 0;
  String operator = "";
  String answerString = "";

  late AudioPlayer _audioPlayer;

  bool isCalcButtonsEnabled = false;
  bool isAnswerCheckButtonEnabled = false;
  bool isBackButtonEnabled = false;
  bool isCorrectInCorrectImageEnabled = false;
  bool isEndMessageEnabled = false;
  bool isCorrect = false;

  //ゼロクリア
  @override
  void initState() {
    super.initState();
    numberOfCorrect = 0;
    correctRate = 0;
    numberOfRemaining = widget.numberOfQuestions;

    //効果音の準備
    _audioPlayer = AudioPlayer();
    setQuestion();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                //スコア表示部分
                _scorePart(),
                //問題表示部分
                _questionPart(),
                //電卓ボタン部分
                _calcButtons(),
                //答え合わせボタン
                _answerCheckButton(),
                //戻るボタン
                _backButton(),
              ],
            ),
            //◯・×画像
            _correctIncorrectImage(),
            //テスト終了メッセージ
            _endMessage(),
          ],
        ),
      ),
    );
  }

  // スコア表示部分
  Widget _scorePart() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Table(
        children: [
          TableRow(children: [
            Center(
                child: Text(
              "のこり問題数",
              style: TextStyle(fontSize: 10.0),
            )),
            Center(
                child: Text(
              "正解数",
              style: TextStyle(fontSize: 10.0),
            )),
            Center(
                child: Text(
              "正答率",
              style: TextStyle(fontSize: 10.0),
            )),
          ]),
          TableRow(children: [
            Center(
                child: Text(
              numberOfRemaining.toString(),
              style: TextStyle(fontSize: 18.0),
            )),
            Center(
                child: Text(
              numberOfCorrect.toString(),
              style: TextStyle(fontSize: 18.0),
            )),
            Center(
                child: Text(
              correctRate.toString(),
              style: TextStyle(fontSize: 18.0),
            )),
          ]),
        ],
      ),
    );
  }

  // 問題表示部分
  Widget _questionPart() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 100.0,
      ),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  questionLeft.toString(),
                  style: TextStyle(fontSize: 36.0),
                ),
              )),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  operator,
                  style: TextStyle(fontSize: 30.0),
                ),
              )),
          Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  questionRight.toString(),
                  style: TextStyle(fontSize: 36.0),
                ),
              )),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "=",
                  style: TextStyle(fontSize: 30.0),
                ),
              )),
          Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  answerString,
                  style: TextStyle(fontSize: 60.0),
                ),
              )),
        ],
      ),
    );
  }

  //TODO 電卓ボタン部分
  Widget _calcButtons() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 50.0,
        ),
        child: Table(
          children: [
            TableRow(children: [
              _calcButton("7"),
              _calcButton("8"),
              _calcButton("9"),
            ]),
            TableRow(children: [
              _calcButton("4"),
              _calcButton("5"),
              _calcButton("6"),
            ]),
            TableRow(children: [
              _calcButton("1"),
              _calcButton("2"),
              _calcButton("3"),
            ]),
            TableRow(children: [
              _calcButton("0"),
              _calcButton("-"),
              _calcButton("C"),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _calcButton(String numString) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.brown,
        ),
        onPressed: isCalcButtonsEnabled ? () => inputAnswer(numString) : null,
        child: Text(
          numString,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  //答え合わせボタン
  Widget _answerCheckButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isCalcButtonsEnabled ? () => answerCheck() : null,
          child: Text(
            "答え合わせ",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  //戻るボタン
  Widget _backButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: 8.0,
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isBackButtonEnabled ? () =>closedTestScreen() : null, //TODO
          child: Text(
            "戻る",
            style: TextStyle(fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  //TODO ◯・×画像
  Widget _correctIncorrectImage() {
    if (isCorrectInCorrectImageEnabled == true) {
      if (isCorrect) {
        return Center(
          child: Image.asset("assets/images/pic_correct.png"),
        );
      }
      return Center(
        child: Image.asset("assets/images/pic_incorrect.png"),
      );
    } else {
      return Container();
    }
  }

//TODO テスト終了メッセージ
  Widget _endMessage() {
    if (isEndMessageEnabled == true) {
      return Center(
        child: Text(
          "テスト終了",
          style: TextStyle(fontSize: 50.0),
        ),
      );
    } else {
      return Container();
    }
  }

//問題を出す
  void setQuestion() {
    isCalcButtonsEnabled = true;
    isAnswerCheckButtonEnabled = true;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = false;
    isEndMessageEnabled = false;
    isCorrect = false;
    answerString = "";

    Random random = Random();
    questionLeft = random.nextInt(100) + 1;
    questionRight = random.nextInt(100) + 1;

    if (random.nextInt(2) + 1 == 1) {
      operator = "+";
    } else {
      operator = "-";
    }

    setState(() {});
  }

  inputAnswer(String numString) {
    setState(() {
      if (numString == "C") {
        answerString = "";
        return;
      }
      if (numString == "-") {
        if (answerString == "") answerString = "-";
        return;
      }
      if (numString == "0") {
        if (answerString != "0" && answerString != "-")
          answerString = answerString + numString;
        return;
      }
      if (answerString == "0") {
        answerString = numString;
        return;
      }
      answerString = answerString + numString;
    });
  }

  answerCheck() {
    if (answerString == "" || answerString == "-") {
      return;
    }
    isCalcButtonsEnabled = false;
    isAnswerCheckButtonEnabled = false;
    isBackButtonEnabled = false;
    isCorrectInCorrectImageEnabled = true;
    isEndMessageEnabled = false;

    numberOfRemaining -= 1;

    var myAnswer = int.parse(answerString).toInt();

    var realAnswer = 0;
    if (operator == "+") {
      realAnswer = questionLeft + questionRight;
    } else {
      realAnswer = questionLeft - questionRight;
    }

    if (myAnswer == realAnswer) {
      isCorrect = true;
      numberOfCorrect++;
    } else {
      isCorrect = false;
    }
    _playSound(isCorrect);

    correctRate =
        (numberOfCorrect / (widget.numberOfQuestions - numberOfRemaining) * 100)
            .toInt();

    if (numberOfRemaining == 0) {
      //残り問題数がないとき
      isCalcButtonsEnabled = false;
      isAnswerCheckButtonEnabled = false;
      isBackButtonEnabled = true;
      isCorrectInCorrectImageEnabled = true;
      isEndMessageEnabled = true;
    } else {
      //残り問題数があるとき
      Timer(Duration(seconds: 1), () => setQuestion());
    }

    setState(() {});
  }

  void _playSound(bool isCorrect) async {
    if (isCorrect) {
      await _audioPlayer.setAsset("assets/sounds/sound_correct.mp3");
    } else {
      await _audioPlayer.setAsset("assets/sounds/sound_incorrect.mp3");
    }
    _audioPlayer.play();
  }

  closedTestScreen() {
    Navigator.pop(context);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guess_the_country/models/quiz_data.dart';

final quizController = StateNotifierProvider<QuizController, QuizData>((ref) => QuizController(),);

class QuizController extends StateNotifier<QuizData>{
  QuizController() : super(QuizData.empty());

  int reduceOneLife() {
    final numberOfLives = state.livesLeft;
    state = state.copyWith(livesLeft: numberOfLives - 1);
    return numberOfLives - 1;
  }

  reviveAllLives() {
    state = state.copyWith(livesLeft: 4);
  }

  void increasePoint() {
    final numberOfPoints = state.pointsEarned;
    state = state.copyWith(pointsEarned: numberOfPoints + 1);
  }
}
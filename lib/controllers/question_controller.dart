import 'package:guess_the_country/models/quiz_question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final questionController = StateNotifierProvider<QuestionController, QuizQuestion>((ref) => QuestionController(),);

class QuestionController extends StateNotifier<QuizQuestion> {
  QuestionController() : super(QuizQuestion.empty());

  setCountryList(List<String> countryList) {
    state = state.copyWith(countries: countryList);
  }

  setCorrectCountryIndex(int correctCountryIndex) {
    state = state.copyWith(index: correctCountryIndex);
  }

  startCountDownController() {
    state = state.copyWith(startCountDown: true);
  }

  changeFlagImage(String imageName) {
    final String path = "assets/flags/${imageName.toLowerCase()}.svg";
    state = state.copyWith(flagImgPath: path);
  }
}
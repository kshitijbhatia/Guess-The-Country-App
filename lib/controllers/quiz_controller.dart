import 'package:guess_the_country/models/quiz_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizController = StateNotifierProvider<QuizController, QuizData>((ref) => QuizController(),);

class QuizController extends StateNotifier<QuizData> {
  QuizController() : super(QuizData.empty());

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
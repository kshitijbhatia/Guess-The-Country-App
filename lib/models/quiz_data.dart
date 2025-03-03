import 'dart:ui';

class QuizData {
  List<String> countries;
  int correctCountryIndex;
  bool startCountDown;
  String flagImgPath;

  QuizData({
    required this.correctCountryIndex,
    required this.countries,
    required this.startCountDown,
    required this.flagImgPath
  });

  factory QuizData.empty() {
    return QuizData(
      correctCountryIndex: -1,
      countries: [],
      startCountDown: false,
      flagImgPath: "",
    );
  }

  copyWith({
    int? index,
    List<String>? countries,
    bool? startCountDown,
    String? flagImgPath
  }) {
    return QuizData(
      correctCountryIndex: index ?? correctCountryIndex,
      countries: countries ?? this.countries,
      startCountDown: startCountDown ?? this.startCountDown,
      flagImgPath: flagImgPath ?? this.flagImgPath
    );
  }
}
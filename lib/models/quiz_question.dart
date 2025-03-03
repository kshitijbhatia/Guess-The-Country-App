class QuizQuestion {
  List<String> countries;
  int correctCountryIndex;
  bool startCountDown;
  String flagImgPath;

  QuizQuestion({
    required this.correctCountryIndex,
    required this.countries,
    required this.startCountDown,
    required this.flagImgPath
  });

  factory QuizQuestion.empty() {
    return QuizQuestion(
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
    return QuizQuestion(
      correctCountryIndex: index ?? correctCountryIndex,
      countries: countries ?? this.countries,
      startCountDown: startCountDown ?? this.startCountDown,
      flagImgPath: flagImgPath ?? this.flagImgPath
    );
  }
}
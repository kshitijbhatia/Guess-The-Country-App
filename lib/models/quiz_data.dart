class QuizData {
  int pointsEarned;
  int livesLeft;

  QuizData({
    required this.pointsEarned,
    required this.livesLeft
  });

  factory QuizData.empty() {
    return QuizData(
      pointsEarned: 0,
      livesLeft: 4,
    );
  }

  copyWith({
    int? livesLeft,
    int? pointsEarned,
  }) {
    return QuizData(
      pointsEarned: pointsEarned ?? this.pointsEarned,
      livesLeft: livesLeft ?? this.livesLeft,
    );
  }
}
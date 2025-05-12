import 'package:flutter/foundation.dart';
import '../models/trivia.dart';

class TriviaProvider with ChangeNotifier {
  Trivia? _todayTrivia;

  Trivia? get todayTrivia => _todayTrivia;

  void setTodayTrivia(Trivia trivia) {
    _todayTrivia = trivia;
    notifyListeners();
  }

  void clearTrivia() {
    _todayTrivia = null;
    notifyListeners();
  }
}

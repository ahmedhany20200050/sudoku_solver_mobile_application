import 'dart:convert';
import 'dart:io';
class Solver{


  static const int _n = 9;
  static List<List<int>> _soduku = List.generate(
      _n, (_) => List.filled(_n, 0, growable: false),
      growable: false);
  static List<List<int>> _takenInZone = List.generate(
      _n, (_) => List.filled(_n + 1, 0, growable: false),
      growable: false);
  static List<List<int>> _numbersInColumns = List.generate(
      _n, (_) => List.filled(_n + 1, 0, growable: false),
      growable: false);
  static List<List<int>> _numbersInRows = List.generate(
      _n, (_) => List.filled(_n + 1, 0, growable: false),
      growable: false);
  static bool _done = false;

  static bool _valid(int r, int c) {
    if (r >= _n || c >= _n || r < 0 || c < 0) {
      return false;
    }
    return true;
  }

  void _printBoard() {
    for (int i = 0; i < _n; ++i) {
      for (int j = 0; j < _n; ++j) {
        stdout.write("${_soduku[i][j]} ");
      }
      stdout.write("\n");
    }
    _done = true;
  }

  static bool _checkCell(int a, int b, int value) {
    if (_numbersInRows[a][value] == 1) return false;

    if (_numbersInColumns[b][value] == 1) return false;
//    for (int i = 0; i < n; ++i) {
//        if (soduku[a][i] == value) {
//            return false;
//        }
//        if (soduku[i][b] == value) {
//            return false;
//        }
//    }
// check the 3 by 3 zone (in which the cell belongs)
    int offsetOne = ((a / 3).floor() * 3), offsetTwo = (b / 3).floor();
    if (_takenInZone[offsetOne + offsetTwo][value] == 1) {
      return false;
    }
//    for (int i = 0; i < 3; ++i) {
//        for (int j = 0; j < 3; ++j) {
//            int first = offsetOne + i, second = offsetTwo + j;
//            if (first == a && second == b)continue;
//            if (soduku[first][second] == value) {
//                return false;
//            }
//        }
//    }
    return true;
  }

  static void _backtracking(int a, int b) {
    if (_done) {
      return;
    }
    if (!_valid(a, b)) {
      _done = true;
      // printBoard();
      return;
    }
    if (_soduku[a][b] != 0) {
      if (b == 8) {
        if (_done) {
          return;
        }
        _backtracking(a + 1, 0);
      } else {
        if (_done) {
          return;
        }
        _backtracking(a, b + 1);
      }
      return;
    }

    for (int i = 1; i <= 9; ++i) {
      if (_done) {
        return;
      }
      if (_checkCell(a, b, i)) {
        _soduku[a][b] = i;
        int number = _soduku[a][b];
        int offsetOne = (a / 3).floor() * 3, offsetTwo = (b / 3).floor();
        _takenInZone[offsetOne + offsetTwo][number] = 1;
        _numbersInColumns[b][number] = 1;
        _numbersInRows[a][number] = 1;
        if (b == 8) {
          if (_done) {
            return;
          }
          _backtracking(a + 1, 0);
        } else {
          if (_done) {
            return;
          }
          _backtracking(a, b + 1);
        }
        if (_done) {
          return;
        }
        _soduku[a][b] = 0;
        _takenInZone[offsetOne + offsetTwo][number] = 0;
        _numbersInColumns[b][number] = 0;
        _numbersInRows[a][number] = 0;
      }
    }
  }

  static List<List<int>> solve(List<List<int>> board) {
    _soduku = board;
    _takenInZone = List.generate(_n, (aa) => List.filled(_n + 1, 0, growable: false),
        growable: false);
    _numbersInColumns = List.generate(
        _n, (aa) => List.filled(_n + 1, 0, growable: false),
        growable: false);
    _numbersInRows = List.generate(
        _n, (aa) => List.filled(_n + 1, 0, growable: false),
        growable: false);
    _done = false;

    for (int i = 0; i < _n; ++i) {
      for (int j = 0; j < _n; ++j) {
        int number = _soduku[i][j];
        int offsetOne = (i / 3).floor() * 3, offsetTwo = (j / 3).floor();
        _takenInZone[offsetOne + offsetTwo][number] = 1;
        _numbersInRows[i][number] = 1;
        _numbersInColumns[j][number] = 1;
      }
    }

    _backtracking(0, 0);
    return _soduku;
  }



}
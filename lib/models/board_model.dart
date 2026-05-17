import 'dart:math';
import 'cell_model.dart';

class BoardModel {
  final int rows;
  final int cols;
  final int numberOfMines;

  late List<List<CellModel>> cells;
  bool isGameOver = false;
  bool isGameWon = false;

  BoardModel({
    required this.rows,
    required this.cols,
    required this.numberOfMines,
  }) {
    _generateBoard();
  }

  void _generateBoard() {
    cells = List.generate(rows, (r) {
      return List.generate(cols, (c) {
        return CellModel(row: r, col: c);
      });
    });
    _placeMines();
    _calculateAdjacentMines();
  }

  void _placeMines() {
    int minesPlaced = 0;
    final random = Random();

    while (minesPlaced < numberOfMines) {
      int r = random.nextInt(rows);
      int c = random.nextInt(cols);

      if (!cells[r][c].isMine) {
        cells[r][c].isMine = true;
        minesPlaced++;
      }
    }
  }

  void _calculateAdjacentMines() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (cells[r][c].isMine) continue;

        int mineCount = 0;
        for (int i = -1; i <= 1; i++) {
          for (int j = -1; j <= 1; j++) {
            int newRow = r + i;
            int newCol = c + j;

            if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
              if (cells[newRow][newCol].isMine) {
                mineCount++;
              }
            }
          }
        }
        cells[r][c].adjacentMines = mineCount;
      }
    }
  }

  void revealCell(int r, int c) {
    if (isGameOver ||
        isGameWon ||
        cells[r][c].isRevealed ||
        cells[r][c].isFlagged)
      return;

    cells[r][c].isRevealed = true;

    if (cells[r][c].isMine) {
      isGameOver = true;
      _revealAllMines();
      return;
    }

    if (cells[r][c].adjacentMines == 0) {
      _revealExpanded(r, c);
    }

    _checkWinCondition();
  }

  void _revealExpanded(int r, int c) {
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int newRow = r + i;
        int newCol = c + j;

        if (newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols) {
          final neighbor = cells[newRow][newCol];
          if (!neighbor.isRevealed && !neighbor.isMine && !neighbor.isFlagged) {
            neighbor.isRevealed = true;
            if (neighbor.adjacentMines == 0) {
              _revealExpanded(newRow, newCol);
            }
          }
        }
      }
    }
  }

  void toggleFlag(int r, int c) {
    if (isGameOver || isGameWon || cells[r][c].isRevealed) return;
    cells[r][c].isFlagged = !cells[r][c].isFlagged;
  }

  void _revealAllMines() {
    for (var row in cells) {
      for (var cell in row) {
        if (cell.isMine) cell.isRevealed = true;
      }
    }
  }

  void _checkWinCondition() {
    bool won = true;
    for (var row in cells) {
      for (var cell in row) {
        if (!cell.isMine && !cell.isRevealed) {
          won = false;
          break;
        }
      }
    }
    if (won) {
      isGameWon = true;
    }
  }
}

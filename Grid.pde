class Grid {
  Cell[][] cells;
  ArrayList<Shape> shapes;

  boolean win = false;

  Grid() {
    calculateCellSize();

    //Cells
    cells = new Cell[GRID_COLUMNS][GRID_ROWS];
    for (int i = 0; i < GRID_COLUMNS; i++) {
      for (int j = 0; j < GRID_ROWS; j++) {
        cells[i][j] = new Cell(i, j);
      }
    }

    //Shapes
    float hueOffset = random(360f);
    shapes = new ArrayList<>(SHAPES_COUNT);
    for (int i = 0; i < SHAPES_COUNT; i++) {
      colorMode(HSB, 360, 100, 100);
      color shapeColour = color((hueOffset + (360f / float(SHAPES_COUNT) * float(i))) % 360f, 100, 100);
      colorMode(RGB, 255, 255, 255);
      shapes.add(new Shape(this, shapeColour));
    }

    //While there are still unclaimed cells...
    while (anyUnclaimed()) {
      for (int i = 0; i < shapes.size(); i++) {
        if (anyUnclaimed()) {
          shapes.get(i).expand(this);
        }
      }
    }

    for (Shape s : shapes) {
      s.finish();
    }

    countOverlaps();
  }

  boolean anyUnclaimed() {
    for (int i = 0; i < GRID_COLUMNS; i++) {
      for (int j = 0; j < GRID_ROWS; j++) {
        if (cells[i][j].generationClaimed == false) {
          return true;
        }
      }
    }

    return false;
  }

  void render() {
    //Cells
    for (int i = 0; i < GRID_COLUMNS; i++) {
      for (int j = 0; j < GRID_ROWS; j++) {
        cells[i][j].render();
      }
    }

    //Shapes
    for (int i = 0; i < shapes.size(); i++) {
      shapes.get(i).render();
    }

    //Overlapping cells
    for (int i = 0; i < GRID_COLUMNS; i++) {
      for (int j = 0; j < GRID_ROWS; j++) {
        cells[i][j].renderOverlap();
      }
    }

    if (win) {
      textAlign(CENTER, CENTER);
      textSize(64);
      outlineText("You won!\nPress R to restart!");
    }
  }

  void outlineText(String str) {
    int pts = 16;
    float dist = 8;
    fill(0);
    for (int i = 0; i < pts; i++) {
      float a = map(i, 0, pts, 0, TWO_PI);
      float x = cos(a) * dist;
      float y = sin(a) * dist;
      text(str, width/2 + x, height/2 + y);
    }
    fill(255);
    text(str, width/2, height/2);
  }

  void onMousePressed() {
    for (int i = shapes.size()-1; i >= 0; i--) {
      Shape s = shapes.get(i);
      boolean handled = s.onMousePressed();
      if (handled) {
        //Put the grabbed shape in front
        shapes.remove(i);
        shapes.add(s);
        break;
      }
    }
  }

  void onMouseReleased() {
    for (Shape s : shapes) {
      s.onMouseReleased();
    }

    countOverlaps();
  }

  void countOverlaps() {
    //find out how many shapes overlap each actual cells
    for (int i = 0; i < GRID_COLUMNS; i++) {
      for (int j = 0; j < GRID_ROWS; j++) {
        Cell c = cells[i][j];
        c.containedShapes = 0;
        for (Shape s : shapes) {
          for (Cell sc : s.cells) {
            if (fequals(c.x, s.anchorPosX + sc.x) && fequals(c.y, s.anchorPosY + sc.y))
              c.containedShapes++;
          }
        }
      }
    }

    if (checkForWin()) {
      win = true;
    }
  }

  boolean checkForWin() {
    //check for any cell with NOT 1
    for (int i = 0; i < GRID_COLUMNS; i++) {
      for (int j = 0; j < GRID_ROWS; j++) {
        Cell c = cells[i][j];
        if (c.containedShapes != 1) {
          return false;
        }
      }
    }
    return true;
  }
}

static boolean fequals(float a, float b) {
  return abs(a - b) < 0.001f;
}

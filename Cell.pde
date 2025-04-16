class Cell {
  int col, row;
  float x, y;

  boolean generationClaimed;

  int containedShapes = 0;

  Cell(int col, int row) {
    this.col = col;
    this.row = row;
    this.generationClaimed = false;
    calcPos();
  }

  void calcPos() {
    this.x = (width-cellSize*GRID_COLUMNS)/2 + cellSize * col;
    this.y = cellSize * row + GRID_PADDING;
  }

  void render() {
    calcPos();
    float sw = max(cellSize / 50, 1);
    strokeWeight(sw);
    render(color(255));

    if (debug) {
      fill(0);
      textSize(cellSize);
      textAlign(CENTER, CENTER);
      text(containedShapes, x + cellSize/2, y + cellSize/2);
    }
  }

  void render(color colour) {
    stroke(0);
    fill(colour, debug ? 100 : 255);
    rect(x, y, cellSize, cellSize);
  }

  void renderOverlap() {
    if (containedShapes > 1 && !mousePressed) {
      stroke(100, 0, 0);
      float sw = max(cellSize / 15, 1);
      strokeWeight(sw);
      noFill();
      rect(x, y, cellSize, cellSize);
    }
  }
}

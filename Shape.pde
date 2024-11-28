import java.util.List;
import java.util.Arrays;
import java.util.Collections;

enum Direction {
  UP, DOWN, LEFT, RIGHT;
}
List<Direction> directions = Arrays.asList(Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT);

class Shape {
  ArrayList<Cell> cells;
  color colour;

  float anchorPosX = 0;
  float anchorPosY = 0;

  float minX, maxX;
  float minY, maxY;

  boolean attachedToMouse = false;
  float grabOffsetX = 0;
  float grabOffsetY = 0;

  Shape(Grid grid, color colour) {
    this.cells = new ArrayList();
    this.colour = colour;

    //Choose a random unclaimed point on the grid to start with
    boolean searching = true;
    while (searching) {
      int col = int(random(GRID_COLUMNS));
      int row = int(random(GRID_ROWS));
      Cell cell = grid.cells[col][row];
      if (cell.generationClaimed == false) {
        cell.generationClaimed = true;
        cells.add(cell);
        searching = false;
      }
    }
  }

  void expand(Grid grid) {
    //Choose random cell from this shape's cells
    Collections.shuffle(cells);
    for (int i = 0; i < cells.size(); i++) {
      Cell cell = cells.get(i);
      int thisCol = cell.col;
      int thisRow = cell.row;

      //Choose random unclaimed direction (that is within the grid)
      Collections.shuffle(directions);
      for (int j = 0; j < directions.size(); j++) {
        Direction randDir = directions.get(j);
        final int potCol;
        final int potRow;
        switch(randDir) {
        case UP:
          potCol = thisCol+1;
          potRow = thisRow;
          break;
        case DOWN:
          potCol = thisCol-1;
          potRow = thisRow;
          break;
        case LEFT:
          potCol = thisCol;
          potRow = thisRow-1;
          break;
        case RIGHT:
          potCol = thisCol;
          potRow = thisRow+1;
          break;
        default:
          throw new RuntimeException("Direction index out of bounds!");
        }

        if (potCol >= 0 && potCol < GRID_COLUMNS && potRow >= 0 && potRow < GRID_ROWS) {
          Cell pot = grid.cells[potCol][potRow];
          if (pot.generationClaimed == false) {
            //Claim cell
            pot.generationClaimed = true;
            //Add cell to cells
            cells.add(pot);
            return;
          }
        }
      }
    }
  }

  void finish() {
    calculateBoundingBox();

    anchorPosX = random(-minX + cellSize/2, width-maxX - cellSize/2);
    anchorPosY = random(-minY + cellSize/2, height-maxY - cellSize/2);
    snapPos();
  }

  void calculateBoundingBox() {
    minX = Float.POSITIVE_INFINITY;
    minY = Float.POSITIVE_INFINITY;

    maxX = Float.NEGATIVE_INFINITY;
    maxY = Float.NEGATIVE_INFINITY;
    for (Cell c : cells) {
      if (c.x < minX) minX = c.x;
      if (c.x > maxX) maxX = c.x;
      if (c.y < minY) minY = c.y;
      if (c.y > maxY) maxY = c.y;
    }
    maxX += cellSize;
    maxY += cellSize;
  }

  void render() {
    calculateBoundingBox();

    if (attachedToMouse) {
      anchorPosX = mouseX - minX - grabOffsetX;
      anchorPosY = mouseY - minY - grabOffsetY;
    }

    pushMatrix();
    translate(anchorPosX, anchorPosY);

    for (Cell c : cells) {
      c.render(colour);
    }

    if (debug) {
      rectMode(CORNERS);
      noFill();
      stroke(255, 0, 0);
      strokeWeight(5);
      rect(minX, minY, maxX, maxY);

      strokeWeight(10);
      rectMode(CORNER);
    }
    popMatrix();
  }

  boolean onMousePressed() {
    for (Cell c : cells) {
      float cx = anchorPosX + c.x;
      float cy = anchorPosY + c.y;
      if (mouseX >= cx && mouseX < cx + cellSize && mouseY >= cy && mouseY < cy + cellSize) {
        grabOffsetX = mouseX - minX - anchorPosX;
        grabOffsetY = mouseY - minY - anchorPosY;
        attachedToMouse = true;
        return true;
      }
    }
    return false;
  }

  void onMouseReleased() {
    attachedToMouse = false;
    snapPos();
  }

  void snapPos() {
    anchorPosX = roundToClosest(anchorPosX, cellSize);
    anchorPosY = roundToClosest(anchorPosY, cellSize);
  }
}

public static float roundToClosest(float num, float mul) {
  return mul*(round(num/mul));
}

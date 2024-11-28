//Gameplay variables
int GRID_COLUMNS = 10;
int GRID_ROWS = 10;
int SHAPES_COUNT = 8;

//Visual variables
float GRID_PADDING = 48;

//Platform variables
final boolean MOBILE = false;

//Globally shared modifyable variables :)
boolean debug = false;
float cellSize = -1;
Grid grid = null;

void settings() {
  if (MOBILE) {
    fullScreen();
  } else {
    size(1280, 720);
  }
}

void setup() {
  grid = new Grid();
  if (!MOBILE) {
    maximizeWindow();
  }
}

void maximizeWindow() {
  //Call via reflection, so Android mode doesn't complain about non-existent variables
  try {
    surface.getClass().getMethod("setResizable", boolean.class).invoke(surface, true);
  }
  catch(Exception e) {
    throw new RuntimeException(e);
  }
}

void calculateCellSize() {
  float playAreaX = width - GRID_PADDING*2;
  float playAreaY = height - GRID_PADDING*2;
  float potentialWidth = playAreaX/GRID_COLUMNS;
  float potentialHeight = playAreaY/GRID_ROWS;
  cellSize = min(potentialWidth, potentialHeight);
}

void draw() {
  background(200);
  debug = keyPressed && key == ' ';
  calculateCellSize();
  grid.render();


  if (MOBILE) {
    Rbtn_render();
  }
}

boolean isLandscape() {
  return width > height;
}

void mousePressed() {
  grid.onMousePressed();
}

void mouseReleased() {
  grid.onMouseReleased();

  if (MOBILE) {
    Rbtn_onClick();
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    grid = new Grid();
  }
}

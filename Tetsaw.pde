//Gameplay variables
int GRID_COLUMNS = 10;
int GRID_ROWS = 10;
int SHAPES_COUNT = 8;

//Visual variables
float GRID_PADDING = 48;

//Platform variables

//Globally shared modifyable variables :)
boolean debug = false;
boolean mobile = false;
float cellSize = -1;
Grid grid = null;

void settings() {
  mobile = System.getProperty("java.vendor.url").toLowerCase().contains("android");
  if (mobile) {
    fullScreen();
  } else {
    size(1280, 720);
  }
}

void setup() {
  grid = new Grid();
  if (!mobile) {
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


  if (mobile) {
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

  if (mobile) {
    Rbtn_onClick();
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    grid = new Grid();
  }
}

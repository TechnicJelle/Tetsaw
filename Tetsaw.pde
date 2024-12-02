enum Screen {
  Main, Game
}

//Gameplay variables
final int GRID_COLUMNS = 10;
final int GRID_ROWS = 10;
final int SHAPES_COUNT = 8;

//Visual variables
final float GRID_PADDING = 48;
final float UI_EDGE_PADDING = 32;


//Globally shared modifiable variables :)
Screen screen = Screen.Main;
PImage icon;
boolean debug = false;
boolean isMobile = false;
float cellSize = -1;
Grid grid = null;
float uiSize;

Button backButton;
Button resetButton;
Button startButton;
Button desktopQuitButton;

void settings() {
  isMobile = System.getProperty("java.vendor.url").toLowerCase().contains("android");
  if (isMobile) {
    fullScreen();
  } else {
    size(1280, 720);
  }
}

void setup() {
  icon = loadImage("icon.png");
  if (!isMobile) {
    desktopSurfaceSetup();
    desktopQuitButton = new DesktopQuitButton();
  }
  grid = new Grid();
  resetButton = new MobileResetButton();
  backButton = new BackButton();
  startButton = new StartButton();
}

void desktopSurfaceSetup() {
  //Call via reflection, so Android mode doesn't complain about non-existent variables
  try {
    surface.getClass().getMethod("setResizable", boolean.class).invoke(surface, true);
    surface.getClass().getMethod("setIcon", PImage.class).invoke(surface, icon);
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
  background(69, 9, 122);
  uiSize = max(width, height) / 16;
  switch(screen) {
  case Main:
    {
      //Title
      int siz = min(width, height) / 5;
      image(icon, width/2-siz*2.1, height*0.1, siz, siz);
      textAlign(LEFT, BASELINE);
      textSize(siz);
      fill(0);
      float off = siz/20;
      text("Tetsaw", width/2-siz*1.15 + off, height*0.1+siz*0.9 + off);
      fill(255);
      text("Tetsaw", width/2-siz*1.15, height*0.1+siz*0.9);

      //Buttons
      startButton.render();
      if (!isMobile) {
        desktopQuitButton.render();
      }
    }
    break;
  case Game:
    {
      debug = keyPressed && key == ' ';
      calculateCellSize();
      grid.render();

      //Buttons
      resetButton.render();
      backButton.render();

      //Watermark
      if (isLandscape()) {
        image(icon, UI_EDGE_PADDING, UI_EDGE_PADDING, uiSize, uiSize);
      } else {
        image(icon, width/2-uiSize/2, (height - uiSize - UI_EDGE_PADDING), uiSize, uiSize);
      }
    }
    break;
  }
}

boolean isLandscape() {
  return width > height;
}

void mousePressed() {
  switch (screen) {
  case Main:
    break;
  case Game:
    grid.onMousePressed();
    break;
  }
}

void mouseReleased() {
  switch (screen) {
  case Main:
    startButton.clickCheck();
    if (!isMobile) {
      desktopQuitButton.clickCheck();
    }
    break;
  case Game:
    grid.onMouseReleased();
    resetButton.clickCheck();
    backButton.clickCheck();
    break;
  }
}

void keyPressed() {
  if (key == 'R' || key == 'r') {
    grid = new Grid();
  }
}

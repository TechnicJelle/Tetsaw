abstract class Button {
  protected float x, y;
  protected float hght;
  protected float wdth;
  protected String label;

  Button(String label) {
    this.label = label;
    calculatePosAndHeight();
  }

  void textStyle() {
    textAlign(CENTER, CENTER);
    textSize(hght*0.8);
  }

  abstract void calculatePosAndHeight();

  abstract void onClick();

  void render() {
    calculatePosAndHeight();

    //Calculate button width
    textStyle();
    float tw = textWidth(label);
    wdth = max(tw*1.3, hght);

    stroke(0);
    strokeWeight(hght/20);
    if (isMobile) {
      if (mousePressed) {
        fill(100, mouseOver() ? 200 : 100);
      } else {
        fill(100, 100);
      }
    } else {
      fill(100, mouseOver() ? 200 : 100);
    }

    rect(x, y, wdth, hght, hght/6);
    fill(0);
    textStyle();
    text(label, x + wdth/2, y + hght/2);
  }

  boolean mouseOver() {
    return mouseX > x && mouseX < x + wdth && mouseY > y && mouseY < y + hght;
  }

  void clickCheck() {
    if (mouseOver()) {
      onClick();
    }
  }
}

class ResetButton extends Button {
  ResetButton() {
    super("R");
  }

  void calculatePosAndHeight() {
    hght = uiSize;
    x = width - wdth - UI_EDGE_PADDING;
    y = height - hght - UI_EDGE_PADDING;
  }

  void onClick() {
    grid = new Grid();
  }
}

class BackButton extends Button {
  BackButton() {
    super("<");
  }

  void calculatePosAndHeight() {
    hght = uiSize;
    x = UI_EDGE_PADDING;
    y = height - hght - UI_EDGE_PADDING;
  }

  void onClick() {
    screen = Screen.Main;
  }
}

class StartButton extends Button {
  StartButton() {
    super("Start Game!");
  }

  void calculatePosAndHeight() {
    hght = uiSize * 1.2;
    x = width/2 - wdth/2;
    y = height/2 - hght;
  }

  void onClick() {
    if (GRID_COLUMNS * GRID_ROWS < SHAPES_COUNT) return;

    if (grid == null) grid = new Grid();
    screen = Screen.Game;
  }
}

class DesktopQuitButton extends Button {
  DesktopQuitButton() {
    super("Quit...");
  }

  void calculatePosAndHeight() {
    hght = uiSize * 0.8;
    x = width/2 - wdth/2;
    y = height - hght*1.3;
  }

  void onClick() {
    background(0);
    textStyle();
    fill(255);
    text("Quitting...", width/2, height/2);
    exit();
  }
}

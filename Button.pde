abstract class Button {
  protected float x, y;
  protected float hght;
  protected float wdth;
  protected String text;

  Button(String text) {
    this.text = text;
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
    float tw = textWidth(text);
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
    text(text, x + wdth/2, y + hght/2);
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

class MobileResetButton extends Button {
  MobileResetButton() {
    super("R");
  }

  void calculatePosAndHeight() {
    hght = uiSize;
    y = height - hght - UI_EDGE_PADDING;
    x = width - wdth - UI_EDGE_PADDING;
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
    y = height - hght - UI_EDGE_PADDING;
    x = UI_EDGE_PADDING;
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
    y = height/2 - hght;
    x = width/2 - wdth/2;
  }

  void onClick() {
    screen = Screen.Game;
  }
}

class DesktopQuitButton extends Button {
  DesktopQuitButton() {
    super("Quit...");
  }

  void calculatePosAndHeight() {
    hght = uiSize * 1.2;
    y = height - hght*1.5;
    x = width/2 - wdth/2;
  }

  void onClick() {
    background(0);
    textStyle();
    fill(255);
    text("Quitting...", width/2, height/2);
    exit();
  }
}

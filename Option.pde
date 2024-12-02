abstract class Option {
  DownOptionButton downButton;
  UpOptionButton upButton;
  String label;
  int hOff;

  Option(String label, int hOff) {
    this.label = label;
    this.hOff = hOff;
  }

  void render(int optionValue) {
    downButton.hOff = hOff;
    upButton.hOff = hOff;

    downButton.render();
    float y = height/2 + uiSize*(0.7+hOff*1.1);
    text(label + ":" + optionValue, width/2, y);
    upButton.render();
  }

  void clickCheck() {
    downButton.clickCheck();
    upButton.clickCheck();
  }
}

abstract class OptionButton extends Button {
  boolean left;
  float hOff;

  OptionButton(String label, boolean left) {
    super(label);
    this.left = left;
  }

  void calculatePosAndHeight() {
    hght = uiSize;
    final float uOff = uiSize*2.6;
    final float off = left ? -uOff : uOff;
    x = width/2 - wdth/2 + off;
    y = height/2 + hght*(0.2+hOff*1.1);
  }
}

abstract class DownOptionButton extends OptionButton {
  DownOptionButton() {
    super("-", true);
  }
}

abstract class UpOptionButton extends OptionButton {
  UpOptionButton() {
    super("+", false);
  }
}

class ColsOption extends Option {
  class ColsDownButton extends DownOptionButton {
    void onClick() {
      GRID_COLUMNS--;
      grid = null;
    }
  }

  class ColsUpButton extends UpOptionButton {
    void onClick() {
      GRID_COLUMNS++;
      grid = null;
    }
  }

  ColsOption() {
    super("Columns", 0);
    downButton = new ColsDownButton();
    upButton = new ColsUpButton();
  }
}

class RowsOption extends Option {
  class RowsDownButton extends DownOptionButton {
    void onClick() {
      GRID_ROWS--;
      grid = null;
    }
  }

  class RowsUpButton extends UpOptionButton {
    void onClick() {
      GRID_ROWS++;
      grid = null;
    }
  }

  RowsOption() {
    super("Rows", 1);
    downButton = new RowsDownButton();
    upButton = new RowsUpButton();
  }
}

class ShapesOption extends Option {
  class ShapesDownButton extends DownOptionButton {
    void onClick() {
      SHAPES_COUNT--;
      grid = null;
    }
  }

  class ShapesUpButton extends UpOptionButton {
    void onClick() {
      SHAPES_COUNT++;
      grid = null;
    }
  }

  ShapesOption() {
    super("Shapes", 2);
    downButton = new ShapesDownButton();
    upButton = new ShapesUpButton();
  }
}

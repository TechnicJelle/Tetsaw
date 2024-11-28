//MOBILE only

float Rbtn_size = 200;
float Rbtn_edgeOffset = 32;

void Rbtn_render() {
  stroke(0);
  strokeWeight(8);
  fill(100, 100);
  rect(width - Rbtn_edgeOffset, height - Rbtn_edgeOffset, -Rbtn_size, -Rbtn_size, Rbtn_size/6);
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(Rbtn_size*0.8);
  text("R", width -Rbtn_edgeOffset - Rbtn_size/2, height - Rbtn_edgeOffset - Rbtn_size/2);
}

void Rbtn_onClick() {
  if (mouseX > width - Rbtn_edgeOffset - Rbtn_size && mouseY > height - Rbtn_edgeOffset - Rbtn_size) {
    grid = new Grid();
  }
}

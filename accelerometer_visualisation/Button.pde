class Button
{
  PVector pos;
  int     w;
  int     h;
  String  text;
  boolean isSwitched;
  
  // konstruktor
  Button(PVector buttonPosition, int buttonWidth) {
    pos = new PVector(buttonPosition.x, buttonPosition.y);
    
    w = buttonWidth;
    h = 44;
    text = "Live";
    isSwitched = false;
  }
  
  // zeichnet den ball
  void draw() {
    fill(colorLightBlue);
    rect(pos.x, pos.y, w, h);
    textAlign(LEFT);
    fill(#ffffff);
    if (isSwitched) {
      text = "SD Card";
    } else {
      text = "Live";
    }
    text(text, pos.x + 10, pos.y + 44 - 17);
  }
}
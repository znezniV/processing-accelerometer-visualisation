import processing.serial.*;  // Import the Processing Serial Library for communicating with arduino
Serial myPort;               // The used Serial Port

// if in live mode (connected sensor) or reading from local data
boolean isLiveMode = true;
int theSensitivity = 50;
// counter for local data (needed for loop)
int sdCounter = 0;
float zHigh = 0;
int thirdValuePrint = 0;
// colors
color colorBlue = #2A3AE5;
color colorLightBlue = #23BFF0;
color colorGreen = #1AD135;
// local data array
String[] lines;
// data that will be read (default needed)
int[] dataValues = {0, 0, 0};
color[] colorArray = {colorGreen, colorBlue, colorLightBlue};
// button to switch from live to local data mode
PVector buttonPosition = new PVector(10, 446);
Button switchButton = new Button(buttonPosition, 100);

void setup(){
  size(1000, 500);
  background(#FFFFFF);

  // Prints the list of serial available devices (Arduino should be on top of the list)
  println(Serial.list()); 

  // Open a new port and connect with Arduino at 9600 baud
  myPort = new Serial(this, Serial.list()[2], 9600);

  // load local data
  lines = loadStrings("data.txt");
}

void draw(){

  // TODO, hack that loop sizes are different (array did somehow not  work)
  int loopSize = 3;

  // check if in livemode
  if (isLiveMode) {
    loopSize = 3;
  } else {
    loopSize = 2;
    // if not in live mode it runs the local data function
    loadLocalData();  
  }

  // draws dots from data values array, colors are linked with same index
  for (int i = 0; i < loopSize; i++) {
    drawDots(dataValues[i], colorArray[i]);
  }

  // draw zero line
  stroke(0,0,0);
  strokeWeight(1);
  point(width/2,height/2);

  if (dataValues[2] > zHigh){
   zHigh = dataValues[2];
  }

  if (frameCount%10==0){
   thirdValuePrint = dataValues[2];
  }

  // scroll effekt
  loadPixels(); // Prepare the pixels array
  for(int i = 0; i < pixels.length; i ++) { // Loop through all of the pixels, position 0 is the top left corner going right and then down
   if(i % width != 0 && i < pixels.length - 1) pixels[i] = pixels[i + 1]; // Assign each pixel to be the pixel to its right...
   else pixels[i] = color(#FFFFFF); // ...unless it is at the end of a line or is the last one, in which case we make it the background color
  }
  updatePixels(); // Update the pixels array to the screen

  // legend panel
  textAlign(RIGHT);
  noStroke();
  fill(10,10,10);
  rect(1,0,120,height);
  textSize(15);
  fill(colorGreen);
  text("x", 10, 25);
  fill(colorBlue);
  text("y", 30, 25);
  fill(colorLightBlue);
  text("z", 60, 25);
  text(zHigh, 60, 49);
  text(thirdValuePrint, 50, 80);

  // draw switch button
  switchButton.draw();
}

// Is called everytime there is new data to read
void serialEvent(Serial myPort) {
  if (myPort.available() > 0 && isLiveMode) {
    String completeString = myPort.readStringUntil(10); // Read the Serial port until there is a linefeed/carriage return

    if (completeString != null) {// If there is valid data insode the String {
      trim(completeString); // Remove whitespace characters at the beginning and end of the string
      String seperateValues[] = split(completeString, ","); // Split the string everytime a delimiter is received
      dataValues = int(seperateValues);
    }
  }
}

void loadLocalData() {
  // restart if counter is at the end of the array
  if (sdCounter >= lines.length) {
    sdCounter = 0;
  }

  sdCounter++;

  // seperates text data from file and moves to array
  if (lines[sdCounter] != null) { // If there is valid data insode the String
    trim(lines[sdCounter]); // Remove whitespace characters at the beginning and end of the string
    String seperateValues[] = split(lines[sdCounter], ","); // Split the string everytime a delimiter is received
    dataValues = int(seperateValues);
  }
} 

void drawDots(int inputValue, color strokeValue) {
  // mapping
  float drawer = map(inputValue, -theSensitivity, theSensitivity, 0, height);

  // invert
  drawer = height - drawer;

  // draw
  stroke(strokeValue);
  strokeWeight(2);
  point(width/2, drawer);
}

void mouseReleased() {
  // hitting button, switching live mode and text of button
  if (mouseX >= buttonPosition.x && mouseX <= buttonPosition.x + 100 && mouseY >= buttonPosition.y && mouseY <= buttonPosition.y + 44) {
    switchButton.isSwitched = !switchButton.isSwitched;
    isLiveMode = !isLiveMode;
  }  
}

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class accelerometer_visualisation extends PApplet {

  // Import the Processing Serial Library for communicating with arduino
Serial myPort;               // The used Serial Port

int firstValue, secondValue, thirdValue;// fourthValue, fifthValue, ... // add more if needed
int theSensitivity = 50;
float zHigh = 0;
int thirdValuePrint = 0;

public void setup(){
  
  background(0xffFFFFFF);
  println(Serial.list()); // Prints the list of serial available devices (Arduino should be on top of the list)
  myPort = new Serial(this, Serial.list()[3], 9600); // Open a new port and connect with Arduino at 9600 baud
}

public void draw(){
 println(firstValue);
 println(secondValue);
 println(thirdValue);

 float firstDrawer = map(firstValue, -theSensitivity,theSensitivity,0,height);
 //invert
 firstDrawer = height - firstDrawer;
 stroke(0xff1AD135);
 strokeWeight(2);
 point(width/2,firstDrawer);

 //mapping
 float secondDrawer = map(secondValue, -theSensitivity,theSensitivity,0,height);
 //invert
 secondDrawer = height - secondDrawer;
 stroke(0xff2A3AE5);
 strokeWeight(2);
 point(width/2,secondDrawer);

 //mapping
 float thirdDrawer = map(thirdValue, -theSensitivity,theSensitivity,0,height);
 //invert
 thirdDrawer = height - thirdDrawer;
 stroke(0xff23BFF0);
 strokeWeight(2);
 point(width/2,thirdDrawer);

 stroke(0,0,0);
 strokeWeight(1);
 point(width/2,height/2);

 if (thirdValue > zHigh){
   zHigh = thirdValue;

 }

 if (frameCount%10==0){
   thirdValuePrint = thirdValue;
 }

 //scroll effekt
 loadPixels(); //Prepare the pixels array
 for(int i = 0; i < pixels.length; i ++) { //Loop through all of the pixels, position 0 is the top left corner going right and then down
   if(i % width != 0 && i < pixels.length - 1) pixels[i] = pixels[i + 1]; //Assign each pixel to be the pixel to its right...
   else pixels[i] = color(0xffFFFFFF); //...unless it is at the end of a line or is the last one, in which case we make it the background color
 }
 updatePixels(); //Update the pixels array to the screen

 //legend
 textAlign(RIGHT);
 noStroke();
 fill(10,10,10);
 rect(1,0,100,height);
 textSize(15);
 fill(0xff1AD135);
 text("x", 10, 25);
 fill(0xff2A3AE5);
 text("y", 30, 25);
 fill(0xff23BFF0);
 text("z", 60, 25);
 fill(0xff23BFF0);
 text(zHigh, 60, 49);
 fill(0xff23BFF0);
 text(thirdValuePrint, 50, 80);
}


public void serialEvent(Serial myPort) // Is called everytime there is new data to read
{
  if (myPort.available() > 0)
  {
    String completeString = myPort.readStringUntil(10); // Read the Serial port until there is a linefeed/carriage return
    if (completeString != null) // If there is valid data insode the String
    {
      trim(completeString); // Remove whitespace characters at the beginning and end of the string
      String seperateValues[] = split(completeString, ","); // Split the string everytime a delimiter is received
      firstValue = PApplet.parseInt(seperateValues[0]);
      secondValue = PApplet.parseInt(seperateValues[1]);
      thirdValue = PApplet.parseInt(seperateValues[2]);

    }
  }
}
  public void settings() {  size(1000, 500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "accelerometer_visualisation" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

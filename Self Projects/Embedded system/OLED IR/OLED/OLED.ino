hat#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define IR 33
#define SCREEN_WIDTH 128 // OLED width,  in pixels
#define SCREEN_HEIGHT 64 // OLED height, in pixels

// create an OLED display object connected to I2C
Adafruit_SSD1306 oled(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);

void setup() {
  Serial.begin(9600);
  pinMode(IR, INPUT);
  // initialize OLED display with I2C address 0x3C
  if (!oled.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("failed to start SSD1306 OLED"));
    while (1);
  }

  delay(2000);         // wait two seconds for initializing
  oled.clearDisplay(); // clear display

  oled.setTextSize(1);         // set text size
  oled.setTextColor(WHITE);    // set text color
  oled.setCursor(0, 2);       // set position to display (x,y)
  oled.println("Robotronix"); // set text
  oled.display();              // display on OLED
}

void loop() {
  // read the state of the IR sensor
  int state = digitalRead(IR);
  // display the status on the OLED display
  oled.clearDisplay();
  oled.setCursor(0, 0);
  oled.print("IR Sensor Status:");
  oled.setCursor(0, 16);
  if (state == HIGH) {
    oled.print("Object Detected");
  } else {
    oled.print("No Object Detected");
  }
  oled.display();
  // wait for a short time before checking the sensor again
  delay(100);
}

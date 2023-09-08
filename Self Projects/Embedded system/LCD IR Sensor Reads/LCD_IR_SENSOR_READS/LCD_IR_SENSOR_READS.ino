#include <LiquidCrystal.h>

int IR_SENSOR = 34;
const int rs=22,e=23,d4=5,d5=18,d6=19,d7=21;
LiquidCrystal lcd(rs, e, d4, d5, d6, d7);

float distance = 0; // Distance value in mm

void setup() {
  Serial.begin(115200);
  lcd.clear();
  // Initialize the LCD screen
  lcd.begin(16, 2);
}

void loop() {
  // Read the analog value from the IR sensor
  int irValue = analogRead(IR_SENSOR);
  // Printing values
  Serial.println(irValue);
  // Check if the IR sensor is not connected or has a poor connection
  if (irValue < 10) {
    // Display error message on the LCD screen
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("No input shown");
      lcd.setCursor(0,1);
      lcd.print("connect sensor");
  } else {
    lcd.clear();
    // Map the analog value to a distance value between 1-25 mm
    distance = map(irValue, 0, 4095, 1, 25);
    Serial.println(distance);
    // Display the distance value on the LCD screen
    lcd.setCursor(0, 0);
    lcd.print("Distance: ");
    lcd.print(distance);
    lcd.print(" mm");
  }
  delay(500);
}

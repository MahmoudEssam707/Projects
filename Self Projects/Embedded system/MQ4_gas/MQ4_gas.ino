#include <LiquidCrystal.h>

const int light = 13;        // LED pin
const int buzzr = 12;        // Buzzer pin
const int gasSensorPin = 34; // Analog pin (A2) on ESP32 DevKit V1
const int thresholdValue = 50; // Gas concentration threshold
const int rs=22,e=23,d4=5,d5=18,d6=19,d7=21;
LiquidCrystal lcd(rs, e, d4, d5, d6, d7);
void setup() {
  Serial.begin(115200);
  lcd.begin(16, 2); // Initialize the LCD with 16 columns and 2 rows
  pinMode(light, OUTPUT);
  pinMode(buzzr, OUTPUT);
  pinMode(gasSensorPin, INPUT);
  lcd.clear();
  // Initialize LEDC for controlling the buzzer
  ledcSetup(0, 2000, 8); // LEDC channel 0, 2000 Hz frequency, 8-bit resolution
  ledcAttachPin(buzzr, 0); // Attach LEDC channel 0 to the buzzer pin
}

void loop() {
  int gasConcentration = analogRead(gasSensorPin);
  Serial.println(gasConcentration);
  int value = map(gasConcentration,0,4095,0,200);
  Serial.println(value);
  if (value > thresholdValue) {
    lcd.setCursor(0,0);
    lcd.print("Gas detected!!");
    lcd.setCursor(0,1);
    lcd.print("Check it!!!");
    // If gas concentration exceeds the threshold, trigger the buzzer and LED
    ledcWrite(0, 255);  // Set the buzzer to maximum duty cycle (full volume)
    digitalWrite(light, HIGH); // Turn the LED on
    delay(1000); // Wait for 1000 milliseconds (1 second)
    ledcWrite(0, 0); // Turn off the buzzer
    digitalWrite(light, LOW); // Turn the LED off
    delay(1000);
  } else {
    lcd.setCursor(0,0);
    lcd.print("Gas disappered");
    lcd.setCursor(0,1);
    lcd.print("you are safe");
    // If gas concentration is below the threshold, keep the buzzer and LED off
    ledcWrite(0, 0); // Turn off the buzzer
    digitalWrite(light, LOW); // Turn the LED off
    delay(1000);
  }

  // Wait for a moment before reading the gas sensor again
  delay(500);
}

#include <LiquidCrystal.h>
#include <ESP32Servo.h>

#define IR_PIN 34
#define LDR_PIN 35
#define BUTTON_PIN 22
#define LED_PIN 23
#define BUZZER_PIN 25
#define SERVO_PIN 21

LiquidCrystal lcd(33, 32, 13, 12, 14, 27); // Modify pin numbers based on your LCD connection
Servo myservo;

void setup() {
  pinMode(IR_PIN, INPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  myservo.attach(SERVO_PIN);
  lcd.begin(16, 2); // Adjust the LCD dimensions (columns, rows) as per your display
  lcd.clear();
  Serial.begin(115200); // Initialize serial communication
}

void loop() {
  int IRValue = analogRead(IR_PIN);
  int ldrValue = analogRead(LDR_PIN);
  int ldrMap = map(ldrValue,0,4095,0,100);
  int IRMap = map(IRValue,0,4095,0,25);
  Serial.println(IRMap);
  Serial.println(ldrMap);
  int buttonState = digitalRead(BUTTON_PIN);
  Serial.println("Button state: ");
  Serial.println(buttonState); // Print button state to the serial monitor
  
  if (buttonState == LOW) {
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("IR: ");
    lcd.print(IRMap);
    lcd.setCursor(0, 1);
    lcd.print("LDR: ");
    lcd.print(ldrMap);
    delay(200);
  } else {
    for (int angle = 0;angle <= 180;angle++) {
      lcd.clear();
      Serial.println(angle);
      myservo.write(angle);
      lcd.setCursor(0, 0);
      lcd.print("Servo angle: ");
      lcd.setCursor(0,1);
      lcd.print(angle);
      lcd.print(" ");
      delay(20);
    }
    for (int angle = 180; angle >= 0; angle--) {
      lcd.clear();
      Serial.println(angle);
      myservo.write(angle);
      lcd.setCursor(0, 0);
      lcd.print("Servo angle: ");
      lcd.setCursor(0,1);
      lcd.print(angle);
      lcd.print(" ");
      delay(20);
    }
  }
  if (IRMap < 5) {
    digitalWrite(LED_PIN, HIGH);
    tone(BUZZER_PIN, HIGH);
  } else {
    digitalWrite(LED_PIN, LOW);
    noTone(BUZZER_PIN);
  }
  delay(200);
}
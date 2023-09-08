#include <ESP32Servo.h>

#define IR_PIN 32
#define SERVO_PIN 26

Servo doorServo;

void setup() {
  Serial.begin(115200);
  pinMode(IR_PIN, INPUT);
  doorServo.attach(SERVO_PIN);
  doorServo.write(0); // Start with the door closed
}

void loop() {
  int irValue = analogRead(IR_PIN);
  int pwmValue = map(irValue, 0, 4095, 0, 15);
  Serial.println(pwmValue);
  if (pwmValue < 5) { // If a person is detected
    doorServo.write(180); // Open the door
    delay(2000); // Wait for 2 seconds before checking again
  } else { // If no person is detected
    doorServo.write(0); // Close the door
    delay(2000); // Wait for 2 seconds before checking again
  }
}

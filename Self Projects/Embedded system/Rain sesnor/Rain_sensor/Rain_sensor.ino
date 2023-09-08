#include <Servo.h>

int rainSensorPin = 13;  // Pin connected to rain sensor module
int servoPin = 3;  // Pin connected to servo motor
int rainThreshold = 500;  // Set a threshold value for rain detection

Servo myservo;  // Create a servo object

void setup() {
  pinMode(rainSensorPin, INPUT);  // Set rain sensor pin as input
  myservo.attach(servoPin);  // Attach servo to its pin
}

void loop() {
  int rainValue = analogRead(rainSensorPin);  // Read the signal from rain sensor
  if (rainValue > rainThreshold) {  // If it's raining
    myservo.write(90);  // Open the servo to 90 degrees
    delay(1000);  // Wait for 1 second
    myservo.write(0);  // Close the servo
  }
}

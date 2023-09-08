  #include <ESP32Servo.h>
  
  // Define the pins for the keypad
  const byte ROWS = 4;
  const byte COLS = 4;
  char keys[ROWS][COLS] = {
    {'1', '2', '3', 'A'},
    {'4', '5', '6', 'B'},
    {'7', '8', '9', 'C'},
    {'*', '0', '#', 'D'}
  };
  byte rowPins[ROWS] = {23, 22, 21, 19};
  byte colPins[COLS] = {18, 5, 27, 14}; // Change these to match your ESP32 pins
  Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);
  
  // Define the pin for the myServo motor
  const int myServoPin = 26;
  Servo myServo;
  
  // Define the custom angle variable
  int customAngle;
  
  void setup() {
    Serial.begin(115200);
    myServo.attach(myServoPin);
    myServo.write(0); // Set the initial position to 0 degrees
    customAngle = 0; // Set default angle to 0 degrees
  }
  
  void loop() {
    // Read input from keypad
    char key = keypad.getKey();
    if (key != NO_KEY) {
      // Handle keypad input
      switch (key) {
        case '1':
          myServo.write(30); // Rotate to 30 degrees
          break;
        case '2':
          myServo.write(45); // Rotate to 45 degrees
          break;
        case '3':
          myServo.write(60); // Rotate to 60 degrees
          break;
        case '4':
          myServo.write(90); // Rotate to 90 degrees
          break;
        case '5':
          myServo.write(120); // Rotate to 120 degrees
          break;
        case '6':
          myServo.write(180); // Rotate to 180 degrees
          break;
        case '*':
          myServo.write(myServo.read()); // Stop the myServo motor at current position
          break;
        case '0':
          myServo.write(0); // Set the servo motor to 0 degrees
          break;
        case 'D':
          Serial.println("Enter custom angle (0-180 degrees):");
          if (Serial.available() > 0) {
            int parsed_value = Serial.parseInt();
            if (parsed_value > 0) {
              customAngle = parsed_value;
            }
            if (customAngle >= 0 && customAngle <= 180) {
              myServo.write(customAngle);
              Serial.println(customAngle);
            } else {
              Serial.println("Invalid angle. Please enter an angle between 0 and 180 degrees.");
            }
          }
          break;
      }
    }
  }

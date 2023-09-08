#include <Keypad.h>
#include <ESP32Servo.h>
#include <LiquidCrystal.h>

const String correctPassword = "1234"; // Define the correct password

// Define the keypad pins
const byte rows = 4;
const byte cols = 4;
char keys[rows][cols] = {
  {'1', '2', '3', 'A'},
  {'4', '5', '6', 'B'},
  {'7', '8', '9', 'C'},
  {'*', '0', '#', 'D'}
};
byte rowPins[rows] = {13, 12, 14, 27}; // Update these pin numbers for ESP32
byte colPins[cols] = {26, 25, 33, 32}; // Update these pin numbers for ESP32
Keypad keypad(makeKeymap(keys), rowPins, colPins, rows, cols);

// Define the servo motor pins
const int servoPin = 23; // Update this pin number for ESP32
Servo servo;

// Define the LDR and IR sensor pins
const int ldrPin = 34; // Update this pin number for ESP32
const int irPin = 35;  // Update this pin number for ESP32

boolean passwordVerified = false;

// Initialize the LCD
LiquidCrystal lcd(22, 21, 19, 18, 5, 4); // RS, E, D4, D5, D6, D7

void setup() {
  Serial.begin(115200);
  lcd.begin(16, 2);  // Initialize the LCD with 16 columns and 2 rows
  lcd.setCursor(0,0);
  lcd.print("Press \"*\""); // Display initial message on LCD
  lcd.setCursor(0,1);
  lcd.print("To start:"); // Display initial message on LCD
  servo.attach(servoPin);
  pinMode(ldrPin, INPUT);
  pinMode(irPin, INPUT);
}

void loop() {
  // Check if the password has been verified
  if (!passwordVerified) {
    char key = keypad.getKey();
    if (key) {
      static String enteredPassword;
      if (key == '*') {
        enteredPassword = "";
        lcd.clear();
        lcd.print("Enter Password:");
      } else if (key == '#') {
        if (enteredPassword == correctPassword) {
          passwordVerified = true;
          lcd.clear();
          lcd.print("Password Correct");
          lcd.setCursor(0, 1);
          lcd.print("Access Granted.");
          // Open the door
          servo.write(180);
          delay(5000); // Delay for 5 seconds (adjust as needed)
          servo.write(0); // Close the door
          lcd.clear();
          lcd.print("Door Closed.");
        } else {
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("Password");
          lcd.setCursor(0,1);
          lcd.print("Incorrect.");
          delay(2000);
          lcd.clear();
          lcd.print("Enter Password:");
          enteredPassword = "";
        }
      } else {
        enteredPassword += key;
        lcd.setCursor(enteredPassword.length(),1);
        lcd.print("*");
      }
    }
  } else {
    // Display the LDR and IR sensor readings for authorized users
    int ldrReading = analogRead(ldrPin);
    int ldr_Value = map(ldrReading, 0, 4095, 0, 100);
    lcd.clear();
    lcd.print("LDR: ");
    lcd.print(ldr_Value); // Assuming LDR is mapped to 0-100
    lcd.print(" Lux"); // Display Lux unit

    int irReading = analogRead(irPin);
    int Ir_Value = map(irReading, 0, 4095, 0
    , 25);
    lcd.setCursor(0, 1);
    lcd.print("IR: ");
    lcd.print(Ir_Value); // Assuming IR reading in raw analog value
    lcd.print(" CM"); // Display CM unit
    delay(1000);
  }
}

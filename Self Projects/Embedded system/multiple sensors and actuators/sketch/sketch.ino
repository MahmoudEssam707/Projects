#include <LiquidCrystal.h>
#include <ESP32Servo.h>
#include <Keypad.h>

const int rs = 22, en = 21, d4 = 19, d5 = 18, d6 = 5, d7 = 4;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

const int Buzzer_Pin = 18;
const int IR_PIN = 35;
const int LED_PIN = 12;
const int Button_Pin = 13;
const int Photoresistor_Pin = 34;
const int thresholdValue = 35; // Adjust this value based on your LDR sensor reading
Servo myServo;

// Keypad configuration
const byte ROW_NUM = 4; // four rows
const byte COLUMN_NUM = 3; // three columns
char keys[ROW_NUM][COLUMN_NUM] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};
byte pin_rows[ROW_NUM] = {32,13,14,27};
byte pin_column[COLUMN_NUM] = {26,25,33};

Keypad key = Keypad(makeKeymap(keys), pin_rows, pin_column, ROW_NUM, COLUMN_NUM);

// Variables to store state and password
int mode = 0;
bool doorLocked = true;
const int passwordLength = 4; // Change this to your desired password length
const char correctPassword[] = "1234"; // Change this to your desired password

// Add a global flag to indicate if '*' button was pressed during password entry
bool backToMain = false;

void setup() {
  Serial.begin(115200);
  lcd.begin(16, 2);
  pinMode(Buzzer_Pin, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
  pinMode(Button_Pin, INPUT_PULLUP);
  pinMode(IR_PIN, INPUT);
  pinMode(Photoresistor_Pin, INPUT);
  myServo.attach(23);

  lcd.print("Press a key...");
}

void loop() {
  char keyPress = key.getKey();
  if (keyPress) {
    // Handle the keypress
    handleKeyPress(keyPress);
  }

  // Perform different actions based on the selected mode
  switch (mode) {
    case 1:
      // Mode 1: Read and display sensor readings
      readAndDisplaySensors();
      break;
    case 2:
      // Mode 2: Servo scanning motion
      performServoScanning();
      break;
    case 3:
      // Mode 3: Password entry
      handlePasswordEntry();
      break;
    case 4:
      // Mode 4: Smart door functionality
      smartDoorFunctionality();
      break;
    default:
      // Handle invalid mode
      break;
  }
}

void handleKeyPress(char keyPress) {
  if (backToMain && keyPress != '*') {
    // If '*' button was pressed and the next keypress is not '*', reset the flag
    backToMain = false;
  }
  if (keyPress == '*') {
    if (backToMain) {
      // Go back to the main page and choose from other cases
      mode = 0;
      lcd.clear();
      lcd.print("Press a key...");
      delay(500);
      lcd.clear();
      return;
    } else {
      // Set the flag to indicate '*' button was pressed during password entry
      backToMain = true;
    }
  }

  // Convert the character to an integer
  int selectedMode = keyPress - '0';

  // Check if the selected mode is within the valid range (1 to 4)
  if (selectedMode >= 1 && selectedMode <= 4) {
    mode = selectedMode;
    lcd.clear();
    lcd.print("Mode ");
    lcd.print(mode);
    lcd.print(" selected");
    delay(500);
    lcd.clear();
  } else {
    // Invalid mode selected, display an error message
    lcd.clear();
    lcd.print("Invalid mode!");
    delay(1000);
    lcd.clear();
  }
}

void readAndDisplaySensors() {
  // Read sensor values
  int irSensorValue = analogRead(IR_PIN);
  int ldrSensorValue = analogRead(Photoresistor_Pin);
  int irSensorMap = map(irSensorValue, 0, 4095, 0, 25);
  int ldrSensorMap = map(ldrSensorValue, 0, 4095, 0, 100);
  
  // Display sensor readings on the LCD
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("IR: ");
  lcd.print(irSensorMap);
  lcd.setCursor(0, 1);
  lcd.print("LDR: ");
  lcd.print(ldrSensorMap);
  if(ldrSensorMap<thresholdValue){
    digitalWrite(LED_PIN,HIGH);
  }else{
    digitalWrite(LED_PIN,LOW);
  }
  delay(200);
}

void performServoScanning() {
  // Perform smooth scanning motion of the servo motor
  for (int angle = 0; angle <= 180; angle++) {
    myServo.write(angle);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Servo Angle");
    lcd.setCursor(0,1);
    lcd.print(angle);
    // Add a delay for smoother scanning motion
    delay(100);
  }
  for (int angle = 180; angle >= 0; angle--) {
    myServo.write(angle);
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print("Servo Angle");
    lcd.setCursor(0,1);
    lcd.print(angle);  
     
    // Add a delay for smoother scanning motion
    delay(100);
  }
}

void handlePasswordEntry() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Enter password:");

  char enteredPassword[passwordLength + 1];
  int index = 0;

  while (index < passwordLength) {
    char keyPress = key.getKey();
    if (keyPress == '*') {
      // Go back to the main page and choose from other cases
      mode = 0;
      lcd.clear();
      lcd.print("Press a key...");
      delay(1000);
      lcd.clear();
      return;
    }
    if (keyPress) {
      lcd.setCursor(index, 1);
      lcd.print("*");
      enteredPassword[index] = keyPress;
      index++;
      delay(200);
    }
  }
  enteredPassword[passwordLength] = '\0';

  if (strcmp(enteredPassword, correctPassword) == 0) {
    lcd.clear();
    lcd.print("Correct Password");
    myServo.write(180); // Unlock the servo motor
  } else {
    lcd.clear();
    lcd.print("Incorrect Password");
    myServo.write(0);
  }
  delay(1000);
  lcd.clear();
}

void smartDoorFunctionality() {
  int irSensorValue = analogRead(IR_PIN);
  int irSensorMap = map(irSensorValue, 0, 4095, 0, 25);
  if (irSensorMap < 5) {
    // Object detected, open the door
    myServo.write(180); // Unlock the servo motor
    lcd.clear();
    lcd.print("Door Opened");
    delay(500);
    lcd.clear();
    Serial.println(irSensorMap);
  } else {
    // No movement detected, close the door
    myServo.write(0); // Lock the servo motor
  }
}

#include <ESP32Servo.h>

int IR = 25;
int LED = 26;
int SERVO_DOOR = 19;
int SERVO_WINDOW = 18;
int buzzr = 27;
int pot = 34;
int ldr = 35;
int resetBtn = 32;
Servo doorServo; // Create a servo object for the door
Servo windowServo; // Create a servo object for the window
bool resetButtonPressed = false;

void setup()
{  
  Serial.begin(115200);
  pinMode(IR, INPUT);
  pinMode(LED, OUTPUT);
  pinMode(buzzr, OUTPUT);
  doorServo.attach(SERVO_DOOR); // Attach the door servo to pin 19
  windowServo.attach(SERVO_WINDOW); // Attach the window servo to pin 18
  pinMode(resetBtn, INPUT_PULLUP); // Setup reset push button as an input with internal pull-up resistor
}

void loop()
{
  int btn_value = digitalRead(resetBtn);
  Serial.println(btn_value);
  if (btn_value == 0 && !resetButtonPressed) { // If the reset push button is pressed
    resetButtonPressed = true; // Set the reset button flag
    doorServo.write(0); // Set the door servo back to 0 degrees
    windowServo.write(0); // Set the window servo back to 0 degrees
    digitalWrite(LED, LOW); // Turn off the LED
    digitalWrite(buzzr, LOW); // Turn off the buzzer
    delay(50000); // Wait for 5 seconds for actions to complete
    Serial.println("System reset complete"); // Print message to Serial monitor
  }
  else if (btn_value == 1 && resetButtonPressed) { // If the reset push button is released
    resetButtonPressed = false; // Reset the reset button flag
  }
  else { // Normal operation
    int value_of_ir = digitalRead(IR);
    Serial.println(value_of_ir);
    if (value_of_ir == 0) {
      digitalWrite(LED, HIGH); // Turn on the LED
      doorServo.write(180); // Turn the door servo to 180 degrees
      digitalWrite(buzzr, HIGH); // Turn on the buzzer
      delay(500); // Wait for 0.5 seconds for the door servo to move and the buzzer to sound
    } else {
      digitalWrite(LED, LOW); // Turn off the LED
      doorServo.write(0); // Turn the door servo back to 0 degrees
      digitalWrite(buzzr, LOW); // Turn off the buzzer
    }
    
    int ldrValue = analogRead(ldr); // Read the analog value from the LDR
    Serial.println("LDR " + String(ldrValue));
    int potValue = analogRead(pot); // Read the analog value from the potentiometer
    int windowAngleManual = map(potValue, 0, 4095, 0, 180); // Map the potentiometer value to the servo angle range
    Serial.println("Value of Pot " + String(potValue));   
    Serial.println("Value of Window " + String(windowAngleManual));   
    if (ldrValue > 1500) {
      windowServo.write(0); // Set the window servo angle based on the LDR value
    } else {
      windowServo.write(windowAngleManual); // Set the window servo angle based on the potentiometer value
    }
  }
}

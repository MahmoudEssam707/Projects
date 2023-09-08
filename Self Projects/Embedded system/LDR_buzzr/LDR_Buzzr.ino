#define LDR_PIN 34   // GPIO 34 for the LDR input
#define BUZZER_PIN 13 // Use GPIO 5 for the buzzer output
#define LED_PIN 12    // Use GPIO 2 for the LED output

int threshold = 500; // adjust this value to set the threshold
bool alarmState = false;

void setup() {
  Serial.begin(115200);
  pinMode(LDR_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  int lightLevel = analogRead(LDR_PIN);
  if (lightLevel < threshold && !alarmState) {
    alarmState = true;
    digitalWrite(BUZZER_PIN, HIGH); // turn on buzzer
    Serial.println("ALARM: Light level is below threshold!");
  } else if (lightLevel >= threshold && alarmState) {
    alarmState = false;
    digitalWrite(BUZZER_PIN, LOW); // turn off buzzer
    Serial.println("ALARM CLEARED: Light level is above threshold.");
  }
  
  if (alarmState) {
    digitalWrite(LED_PIN, HIGH); // turn on LED
    delay(100); // wait for 500 milliseconds
    digitalWrite(LED_PIN, LOW); // turn off LED
    delay(100); // wait for 500 milliseconds
  } else {
    digitalWrite(LED_PIN, LOW); // turn off LED
  }
}

#define LED_PIN 18
#define BUTTON_PIN 5

void setup() {
  Serial.begin(115200); 
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUTTON_PIN, INPUT_PULLUP);  
}

void loop() {

  int buttonvalue = digitalRead(BUTTON_PIN); 
  if (buttonvalue ==  HIGH) {
    Serial.println("Button is not pressed"); 
    Serial.println(buttonvalue); 
    digitalWrite(LED_PIN, LOW);
  }
  else {
    digitalWrite(LED_PIN, HIGH);
    Serial.println("Button is pressed"); 
    Serial.println(buttonvalue); 
  }
}

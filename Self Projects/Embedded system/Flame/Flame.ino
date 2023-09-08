const int temperaturePin = 34;
int buzzer = 12;
int led = 13;

void setup() {
  pinMode(buzzer, OUTPUT);
  pinMode(led, OUTPUT);
  Serial.begin(115200);
}

void loop() {
  int rawValue = analogRead(temperaturePin); // Read the raw analog value from the temperature sensor
  float voltage = map(rawValue, 0, 4095, 0, 3300) / 1000.0; // Convert the raw analog value to voltage
  float degreesC = (voltage - 0.5) * 100.0; // Calculate the temperature in degrees Celsius
  Serial.println(degreesC);

  if (degreesC < 0) {
    // Assuming fire detected if the temperature is above 50 degrees Celsius
    digitalWrite(buzzer, HIGH);
    digitalWrite(led, HIGH);
    tone(buzzer,500,100);
  } else {
    digitalWrite(buzzer, LOW);
    digitalWrite(led, LOW);
  }

  delay(101); // Add a small delay to avoid rapid toggling of the buzzer and LED.
}

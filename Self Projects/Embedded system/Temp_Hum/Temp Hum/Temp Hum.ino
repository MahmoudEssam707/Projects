#include "DHT.h"

#define DHTPIN 21     // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321
#define LED_PIN 5
#define BUZZR_PIN 4

DHT dht(DHTPIN, DHTTYPE);

const int threshold_c = 60;
const int threshold_h = 60;

void setup() {
  Serial.begin(9600);
  pinMode(LED_PIN, OUTPUT);
  pinMode(BUZZR_PIN, OUTPUT);
  Serial.println("DHTxx test!");

  // Initialize LEDC channel 0 for the LED
  ledcSetup(0, 5000, 8); // Initialize LEDC channel 0 with a frequency of 5000 Hz and 8-bit resolution
  ledcAttachPin(LED_PIN, 0); // Attach LEDC channel 0 to the LED pin

  // Initialize LEDC channel 1 for the buzzer
  ledcSetup(1, 5000, 8); // Initialize LEDC channel 1 with a frequency of 5000 Hz and 8-bit resolution
  ledcAttachPin(BUZZR_PIN, 1); // Attach LEDC channel 1 to the buzzer pin
  
  dht.begin();
}

void loop() {
  // Read humidity and temperature from the sensor
  float h = dht.readHumidity();
  float t = dht.readTemperature();

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  // Check if temperature or humidity exceeds the thresholds
  if (t >= threshold_c || h >= threshold_h) {
    // Set the LED and buzzer to on
    ledcWrite(0, 255); // Set the duty cycle of LEDC channel 0 to 100%
    ledcWrite(1, 128); // Set the duty cycle of LEDC channel 1 to 50%
    delay(500);
  } else {
    // Set the LED and buzzer to off
    ledcWrite(0, 0); // Set the duty cycle of LEDC channel 0 to 0%
    ledcWrite(1, 0); // Set the duty cycle of LEDC channel 1 to 0%
    delay(500);
  }

  // Print humidity and temperature
  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print("%  Temperature: ");
  Serial.print(t);
  Serial.println("°C");
  delay(1000);
}

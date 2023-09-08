// Needed Libraries
// Wires for I2C
#include <Wire.h>
// Wifi for ESP
#include <WiFi.h>
// Needed Firebase Functions
#include <Firebase_ESP_Client.h>
// Moving Door
#include <ESP32Servo.h>
// Keypad
#include <Keypad.h>
// LCD
#include <LiquidCrystal_I2C.h>
// Provide the token generation process info.
#include "addons/TokenHelper.h"
// Provide the RTDB payload printing info and other helper functions.
#include "addons/RTDBHelper.h"
/*                            FireBase                             */
////////////////////////////////////////////////////////////////////
/* 1. Define the API Key */
#define API_KEY "AIzaSyDADshUI7Rjw6jynScYy5-6RYRgbZrs9mk"
/* 2. Define the RTDB URL */
#define DATABASE_URL "https://fir-visualstudio-d089e-default-rtdb.firebaseio.com/"
/* 3. Define Wifi for Esp Connection */
#define WIFI_SSID "MEMO"
#define WIFI_PASSWORD "FCbarcelona2009"
/* All Needed Packges for making Connection with Firebase*/
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
/* Storing User ID*/
String uid;
// Database main path (to be updated in setup with the user UID)
String databasePath;
// Database child nodes
String GasPath = "/Gas";
String FlamePath = "/Flame";
String WaterPath = "/Water";
String MotionPath = "/Motion";
String DoorPath = "/Door/door_angle";
// Declare Needed Values
int gasValue;
int gasValuePercents;
int flameValue;
int flameValuePercents; 
int waterValue;
int waterValuePercents; 
int MotionValue;
////////////////////////////////////////////////////////////////////
// Servo connection
#define SERVO 23
    Servo Door;
// Gas connection
#define Gas 34
// Pir motion Connection
#define PIR_MOTION 18
// Flame Sensor Connection
#define Flame_Sensor 35
// Water Sensor Connection
#define Water_Sensor 32
// Buzzr Connection
#define Buzzr 19
// Keypad Connection
const byte ROWS = 4;
const byte COLS = 3;
char keys[ROWS][COLS] = {
    {'1', '2', '3'},
    {'4', '5', '6'},
    {'7', '8', '9'},
    {'*', '0', '#'}};
byte rowPins[ROWS] = {13, 12, 14, 27}; // Change these pins to match your wiring
byte colPins[COLS] = {26,25,33}; // Change these pins to match your wiring
Keypad keypad = Keypad(makeKeymap(keys), rowPins, colPins, ROWS, COLS);
// LCD Connection
LiquidCrystal_I2C lcd(0x27, 16, 2);
unsigned long sendDataPrevMillis = 0;
/*Defining Keypad Password Giving*/
String readKeypadInput()
{
  String password = "";
  lcd.setCursor(0, 0);
  lcd.print("Enter password:");
  lcd.setCursor(0, 1);
  char key = keypad.getKey();

  while (key != '#')
  {
    if (key != NO_KEY)
    {
      password += key;
      Serial.print(key);
      lcd.print("*");
    }
    key = keypad.getKey(); // Read the keypad input inside the loop
  }
  return password;
}
void setup()
{
  // Starting Serial
  Serial.begin(115200);
  // Initializing LCD 
  lcd.init();
  // Starting lighting of backlight lcd
  lcd.backlight();
  // getting Water reads
  pinMode(Water_Sensor,INPUT);
  // starting buzzr sound
  pinMode(Buzzr,OUTPUT);
  // Getting Pir Reads
  pinMode(PIR_MOTION, INPUT);
  // Getting Gas Reads
  pinMode(Gas, INPUT);
  // Getting Flame Reads
  pinMode(Flame_Sensor, INPUT);
  // Starting Servo
  Door.attach(SERVO);
  /*                !!WIFI!!                */
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED) {
    delay(300);
  }
  ////////////////////////////////////////////
  /*Auth System*/
  auth.user.email = "mahmoudessam@gmail.com";
  auth.user.password = readKeypadInput();
  ////////////////////////////////////////////
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Loading...");
  /*Configurations For Api and Database*/
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;
  ////////////////////////////////////////////
  /*Some Checks*/
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  ////////////////////////////////////////////
  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);
  /*Start Action*/
  Firebase.begin(&config, &auth);
  ////////////////////////////////////////////
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Hello Sir!");
  Door.write(130);
  delay(2000);
  Door.write(172);
  ////////////////////////////////////////////
  uid = auth.token.uid.c_str();
  databasePath = "UsersData/" + uid + "/Sensors";
}
void loop()
{
  if (millis() - sendDataPrevMillis > 2000 && Firebase.ready())
  {
    sendDataPrevMillis = millis();
    // Storing Gas values
     gasValue = analogRead(Gas);
    // Converting it to 0 to 100 Values
     gasValuePercents = map(gasValue, 0, 4095, 0, 100);
    // Storing Flame values
     flameValue = analogRead(Flame_Sensor);
    // Converting it to 0 to 100 Values
     flameValuePercents = map(flameValue, 0, 4095, 0, 100);
    // Storing Water values
     waterValue = analogRead(Water_Sensor);
    // Converting it to 0 to 100 Values
     waterValuePercents = map(waterValue, 0, 4095, 0, 100);
    // Storing Motion values
     MotionValue = digitalRead(PIR_MOTION);
    /*Let's Store All this Values First in Firebase!*/
    // Controlling Door
    Firebase.RTDB.getInt(&fbdo, databasePath + DoorPath);
    int DoorReads = fbdo.intData();
    Door.write(DoorReads);
    // Storing Flame Reads
    if (flameValuePercents < 30 || gasValuePercents > 50 || waterValuePercents > 50)
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.println("Trouble in Home!!");
      lcd.setCursor(0,1);
      lcd.println("Check your Phone!!");
      digitalWrite(Buzzr, HIGH);
    }
    else
    {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("  you are safe");
      digitalWrite(Buzzr, LOW);
    }
    bool flameStored = Firebase.RTDB.setInt(&fbdo, databasePath + FlamePath, flameValuePercents);
     if (flameStored)
     {
      Serial.println("Flame data sent successfully.");
    }
    else
    {
      Serial.println("Failed to send Flame data.");
    }
    // Storing Gas Reads
    bool gasStored = Firebase.RTDB.setInt(&fbdo, databasePath + GasPath, gasValuePercents);
    if (gasStored)
    {
      Serial.println("Gas data sent successfully.");
    }
    else
    {
      Serial.println("Failed to send Gas data.");
    }

    // Storing Water Reads
    bool waterStored = Firebase.RTDB.setInt(&fbdo, databasePath + WaterPath, waterValuePercents);
    if (waterStored)
    {
      Serial.println("Water data sent successfully.");
    }
    else
    {
      Serial.println("Failed to send Water data.");
    }
    // Storing Motion Reads
    bool motionStored = Firebase.RTDB.setInt(&fbdo, databasePath + MotionPath, MotionValue);
    if (motionStored)
    {
      Serial.println("Motion data sent successfully.");
    }
    else
    {
      Serial.println("Failed to send Motion data.");
    }
  }
}
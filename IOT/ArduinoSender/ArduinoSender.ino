#include <SoftwareSerial.h>

// Define pins for software serial communication
#define ARDUINO_TX_PIN 6
#define ARDUINO_RX_PIN 5

SoftwareSerial espSerial(ARDUINO_TX_PIN, ARDUINO_RX_PIN);  // RX, TX

void setup() {
  // Set baud rate (ensure consistency with NodeMCU)
  espSerial.begin(9600);

  // Begin hardware serial communication for debugging (optional)
  Serial.begin(9600);
  Serial.println("Arduino ready!");
}

void loop() {
  // Sample data to send (replace with your actual sensor data or message)
  int sensorValue = analogRead(A0);

  // Send data as a string for easier interpretation (optional)
  String dataToSend = String(sensorValue);

  espSerial.println(dataToSend);

  // Optional: Add a delay to prevent overwhelming the receiver
  delay(1000);
}
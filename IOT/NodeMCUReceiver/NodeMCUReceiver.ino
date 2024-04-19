#include <SoftwareSerial.h>

// Define pins for software serial communication
#define NODEMCU_TX_PIN D6
#define NODEMCU_RX_PIN D5

SoftwareSerial espSerial(NODEMCU_RX_PIN, NODEMCU_TX_PIN);  // RX, TX

void setup() {
  // Set baud rate (ensure consistency with Arduino)
  espSerial.begin(9600);

  // Begin hardware serial communication for debugging (optional)
  Serial.begin(9600);
  Serial.println("NodeMCU ready!");
}

void loop() {
  if (espSerial.available() > 0) {
    // Read data as a string (modify if sending numerical data directly)
    String data = espSerial.readStringUntil('\n');

    // Print the received data on the serial monitor
    Serial.println(data);

    // Optional: Process the received data (e.g., display on an LCD, send to cloud)
    // ...
  }
}
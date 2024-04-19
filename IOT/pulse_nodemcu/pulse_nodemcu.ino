#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

const char* ssid = "YourWiFiSSID";
const char* password = "YourWiFiPassword";

ESP8266WebServer server(80);

void setup() {
  Serial.begin(9600);
  delay(10);

  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);

  Serial.println();
  Serial.println("Connecting to WiFi...");

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);

  server.begin();
  Serial.println("HTTP server started");

  handleRoot();
}

void loop() {
  server.handleClient();

  // Read data from Arduino via Serial
  while (Serial.available() > 0) {
    char receivedChar = Serial.read();
    Serial.print(receivedChar);
  }
}

void handleRoot() {
  String heartRate = "Heart rate: 80 bpm";
  String spo2 = "SpO2: 98%";

  server.send(200, "text/plain", heartRate + "\n" + spo2);
}

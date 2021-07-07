
#include "FirebaseESP8266.h"  // Arduino IDE uzerinden library sekmesinden "Firebase ESP8266" isimli kutuphane yuklenecek
#include <ESP8266WiFi.h> // ESP



#define FIREBASE_HOST "************" *
#define FIREBASE_AUTH "***************"
#define WIFI_SSID "*************"
#define WIFI_PASSWORD "*****************"

#define DHTPIN 2    // Connect Data pin of DHT to D2
int led = 2;     // Connect LED to D5

#define DHTTYPE    DHT11
//DHT dht(DHTPIN, DHTTYPE);

//Define FirebaseESP8266 data object
FirebaseData firebaseData;
FirebaseData ledData;

FirebaseJson json;


void setup()
{

  Serial.begin(115200);

  //dht.begin();
  pinMode(led,OUTPUT);
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);

}


void loop() {

Firebase.getString(ledData, "/led/led");
  if(ledData.stringData()!="0"){
  digitalWrite(LED_BUILTIN, LOW);
  }
  else{
  digitalWrite(LED_BUILTIN, HIGH);
  }
    Serial.println(ledData.stringData());
    delay(200);
  


}

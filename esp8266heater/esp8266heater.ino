#include <DHT.h>
#include <Ticker.h>
#include <AntoIO.h>
#define DHTPIN D2
#define heaterPin D3
#define fanPin D4
Ticker heaterTimer;
Ticker fanStopTimer;
Ticker fanStartTimer;
const char *ssid = "NT_Prof_2.4GHz";  // Your Wi-Fi SSID
const char *password = "0902323979";
const char *ssid1 = "NT-WAT@2.4G";  // Your Wi-Fi SSID
const char *password1 = "saiwat030766";
const char *user = "Dryer_smart09";
const char *token = "u6xuDlZyHCPHLDwRKhpOZA8SnZOjps0KMI51krgc";
const char *thing = "DHTTest";
static bool emergencyShutdown = false;
String workingState = "DOWN";
void messageReceived(String thing, String channel, String payload) {
  if (channel.equals("State")) {
    String data = payload;
    if (!emergencyShutdown && data != workingState) {
      workingState = data;
      heaterState(data);
    }
  }
}
int fanwillstart = 120;
int fanwillstop = 60;
// การตั้งค่า DHT21
// การตั้งค่าเซิร์ฟเวอร์
//const char* serverName = "(link unavailable)"; // เปลี่ยนเป็น URL ของเซิร์ฟเวอร์

AntoIO anto(user, token, thing);
DHT dht;
void setup() {
  Serial.begin(9600);
  pinMode(heaterPin, OUTPUT);
  pinMode(fanPin, OUTPUT);
  dht.setup(DHTPIN, DHT::DHT22);
  digitalWrite(heaterPin, HIGH);
  digitalWrite(fanPin, HIGH);
  // WiFi.begin(ssid, password);
  // while (WiFi.status() != WL_CONNECTED) {
  //   delay(1000);
  //   Serial.println("กำลังเชื่อมต่อ WiFi...");
  // }
  // Serial.println("เชื่อมต่อ WiFi สำเร็จ");
  // delay(10);
  // Serial.println();
  // Serial.println();
  // Serial.print("Anto library version: ");
  // Serial.println(anto.getVersion());
  // Serial.print("\nTrying to connect ");
  // Serial.print(ssid);
  // // Serial.println("...");
  // anto.begin(ssid, password, messageReceived);
  anto.begin(ssid1, password1, messageReceived);
  anto.sub("State");
  Serial.println("\nConnected Anto done");
}

int maxTemp = 30;
int minTemp = 20;
String state = "DOWN";
void loop() {
  anto.mqtt.loop();
  if (!anto.mqtt.isConnected())
    Serial.println("Disconnected");
  DHTFUNC();
}
float h = 0;
float t = 0;
bool stoped = true;
int timework = 0;
void DHTFUNC() {
  delay(dht.getMinimumSamplingPeriod());
  h = dht.getHumidity();
  t = dht.getTemperature();
  if (isnan(h) || isnan(t)) {
    Serial.println("การอ่านค่าล้มเหลว!");
    Serial.print(dht.getHumidity());
    Serial.print("\t");
    Serial.print(dht.getTemperature());
    Serial.println();
    digitalWrite(heaterPin, HIGH);
    emergencyShutdown = true;
  } else {
    if (t >= 75) {
      Serial.println("[EMERGENCY] Overheat detected! Turning off heater.");
      digitalWrite(heaterPin, HIGH);
      digitalWrite(fanPin, LOW);
      emergencyShutdown = true;
    }
    if (emergencyShutdown && t < 50) {
      Serial.println("[RESET] Temperature is safe again. Heater can be re-enabled.");
      emergencyShutdown = false;
    }
    if (emergencyShutdown) {
      digitalWrite(heaterPin, HIGH);
      fanStopTimer.detach();
    } else {
      if (!stoped) {
        if (t >= maxTemp + 1) {
          digitalWrite(heaterPin, HIGH);
        } else {
          if (t <= maxTemp - 1) {
            digitalWrite(heaterPin, LOW);
          }
        }
      }
    }
    if (t > 30 && stoped) {
      digitalWrite(fanPin, LOW);
    }
    Serial.print("ความชื้น: ");
    Serial.print(h);
    Serial.println(" %");
    Serial.print("อุณหภูมิ: ");
    Serial.print(t);
    Serial.println(" °C");
    anto.pub("DHT21", h);
    anto.pub("test", t);
  }
}

void heaterState(String state) {
  stoped = false;
  if (state == "DOWN") {
    digitalWrite(heaterPin, HIGH);
    maxTemp = 0;
    heaterTimer.detach();  // Stop heater timer if any
  } else {
    digitalWrite(fanPin, LOW);
    digitalWrite(heaterPin, LOW);
    if (state == "LOW") {
      maxTemp = 45;
      minTemp = 40;
      timework = 1200;  // 20 minutes
    } else if (state == "MEDIUM") {
      maxTemp = 60;
      minTemp = 45;
      timework = 1500;  // 25 minutes
    } else if (state == "HIGH") {
      maxTemp = 70;
      minTemp = 60;
      timework = 2400;  // 40 minutes
    }
  }
  heaterTimer.attach(timework, stopHeater);
  fanStopTimer.attach(fanwillstop, stopFan);
  Serial.println(state);
}
void stopHeater() {
  Serial.println("[TIMER] Heater turned off after preset duration.");
  digitalWrite(heaterPin, HIGH);  // Ensure relay turns heater OFF
  stoped = true;
  heaterTimer.detach();
  fanStartTimer.detach();
  fanStartTimer.detach();
  anto.pub("State", "DOWN");
}

void stopFan() {
  Serial.println("[TIMER] Fan turned off after preset duration.");
  if (t < maxTemp) {
    digitalWrite(fanPin, HIGH);  // Ensure relay turns heater OFF
  }

  fanStartTimer.attach(fanwillstart, startFan);
  fanStopTimer.detach();
}
void startFan() {
  Serial.println("[TIMER] Fan turned Start after preset duration.");
  digitalWrite(fanPin, LOW);  // Ensure relay turns heater OFF
  fanStartTimer.detach();
  fanStopTimer.attach(fanwillstop, stopFan);
}
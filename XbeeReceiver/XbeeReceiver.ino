#include<SoftwareSerial.h>

const int RX_PIN = 8;
const int TX_PIN = 9;

SoftwareSerial xbee(RX_PIN, TX_PIN);

void setup() {
  Serial.begin(115200);

  pinMode(RX_PIN, INPUT);
  pinMode(TX_PIN, OUTPUT);

  xbee.begin(9600);
}

byte buf[7];

int x, y;

void loop() {

  if (xbee.available() >= 9) {
    if (xbee.read() == 'H') {
      for (int i = 0; i < 8; i++)
        buf[i] = xbee.read();
    }
  }

  //  for (int i = 0; i < 8; i++) {
  //    Serial.print(buf[i]); Serial.print("\t");
  //  }
  //  Serial.println();

  Serial.write('H');
  Serial.write(buf, 8);
}

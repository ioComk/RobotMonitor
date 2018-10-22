#include <SoftwareSerial.h>
#include<Wire.h>

#include"loop_cycle_controller.h"
#include"xbee_sender.h"

LoopCycleController cycle(150000);

const int I2C_ADDR = 51;

const int RXPIN = 8;
const int TXPIN = 9;

const int DATA_SIZE = 7;

const int BAUDRATE = 9600;

XbeeSender xbee(RXPIN, TXPIN, DATA_SIZE, BAUDRATE);

byte buf[DATA_SIZE];

void setup() {
  Wire.begin(I2C_ADDR);
  Wire.onReceive(receiveEvent);

  Serial.begin(115200);
}

void loop() {

  xbee.sendToXbee(buf);

  cycle.update();
}

void receiveEvent(int any)
{
  while (Wire.available() >= DATA_SIZE)
  {
    for (int i = 0; i < DATA_SIZE; i++)
      buf[i] = Wire.read();
  }
}

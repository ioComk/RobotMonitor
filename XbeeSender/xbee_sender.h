/*
    @program xbeeのcoordinatorにデータを送信するプログラム
    @date 2018/10/12
    @author Watanabe Rui
*/

#pragma once
#include<SoftwareSerial.h>

class XbeeSender {

  private:

    SoftwareSerial serial;

    int arraySize;

  public:

    /*
        constructor
        @param [int] rx：arduinoのRXピン
        @param [int] tx：arduinoのTXピン
        @param [int] dataSize：送るデータの数
        @param [long] baudrate：xbeeのボーレート
    */
    XbeeSender(int rx, int tx, int dataSize, long baudrate): serial(rx, tx), arraySize(dataSize)
    {
      serial.begin(baudrate);

      pinMode(rx, INPUT);
      pinMode(tx, OUTPUT);
    }

    /*
        Xbeeにデータを送信
        @param @param [byte] data[]：送信するデータ
    */
    void sendToXbee(byte data[])
    {
      serial.write('H');  //ヘッダを送信

      for (int i = 0; i < arraySize; i++)
        serial.write(data[i]);
    }
};

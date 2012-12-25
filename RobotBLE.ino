
#include <SPI.h>
#include <ble.h>
#include <Servo.h> 
 
#define BUZZER_PIN 4
#define SERVO_LEFT_PIN 7
#define SERVO_RIGHT_PIN 6

Servo servoLeft;
Servo servoRight;

unsigned long musicStarted = 0;
int throttle = 0;
int dir = 0;

void setup()
{
  SPI.setDataMode(SPI_MODE0);
  SPI.setBitOrder(LSBFIRST);
  SPI.setClockDivider(SPI_CLOCK_DIV16);
  SPI.begin();

  ble_begin();
  
  servoLeft.attach(SERVO_LEFT_PIN);
  servoRight.attach(SERVO_RIGHT_PIN);
}

void loop()
{
  if (!ble_connected()) {
    servoLeft.writeMicroseconds(1500);
    servoRight.writeMicroseconds(1500);  
  }
  
  // If data is ready
  while(ble_available())
  {
    int dataChanged = false;
    
    // read out command and data
    byte data0 = ble_read();
    byte data1 = ble_read();
    byte data2 = ble_read();
    
    if (data0 == 0x01)  // Throttle control
    {
      throttle = (signed char)data1;
      dataChanged = true;
    }
    else if (data0 == 0x02) // Direction control
    {
      dir = (signed char)data1;
      dataChanged = true;
    }
    else if (data0 == 0x03) // Charge!
    {
      musicStarted = millis();
    }
    
    if (dataChanged) {
      int rawDifference = (1600.0 - 1500.0) * throttle / 129.0;
      int servoLeftSetting;
      int servoRightSetting;
      if (dir >= 0) {
        servoLeftSetting = 1500 + rawDifference;
        servoRightSetting = 1500 - rawDifference + 2.0 * rawDifference * dir / 128.0;
      }
      if (dir < 0) {
        servoLeftSetting = 1500 + rawDifference - 2.0 * rawDifference * (-dir) / 128.0;
        servoRightSetting = 1500 - rawDifference;
      }
      servoLeft.writeMicroseconds(servoLeftSetting);
      servoRight.writeMicroseconds(servoRightSetting);
    }
  }
  
  // Allow BLE Shield to send/receive data
  ble_do_events();  

  if (musicStarted > 0) {
    unsigned long musicTime = millis();
    if (musicTime - musicStarted < 300) {
      tone(4, 392);
    } else if (musicTime - musicStarted < 600) {
      tone(4, 523.3);
    } else if (musicTime - musicStarted < 900) {
      tone(4, 659.3);
    } else if (musicTime - musicStarted < 1575) {
      tone(4, 784);
    } else if (musicTime - musicStarted < 1800) {
      tone(4, 659.3);
    } else if (musicTime - musicStarted < 3600) {
      tone(4, 784);
    } else {
      noTone(4);
      musicStarted = 0;
    }
  }
}


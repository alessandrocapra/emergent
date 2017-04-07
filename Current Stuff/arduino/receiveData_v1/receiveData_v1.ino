#define numberOfOutputs 24

const int ShiftPWM_latchPin=8;

//const int ShiftPWM_dataPin = 11;
// const int ShiftPWM_clockPin = 13  ;

const bool ShiftPWM_invertOutputs = false; 
const bool ShiftPWM_balanceLoad = false;

#include <ShiftPWM.h>   // include ShiftPWM.h after setting the pins!

unsigned char maxPower = 255;
unsigned char pwmFrequency = 75;

int numRegisters = numberOfOutputs/8;
int incomingByte = 0;
int data[numberOfOutputs]={
};  //change to 

int i=0;
int handShake=0;

void setup(){
  handShake=0;
  Serial.begin(115200);
  // Sets the number of 8-bit registers that are used.
  ShiftPWM.SetAmountOfRegisters(numRegisters);
  ShiftPWM.Start(pwmFrequency,maxPower);
  Serial.flush();
  while (handShake==0){
    if (Serial.available() > 0){
      handShake=Serial.read();
    }
  }
  Serial.write(numberOfOutputs);
  handShake=0;
}

void loop()
{    
  i=0;
  while(i<numberOfOutputs){
    Serial.write(i);
    if (Serial.available() > 0) {
      incomingByte = Serial.read();
      Serial.flush();
      data[i] = incomingByte;
      i++;
    }
    delay(5);
  }
  
  for (int motor = 0; motor<numberOfOutputs; motor++){
    ShiftPWM.SetOne(motor,data[motor]);
  }

}








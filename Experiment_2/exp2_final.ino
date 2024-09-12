
/*Q = [410, 0, 0, 0;
    0,4, 0, 0;
    0, 0, 50, 0;
    0, 0, 0, 100];
R = 14;*/
#include <SPI.h>

/* Serial rates for UART */
#define BAUDRATE        115200

/* SPI commands */
#define AMT22_NOP       0x00
#define AMT22_RESET     0x60
#define AMT22_ZERO      0x70

/* Define special ascii characters */
#define NEWLINE         0x0A
#define TAB             0x09

/* We will use these define macros so we can write code once compatible with 12 or 14 bit encoders */
#define RES12           12
#define RES14           14

/* SPI pins */
#define ENC_0            2
#define ENC_1            3
#define SPI_MOSI        51
#define SPI_MISO        50
#define SPI_SCLK        52

void setup()
{
  //Set the modes for the SPI IO
  pinMode(SPI_SCLK, OUTPUT);
  pinMode(SPI_MOSI, OUTPUT);
  pinMode(SPI_MISO, INPUT);
  pinMode(ENC_0, OUTPUT);
  pinMode(ENC_1, OUTPUT);
 
  //Initialize the UART serial connection for debugging
  Serial.begin(BAUDRATE);

  //Get the CS line high which is the default inactive state
  digitalWrite(ENC_0, HIGH);
  digitalWrite(ENC_1, HIGH);

  pinMode(12, OUTPUT);  // Motor direction control 1
  pinMode(13, OUTPUT);

  SPI.setClockDivider(SPI_CLOCK_DIV32);    // 500 kHz

 
  //start SPI bus
  SPI.begin();
  
}

void loop()
{
  uint16_t encoderPosition0, encoderPosition1;
  uint8_t attempts;
  float theta, alpha;
  float start_pos_arm = (float)getPositionSPI(ENC_0, RES14)*360/16383;
  float error_pendulum_cur,error_arm_cur, error_pendulum_prev,error_arm_prev, velocity_arm, velocity_pendulum, Vm_out;
  int fbsignal;
  float k[4] = {-5.41162769282160,  96.7114158315394,  -3.49111501865230, 13.0618707845219};
//  float k[4] = {-5.542047, 97.348363, -3.528794, 13.146273};

  encoderPosition1 = getPositionSPI(ENC_1, RES14);
  encoderPosition0 = getPositionSPI(ENC_0, RES14);
  
  theta = (float)encoderPosition0*360/16383;
  alpha = (float)encoderPosition1*360/16383;

  error_pendulum_prev = alpha - 180;
  error_arm_prev = theta - start_pos_arm;
  while(1){
   
    encoderPosition0 = getPositionSPI(ENC_0, RES14);
    encoderPosition1 = getPositionSPI(ENC_1, RES14);
   
    theta = (float)encoderPosition0*360/16383;
    alpha = (float)encoderPosition1*360/16383;
   
    error_pendulum_cur = alpha - 180;
    error_arm_cur = theta - start_pos_arm;
    velocity_pendulum = (error_pendulum_cur - error_pendulum_prev)/0.025;
    velocity_arm = (error_arm_cur - error_arm_prev)/0.025;
    //LQR CODE
    Vm_out = (k[0]*error_arm_cur + k[1]*error_pendulum_cur + k[2]*velocity_arm + k[3]*velocity_pendulum)*3.1415926535/180;
    
    fbsignal =map(abs(Vm_out),0,12,0,255);

    Serial.print("arm_error: ");
    Serial.print(error_arm_cur);
    Serial.print(" pendulum_error: ");
    Serial.println(error_pendulum_cur);
    if(Vm_out>0){
      analogWrite(12, constrain(fbsignal,0,255));  // Set motor direction
      analogWrite(13, 0);
    }
    else{
      analogWrite(13, constrain(fbsignal,0,255));  // Set motor direction
      analogWrite(12, 0);
    }
    

//    Serial.println(error_pendulum_cur);
    
    error_pendulum_prev = error_pendulum_cur;
    error_arm_prev=error_arm_cur;
    delay(25);
  }
}

/*
 * This function gets the absolute position from the AMT22 encoder using the SPI bus. The AMT22 position includes 2 checkbits to use
 * for position verification. Both 12-bit and 14-bit encoders transfer position via two bytes, giving 16-bits regardless of resolution.
 * For 12-bit encoders the position is left-shifted two bits, leaving the right two bits as zeros. This gives the impression that the encoder
 * is actually sending 14-bits, when it is actually sending 12-bit values, where every number is multiplied by 4.
 * This function takes the pin number of the desired device as an input
 * This funciton expects res12 or res14 to properly format position responses.
 * Error values are returned as 0xFFFF
 */
uint16_t getPositionSPI(uint8_t encoder, uint8_t resolution)
{
  uint16_t currentPosition;       //16-bit response from encoder
  bool binaryArray[16];           //after receiving the position we will populate this array and use it for calculating the checksum

  //get first byte which is the high byte, shift it 8 bits. don't release line for the first byte
  currentPosition = spiWriteRead(AMT22_NOP, encoder, false) << 8;  

  //this is the time required between bytes as specified in the datasheet.
  //We will implement that time delay here, however the arduino is not the fastest device so the delay
  //is likely inherantly there already
  delayMicroseconds(3);

  //OR the low byte with the currentPosition variable. release line after second byte
  currentPosition |= spiWriteRead(AMT22_NOP, encoder, true);        

  //run through the 16 bits of position and put each bit into a slot in the array so we can do the checksum calculation
  for(int i = 0; i < 16; i++) binaryArray[i] = (0x01) & (currentPosition >> (i));

  //using the equation on the datasheet we can calculate the checksums and then make sure they match what the encoder sent
  if ((binaryArray[15] == !(binaryArray[13] ^ binaryArray[11] ^ binaryArray[9] ^ binaryArray[7] ^ binaryArray[5] ^ binaryArray[3] ^ binaryArray[1]))
          && (binaryArray[14] == !(binaryArray[12] ^ binaryArray[10] ^ binaryArray[8] ^ binaryArray[6] ^ binaryArray[4] ^ binaryArray[2] ^ binaryArray[0])))
    {
      //we got back a good position, so just mask away the checkbits
      currentPosition &= 0x3FFF;
    }
  else
  {
    currentPosition = 0xFFFF; //bad position
  }

  //If the resolution is 12-bits, and wasn't 0xFFFF, then shift position, otherwise do nothing
  if ((resolution == RES12) && (currentPosition != 0xFFFF)) currentPosition = currentPosition >> 2;

  return currentPosition;
}

/*
 * This function does the SPI transfer. sendByte is the byte to transmit.
 * Use releaseLine to let the spiWriteRead function know if it should release
 * the chip select line after transfer.  
 * This function takes the pin number of the desired device as an input
 * The received data is returned.
 */
uint8_t spiWriteRead(uint8_t sendByte, uint8_t encoder, uint8_t releaseLine)
{
  //holder for the received over SPI
  uint8_t data;

  //set cs low, cs may already be low but there's no issue calling it again except for extra time
  setCSLine(encoder ,LOW);

  //There is a minimum time requirement after CS goes low before data can be clocked out of the encoder.
  //We will implement that time delay here, however the arduino is not the fastest device so the delay
  //is likely inherantly there already
  delayMicroseconds(3);

  //send the command  
  data = SPI.transfer(sendByte);
  delayMicroseconds(3); //There is also a minimum time after clocking that CS should remain asserted before we release it
  setCSLine(encoder, releaseLine); //if releaseLine is high set it high else it stays low
 
  return data;
}

/*
 * This function sets the state of the SPI line. It isn't necessary but makes the code more readable than having digitalWrite everywhere
 * This function takes the pin number of the desired device as an input
 */
void setCSLine (uint8_t encoder, uint8_t csLine)
{
  digitalWrite(encoder, csLine);
}

/*
 * The AMT22 bus allows for extended commands. The first byte is 0x00 like a normal position transfer, but the
 * second byte is the command.  
 * This function takes the pin number of the desired device as an input
 */
void setZeroSPI(uint8_t encoder)
{
  spiWriteRead(AMT22_NOP, encoder, false);

  //this is the time required between bytes as specified in the datasheet.
  //We will implement that time delay here, however the arduino is not the fastest device so the delay
  //is likely inherantly there already
  delayMicroseconds(3);
 
  spiWriteRead(AMT22_ZERO, encoder, true);
  delay(250); //250 second delay to allow the encoder to reset
}

/*
 * The AMT22 bus allows for extended commands. The first byte is 0x00 like a normal position transfer, but the
 * second byte is the command.  
 * This function takes the pin number of the desired device as an input
 */
void resetAMT22(uint8_t encoder)
{
  spiWriteRead(AMT22_NOP, encoder, false);

  //this is the time required between bytes as specified in the datasheet.
  //We will implement that time delay here, however the arduino is not the fastest device so the delay
  //is likely inherantly there already
  delayMicroseconds(3);
 
  spiWriteRead(AMT22_RESET, encoder, true);
 
  delay(250); //250 second delay to allow the encoder to start back up
}

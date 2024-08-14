/*
Experiment 1 : DC Motor Control

Group 1:
22B3929 - Aman Verma
22B3942 - Harsh S Roniyar
22B3945 - Pranav Prakash
*/

int ctrl_a = A7;
int ctrl_b = A6;
int potpin = A1;

float error=0;
float tot_err=0;

int fin_val;
int temp_val;
int init_val;
float new_val;

unsigned long start;
char dir;
float p = 20;

// Reads Pot val and writes to new_val
void read_pot_val(){
  new_val = float(analogRead(potpin));
  // new_val = (new_val*360.0)/1024;
}

void update_dir(int x){
  if(x < 0){
    dir = -1;
  }else{
    dir = 1;
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(ctrl_a,OUTPUT);
  pinMode(ctrl_b,OUTPUT);

  read_pot_val();
  init_val = new_val;

  fin_val = int(180+init_val);
  fin_val = (fin_val)%360;

  update_dir(fin_val - init_val);
}

void loop() {
  read_pot_val();

  error = fin_val - new_val;

  // if(error * dir < 0){
  //   fin_val ^= init_val;
  //   init_val ^= fin_val;
  //   fin_val ^= init_val;
  // }

  // if(error < -180){
  //   error += 360;
  // }else if(error > 180){
  //   error -= 360;
  // }

  // if(error > 0){
  //   analogWrite(ctrl_a, 128);
  //   analogWrite(ctrl_b, 0);
  // }
  // else{
  //   analogWrite(ctrl_a, 0);
  //   analogWrite(ctrl_b, 128);
  // }

  analogWrite(ctrl_a, 0);
  analogWrite(ctrl_b, 128);

  Serial.print("Angle:");
  Serial.print(new_val);
  Serial.print(",");
  Serial.print("Variable_2:");
  Serial.println(fin_val);
}
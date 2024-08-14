/*
  Experiment 1 : DC Motor Control

  Group 1:
  22B3929 - Aman Verma
  22B3942 - Harsh S Roniyar
  22B3945 - Pranav Prakash
*/

int ctrl_a = 7;
int ctrl_b = 6;
int potpin = A1;

float error = 0;
float tot_err = 0;
float preverror = 0;

int fin_val;
int temp_val;
int init_val;
float new_val;
float temp;

unsigned long start;
char dir;
float p = 5.55;
float i = 0.14;
float d = 0.69;

float integrate = 0;

void control_motor(char d);

// Reads Pot val and writes to new_val
void read_pot_val() {
  new_val = float(analogRead(potpin));
  new_val = (new_val * 360.0) / 1024;
}

void update_dir(int x) {
  if (x < 0) {
    dir = -1;
  } else {
    dir = 1;
  }
}

void find_non_linear() {
  read_pot_val();
  float prevVals[] = {new_val, new_val, new_val};

  control_motor('f', 80);

  while (1) {
    read_pot_val();

    prevVals[2] = prevVals[1];
    prevVals[1] = prevVals[0];
    prevVals[0] = new_val;

    Serial.print("Angle 1:");
    Serial.print(prevVals[0]);
    Serial.print(",");
    Serial.print("Angle 2:");
    Serial.print(prevVals[1]);
    Serial.print(",");
    Serial.print("Angle 3:");
    Serial.println(prevVals[2]);

    if (abs(prevVals[2] - prevVals[0]) < 90 && 260<prevVals[1] && prevVals[1]<280) {
      control_motor('s', 0);
      break;
    }
  }
}

void control_motor(char d, int speed) {
  if (d == 's') {
    analogWrite(ctrl_a, 0);
    analogWrite(ctrl_b, 0);
  } else if (d == 'f') {
    analogWrite(ctrl_a, 0);
    analogWrite(ctrl_b, speed);
  } else {
    analogWrite(ctrl_a, speed);
    analogWrite(ctrl_b, 0);
  }
}

void setup() {
  Serial.begin(9600);
  pinMode(ctrl_a, OUTPUT);
  pinMode(ctrl_b, OUTPUT);

  find_non_linear();
  read_pot_val();
  init_val = new_val;

  fin_val = int(180 + init_val);
  fin_val = (fin_val) % 360;

  update_dir(fin_val - init_val);

//  find_non_linear();
}

void loop() {
  read_pot_val();
  
  error = float(fin_val-new_val); 
  integrate = integrate + error;
  tot_err = p*error + i*integrate + d*(error-preverror);
  preverror=error;

  if(error<-6){
    control_motor('b',(min(abs(tot_err),255)));
  }
  if(error>6){
    control_motor('f',(min(abs(tot_err),255)));   
  }
  if(error<6 && error>-6){
    control_motor('s',0);
    temp = fin_val;
    fin_val = init_val;
    init_val = temp;
  }
//  Serial.print("Angle 1:");
//  Serial.print(init_val);
//  Serial.print(",");
  Serial.print("Angle 2:");
  Serial.print(fin_val);
  Serial.print(",");
//  Serial.print("Total Error:");  
//  Serial.print(tot_err);
//  Serial.print(",");
  Serial.print("Current Angle:");
  Serial.println(new_val);
}

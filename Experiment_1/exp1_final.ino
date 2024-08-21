/*
  Experiment 1 : DC Motor Control

  Group 1:
  22B3929 - Aman Verma
  22B3942 - Harsh S Roniyar
  22B3945 - Pranav Prakash
*/
#define RANGE_MIN 80
#define RANGE_MAX 100
#define ERROR_RANGE_HIGH 6
#define ERROR_RANGE_LOW -6

int ctrl_a = 6;
int ctrl_b = 5;
int potpin = A0;
                                         
float error = 0;
float tot_err = 0;
float preverror = 0;

char isDone = 0;

//float prevVals[3];

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
  
  prevVals[2] = new_val;
  prevVals[1] = new_val;
  prevVals[0] = new_val;

  control_motor('f', 80);

  while (1) {
    read_pot_val();

    prevVals[2] = prevVals[1];
    prevVals[1] = prevVals[0];
    prevVals[0] = new_val;

    Serial.print("Angle1:");
    Serial.println(prevVals[0]);
//    Serial.print(",");
//    Serial.print("Angle 2:");
//    Serial.println(prevVals[1]);
//    Serial.print(",");
//    Serial.print("Angle 3:");
//    Serial.println(prevVals[2]);

    if (abs(prevVals[2] - prevVals[0]) < 90 && RANGE_MIN <prevVals[0] && prevVals[0]< RANGE_MAX) {
//      control_motor('b', 50);
//      delay(1);
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

  if(error<ERROR_RANGE_LOW){
    control_motor('b',(min(abs(tot_err),255)));
  } else if(error>ERROR_RANGE_HIGH){
    control_motor('f',(min(abs(tot_err),255)));   
  } else {
    control_motor('s',0);
//    temp = fin_val;
//    fin_val = init_val;
//    init_val = temp;
  }
//  Serial.print("Angle 1:");
//  Serial.print(init_val);
//  Serial.print(",");
//  Serial.print("AngleF:");
  Serial.print(fin_val);
  Serial.print(",");
//  Serial.print("Total Error:");  
//  Serial.print(tot_err);
//  Serial.print(",");
  Serial.print("Angle1:");
  Serial.println(new_val);
}

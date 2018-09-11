float res;

union SerialFloat {
  char arr[4];
  float number;
};

union SerialFloat data;

void setup() {
  // open a serial connection
  Serial.begin(9600);
}

void loop() {
  //on every byte read the byte and put it in arr
  for (int i = 0; i <= 3; i++) {
    if (Serial.available() > 0) {
      data.arr[i] = Serial.read();
    }
  }

  // take data from union as float
  res = data.number;
  
  if (isnan(res)) {
    res = 0.0;
  }
  
  Serial.write((unsigned char*)(&res), 4); 

  delay(500);
}



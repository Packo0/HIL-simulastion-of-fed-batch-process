float res;

union serialFloat {
  char arr[4];
  float number;
};

typedef struct {
  serialFloat data; //тука е шоуто
  unsigned char bytes_read = 0;  //Колко байта сме турили в масива
} serialFloatWithCounter;

serialFloatWithCounter b;

//String state;

void setup() {
  // open a serial connection
  Serial.begin(9600);
}

void loop() {
  //on every byte read the byte and put it in arr
  while (b.bytes_read < 4) { //Ако имамеме по-малко от 4 байта четеме
    if (Serial.available()) {
      b.data.arr[b.bytes_read++] = Serial.read();
    } // else break; //тука може да излезеш от уайла ако не искаш да блокираш
  }

  //if (b.bytes_read < 4) { //ако не искаш да блокираш, тря провериш дали си прочел 4 преди да
  //действаш
  res = b.data.number;
  if (isnan(res)) {
    res = 0.0;
  }

  if ((res < 0.0) || (res > 1000000000.0)) { //Може би не е валидно?
    noInterrupts();
    while (Serial.available()) Serial.read(); //Доизпразваме серийния буфер, ако има боклуци
    interrupts();
  }

  res = res + 1;
  Serial.write((unsigned char*)(&res), 4);
  b.bytes_read = 0; //Връщаме буферо в началото
  //}

  //delay(100); //Тва не е нужно
}

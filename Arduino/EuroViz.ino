#define TRIGGER_1_PIN 2
#define TRIGGER_2_PIN 3

void setup() {
  Serial.begin(9600);
  pinMode(TRIGGER_1_PIN, INPUT);
  pinMode(TRIGGER_2_PIN, INPUT);
  attachInterrupt(digitalPinToInterrupt(TRIGGER_1_PIN), onTrigger1PinRise, RISING);
  attachInterrupt(digitalPinToInterrupt(TRIGGER_2_PIN), onTrigger2PinRise, RISING);
}
void onTrigger1PinRise(){
  Serial.write("trigger_1");
}
void onTrigger2PinRise(){
  Serial.write("trigger_2");
}
void loop() {
  delay(20);
}

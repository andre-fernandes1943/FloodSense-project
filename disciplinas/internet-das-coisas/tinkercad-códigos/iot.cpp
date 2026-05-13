#include <Wire.h>
#include <LiquidCrystal_I2C.h>

int distancia = 0;

LiquidCrystal_I2C lcd(0x27, 16, 2);

long readUltrasonicDistance(int triggerPin, int echoPin)
{
  pinMode(triggerPin, OUTPUT);
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(2);

  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(10);  
  digitalWrite(triggerPin, LOW);

  pinMode(echoPin, INPUT);
  return pulseIn(echoPin, HIGH, 30000);
}

void setup()
{
  Wire.begin();
  pinMode(3, OUTPUT); // LED VERMELHO
  pinMode(4, OUTPUT); // LED VERDE
  
  lcd.init();
  lcd.backlight();
  
  lcd.setCursor(0,0);
  lcd.print("sistema enchente");
}

void loop()
{
  distancia = 0.01723 * readUltrasonicDistance(7,6);

  lcd.setCursor(0,1);
  lcd.print("dist:");
  lcd.print(distancia);
  lcd.print("cm  ");

  if(distancia > 0 && distancia <= 100){
    digitalWrite(3, HIGH);
    digitalWrite(4, LOW);
    
    lcd.setCursor(10,1);
    lcd.print("alerta");
  } 
  else {
    digitalWrite(3, LOW);
    digitalWrite(4, HIGH);
    
    lcd.setCursor(10,1);
    lcd.print("   OK   ");
  }

  delay(50);

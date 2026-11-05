// Supervision d'une cuve d'élevage de truites (mars 2023)
// Transcription fidèle du programme final, recopié depuis les captures d'écran de mon diaporama
// (le fichier .ino d'origine n'a pas été conservé). Rien n'a été modifié : à la relecture, aucune ligne
// n'empêchait la compilation (bibliothèque nécessaire : Grove "Ultrasonic Ranger" de Seeed).

#include <math.h>

const int B = 4275;               // B value of the thermistor
const int R0 = 100000;            // R0 = 100k
const int pinTempSensor = A0;     // Grove - Temperature Sensor connect to A0
const int Electrovanne = 2;
float ntu = 0;
float remplissage = 0;

#if defined(ARDUINO_ARCH_AVR)
#define debug  Serial
#elif defined(ARDUINO_ARCH_SAMD) ||  defined(ARDUINO_ARCH_SAM)
#define debug  SerialUSB
#else
#define debug  Serial
#endif

#include "Ultrasonic.h"

  Ultrasonic ultrasonic(4);

void setup()
{
  Serial.begin(9600);
  pinMode(Electrovanne, OUTPUT);
}

void loop()
{
    int a = analogRead(pinTempSensor);
    float R = 1023.0/a-1.0;
    R = R0*R;
    float temperature = 1.0/(log(R/R0)/B+1/298.15)-273.15; // convert to temperature via datasheet
    Serial.print(temperature);
    Serial.print(",");

    long RangeInCentimeters;
    RangeInCentimeters = ultrasonic.MeasureInCentimeters(); // two measurements should keep an interval
    remplissage = 2000-RangeInCentimeters;
    remplissage = remplissage*100;
    remplissage = remplissage/2000;
    Serial.print(remplissage);
    Serial.print(",");
   int sensorValue = analogRead(A1);// read the input on analog pin 0:
   float voltage = sensorValue * (5.0 / 1024.0); // Convert the analog reading (which goes from 0 - 1023) to a voltage (0 - 5V):
   ntu = -1120.4*square(voltage)+5742.3*voltage-4352.9;
   Serial.println(ntu);

}

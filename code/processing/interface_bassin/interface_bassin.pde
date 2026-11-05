// Interface de supervision du bassin des truites (février 2023), Processing 3.
// Adaptée d'un exemple d'interface AranaCorp ("Simple Interface") : j'ai retiré les widgets ControlP5,
// ajouté la lecture du port série, les 4 cuves et l'affichage des 3 mesures de la cuve 1.
// Modifications de publication (2026) : titre de fenêtre renommé ; les 2 lignes qui chargent et affichent
// une illustration téléchargée (non publiée) sont commentées.


color ac_black=color(51, 51, 51);
color ac_green=color(58, 170, 53);
PFont f1, f2;
PImage img;

import processing.serial.*;    
Serial myPort; // The serial port

float v1 = 0;
float v2 = 0;
float v3 = 0;
void setup()
{
  
  //printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  myPort.bufferUntil('\n');
    
  // img = loadImage("téléchargement.jpg");  // illustration téléchargée, non publiée

    size(800, 600);   // set the window size 
    surface.setTitle("Supervision des cuves"); // set window title
    
    //logo = loadImage("/img/logo-araignee1-RVB-72dpi.png");
    f1  =  createFont("Arial", 30, true);
    f2  =  createFont("Arial", 15, true);
  

}
void draw() {

  background(0); // set background to black
    //background(ac_black); // set background to color color
  smooth(); 
  
    fill(57,255,0);
    rect(688,385,180,200);
        textFont(f1);
    fill(25,82,123);
    textAlign(100); //RIGHT LEFT
    text("Cuve 4",640,325);
    textSize(18);
    text("Température :",602,360);
    text("Turbidité :",602,385);
    text("Taux de remplissage :",602,410);
    text("Electrovanne :",602,450);
    
    fill(57,255,0);
    rect(497,385,180,200);
        textFont(f1);
    fill(25,82,123);
    textAlign(100); //RIGHT LEFT
    text("Cuve 3",449,325);
    textSize(18);
    text("Température :",410,360);
    text("Turbidité :",410,385);
    text("Taux de remplissage :",410,410);
    text("Electrovanne :",410,450);
    
    fill(57,255,0);
    rect(307,385,180,200);
        textFont(f1);
    fill(25,82,123);
    textAlign(100); //RIGHT LEFT
    text("Cuve 2",257,325);
    textSize(18);
    text("Température :",219,360);
    text("Turbidité :",219,385);
    text("Taux de remplissage :",219,410);
    text("Electrovanne :",219,450);
    
    fill(57,255,0);
    rect(115,385,180,200);
    textFont(f1);
    fill(25,82,123);
    textAlign(100); //RIGHT LEFT
    text("Cuve 1",65,325);
    textSize(18);
    text("Température :",27,360);
    text(v1,135,360);
    text("Taux de remplissage :",27,410);
    text(v2,25,430);
    text("Turbidité :",27,385);
    text(v3,110,385);
    text("Electrovanne :",27,450);

    // text
    textFont(f1);
    fill(255,255,255);
    textAlign(CENTER); //RIGHT LEFT
    text("Informations sur le bassin des Truites", width/2, 50);
    // line
    stroke(255);     //stroke color
    strokeWeight(4);
    line(100, 50+10, width-100, 50+10);
    // Rectangle
    fill(ac_black, 100);
    stroke(ac_green);
    strokeWeight(2);
    rectMode(CENTER);
    rect(width/2, height/2+30, width-40, height-120);
    // image(img, 265, 95);  // illustration téléchargée, non publiée
    dessinerCuves(265, 95);   // remplacée par un dessin des cuves, à la même place et à la même taille (275 x 183)
}

// Dessin simplifié du bassin (remplace l'illustration téléchargée de 2023)
void dessinerCuves(int x, int y) {
  pushStyle();
  rectMode(CORNER);
  ellipseMode(CENTER);
  noStroke();
  fill(235);
  rect(x, y, 275, 183);                         // fond clair
  fill(200);
  quad(x+20, y+60, x+150, y+40, x+260, y+150, x+110, y+175);   // dalle en perspective
  stroke(120);
  strokeWeight(1);
  for (int r = 0; r < 2; r++) {                 // 2 rangées de 4 cuves rondes
    for (int c = 0; c < 4; c++) {
      float cx = x + 70 + c*42 + r*38;
      float cy = y + 80 + c*20 - r*18;
      fill(250);
      rect(cx-16, cy, 32, 14);                  // paroi
      ellipse(cx, cy+14, 32, 12);
      fill(150, 200, 230);
      ellipse(cx, cy, 32, 12);                  // surface de l'eau
    }
  }
  fill(250);                                    // 2 réservoirs hauts
  rect(x+48, y+22, 22, 40); ellipse(x+59, y+22, 22, 8); ellipse(x+59, y+62, 22, 8);
  rect(x+76, y+16, 22, 42); ellipse(x+87, y+16, 22, 8); ellipse(x+87, y+58, 22, 8);
  fill(210, 140, 40);
  rect(x+28, y+36, 16, 24);                     // armoire de commande
  stroke(60, 160, 90);
  strokeWeight(2);
  line(x+170, y+46, x+272, y+124);              // conduite d'arrivée d'eau
  popStyle();
}

void serialEvent(Serial myPort) {
 
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
 
  // if you got any bytes other than the linefeed:
  myString = trim(myString);
 
  // split the string at the commas
  // and convert the sections into integers:
  float values[] = float(split(myString, ','));
 
  if (values.length > 0) {
    v1 = values[0];
    v2 = values[1];
    v3 = values[2];
  }
}

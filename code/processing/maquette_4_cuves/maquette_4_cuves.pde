// Maquette statique de l'interface des 4 cuves (mars 2023) : valeurs fixes, cuve 4 en alerte (rouge).
// Sketch Processing en mode statique (sans setup/draw).

size(800, 500);

fill(0,255,0);  
rect(40, 150, 180, 180);

fill(0,255,0);
rect(220, 150, 180, 180);

fill(0,255,0);
rect(400, 150, 180, 180);

fill(255,0,0);
rect(580, 150, 180, 180);

fill(0,0,255);
textSize(20);
text("Cuve1", 100, 190);

fill(0,0,255);
textSize(20);
text("Cuve2", 280, 190);

fill(0,0,255);
textSize(20);
text("Cuve3", 460, 190);

fill(0,0,255);
textSize(20);
text("Cuve4", 640, 190);

fill(0,0,0);
textSize(13);
text("Température : 16 °C", 50, 220);

fill(0,0,0);
textSize(13);
text("Température : 17 °C", 230, 220);

fill(0,0,0);
textSize(13);
text("Température : 19 °C", 410, 220);

fill(0,0,0);
textSize(13);
text("Température : 22 °C", 590, 220);

textSize(13);
text("Turbidité : 2  uTN", 50, 245);

fill(0,0,0);
textSize(13);
text("Turbidité : 2  uTN", 230, 245);

fill(0,0,0);
textSize(13);
text("Turbidité : 2  uTN", 410, 245);

fill(0,0,0);
textSize(13);
text("Turbidité : 2  uTN", 590, 245);

textSize(13);
text("Taux de remplissage : 80%", 50, 270);

fill(0,0,0);
textSize(13);
text("Taux de remplissage : 80%", 230, 270);

fill(0,0,0);
textSize(13);
text("Taux de remplissage : 80%", 410, 270);

fill(0,0,0);
textSize(13);
text("Taux de remplissage : 80%", 590, 270);

fill(0,0,0);
textSize(13);
text("Electrovanne : Fermé", 50, 295);

fill(0,0,0);
textSize(13);
text("Electrovanne : Fermé", 230, 295);

fill(0,0,0);
textSize(13);
text("Electrovanne : Fermé", 410, 295);

fill(0,0,0);
textSize(13);
text("Electrovanne : Fermé", 590, 295);

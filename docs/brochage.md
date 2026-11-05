# Brochage et comportement exact / Pin mapping and exact behaviour

Sources :
- `code/arduino/supervision_cuve/supervision_cuve.ino` (mars 2023, transcrit depuis les captures, non modifié) ;
- `code/processing/interface_bassin/interface_bassin.pde` (février 2023).

## Brochage (cuve 1, la seule câblée)

| Broche Arduino | Composant | Rôle | Dans le code |
|---|---|---|---|
| A0 | Capteur de température Grove (thermistance NTC 100 kΩ, B = 4275) | Température de l'eau | `pinTempSensor = A0` |
| D4 | Télémètre à ultrasons Grove (SIG, 1 fil) | Distance capteur → surface de l'eau | `Ultrasonic ultrasonic(4)` |
| A1 | Capteur de turbidité analogique (sortie 0 à 5 V) | Turbidité de l'eau | `analogRead(A1)` |
| D2 | Électrovanne, via un relais | Remplissage de la cuve | `Electrovanne = 2`, réglée en sortie mais **jamais commandée** |
| USB | PC (Processing) | Liaison série à 9600 bauds | `Serial.begin(9600)` |

## Comportement exact du programme Arduino

| Élément | Valeur |
|---|---|
| Période de la boucle | **pas de `delay`** : la boucle tourne aussi vite que possible. L'envoi série (≈ 20 caractères à 9600 bauds, soit ≈ 20 ms) et la mesure ultrason fixent le rythme, donc environ **25 à 40 ms par trame**. Sans écho, l'attente de l'ultrason peut monter jusqu'au délai maximal de `pulseIn` de la bibliothèque |
| Trame envoyée | `température,remplissage,turbidité\r\n`, chaque nombre avec **2 décimales** (`Serial.print(float)`). Exemple : `18.42,99.60,1.95\r\n` |
| Ordre des valeurs | 1. température (°C), 2. taux de remplissage (%), 3. turbidité (NTU) |
| Température | `R = R0·(1023/a − 1)`, puis `T = 1 / (ln(R/R0)/B + 1/298,15) − 273,15`. Si `a = 0` (capteur débranché) ou `a = 1023`, la formule donne −273,15 °C |
| Remplissage | `(2000 − d)·100 / 2000`, avec d en cm. 2000 cm = 20 m : pour d = 10 cm, on obtient 99,5 % |
| Écho ultrason nul | `MeasureInCentimeters()` renvoie **0**, donc le remplissage vaut **100,00 %** |
| Turbidité | `V = analogRead(A1)·5/1024`, puis `NTU = −1120,4·V² + 5742,3·V − 4352,9`. Formule valable environ pour 2,5 V ≤ V ≤ 4,2 V : à 5 V, elle donne −3 651 ; à 0 V, −4 352,9 ; environ 1 800 à la fois vers 3,6 V et vers 1,52 V (la parabole prend deux fois cette valeur) |
| Électrovanne | broche D2 en sortie, **jamais mise à HIGH ou LOW** : la règle « niveau < 80 % → ouvrir » de l'algorigramme n'est pas codée |

## Lecture côté Processing (`interface_bassin.pde`)

| Étape | Code | Remarque |
|---|---|---|
| Port | `new Serial(this, Serial.list()[2], 9600)` | 3ᵉ port de la liste, écrit en dur |
| Découpage | `bufferUntil('\n')`, puis `readStringUntil('\n')`, `trim()`, `split(…, ',')` et `float()` | — |
| Affectation | `if (values.length > 0) { v1 = values[0]; v2 = values[1]; v3 = values[2]; }` | Ne vérifie pas qu'il y a 3 valeurs. Une trame incomplète provoque une erreur ou décale les valeurs |
| Affichage (cuve 1) | `v1` → « Température », `v2` → « Taux de remplissage », `v3` → « Turbidité » (3 décimales) | Cuves 2 à 4 : libellés seulement |
| Alertes | aucune dans l'interface connectée (cuves toujours vertes) | La maquette statique montre la cuve 4 en rouge |

### Photo de l'écran pendant un test (`images/05-ecran-interface-test.jpg`)
Valeurs affichées pour la cuve 1 : **Température 100,000**, **Turbidité 0,000**, **Remplissage 1783,440**. Explication exacte :
- 100 = **remplissage** avec un écho ultrason nul (d = 0 → 100,00 %) ;
- 1783,44 = **turbidité** pour `analogRead(A1) = 311` exactement (V = 1,5186 V, hors de la plage 2,5 à 4,2 V ; 310 → 1771,99 et 312 → 1794,84) ;
- la trame est arrivée **sans son premier champ** : `100.00,1783.44`. On obtient `v1 = 100` et `v2 = 1783.44`, puis `values[2]` lève une exception (ArrayIndexOutOfBounds), donc `v3` reste à 0.

La démo web reproduit cet écran à l'identique.

## Seuils du besoin (pour une version corrigée)

| Grandeur | Seuil |
|---|---|
| Température idéale | 12 à 17 °C |
| Stress | ≥ 20 °C |
| Mortalité | ≈ 24 °C |
| Eau très froide supportée | jusqu'à 3 °C |
| Remplissage | ouvrir l'électrovanne sous 80 % |

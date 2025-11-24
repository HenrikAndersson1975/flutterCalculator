# flutter_calculator 

### operationer ###
Räknaren hanterar räknesätten +, -, * och /.
Det går att skriva hela uttryck och använda parenteser för att ändra i vilken ordning operationerna utförs.

### minne ###
Det går att lagra ett tal i minnet.
M+, addera resultat till det tal som finns i minnet.
M-, subtrahera resultat från det tal som finns i minnet.
MR, visa/använd det tal som är i minnet.
MC, rensa minnet.
Om det finns ett tal i minnet, visas ett M till vänster i displayen.
M:et blinkar till om M+ eller M- trycks.

### varning ###
Gör du något som räknaren inte accepterar, blinkar displayen röd.

### responsiv ###
Knapparnas ordning ändras beroende på om layouten är porträtt eller landskap.
På stora skärmar ska inte räknaren ta upp hela skärmen.




#### programfiler ####

lib -> constants
I button_labels.dart anges de texter/tecken som står på kalkylatorns knappar.

lib -> screens
Kalkylatorvyn, samt dess logik.

lib -> theme 
Klasser för att hantera tema.
I calculator_theme_settings.dart anges vilka färger som används i programmet.

lib -> utils
Klasser för att hantera beräkning av uttryck.

lib -> widgets
De element som kalkylatorvyn är uppbyggd av.

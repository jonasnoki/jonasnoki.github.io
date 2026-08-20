// =====================================================================
// Heuraufe fuer Rundballen - Pultdach, zeitgesteuerter Gaze-Vorhang
// ---------------------------------------------------------------------
// Alle Masse in Millimetern. Nullpunkt in der Mitte, Z = 0 am Boden.
// Das Dach faellt in +Y-Richtung. Die hohe Seite liegt bei -Y.
//
// Gaze auf allen vier Seiten. Befuellt wird bei offenem Vorhang von oben.
//
// SPERRE, Bewegungsrichtung:
//   Die Gaze ist UNTEN fest, an der unteren Kante der Kastenschalung.
//   Oben ist sie aussen auf einen Rahmen aus Geruestrohr geklemmt.
//   Der Rollladenmotor sitzt mittig unter dem Dach. Vier Gurte laufen
//   waagerecht nach aussen, ueber Umlenkrollen und dann senkrecht
//   hinunter an den Rahmen - immer innerhalb der Gaze.
//   Der Rollladenmotor zieht den Rahmen HOCH -> geschlossen.
//   Der Rahmen faellt durch sein Gewicht -> offen, die Gaze rafft sich
//   unten zusammen.
//   Warum nach oben schliessen: das bewegte Teil schiebt einen Pferdekopf
//   nach oben aus der Oeffnung heraus. Es klemmt ihn nicht von oben ein.
//   Die Gaze liegt flach auf der Schalung und ist unten mit einer
//   Klemmleiste festgeschraubt. Sie hat damit keine lose Kante, auf die
//   ein Pferd treten kann. Bis zum Boden bleiben 100 mm Luft.
//
// ---------------------------------------------------------------------
// EXPORT FUER DIE WEBANSICHT
//   openscad -D 'teil="tragwerk"' -o tragwerk.stl heuraufe.scad
// Gruppen: tragwerk dach kasten welle rahmen gurte_fest gurte_hub gaze
//          ballen (nur als Groessenvergleich)
// Alle Teile behalten denselben Weltnullpunkt und passen ohne
// Ausrichtung zusammen. In three.js mit 0.001 skalieren (mm -> m).
// Bewegt werden im Browser nur:
//   rahmen  -> Verschiebung in Z
//   gaze    -> Skalierung in Z, verankert an der Unterkante (z = 100)
//   gurte_hub -> Skalierung in Z, verankert an der Oberkante (Welle)
// =====================================================================

// ------------------------- Ansicht -----------------------------------
web           = true;      // true = ohne Fundamente, Pfosten bis Boden
teil          = "alles";   // Exportgruppe, siehe Kopf
vorhang_offen = 1;         // 0 = geschlossen, 1 = offen
                           // Der STL-Export erzwingt 0, siehe export.sh
variante      = 1;         // 1 = Gaze-Vorhang, 2 = Sperrholzkiste
$v            = 1;         // dynamisch gebunden, siehe raufe()
nebeneinander = true;      // beide Varianten nebeneinander zeigen
abstand       = 5200;      // Abstand der beiden Modelle
zeige_ballen  = false;

// ------------------------- Hauptmasse --------------------------------
kasten      = 2000;   // fertiges Aussenmass, Schalung eingerechnet
uz_len      = 4000;   // Lagerlaenge der Unterzuege -> bestimmt die Dachlaenge
dach_x      = 4000;   // Dachbreite quer zur Neigung = Lagerlaenge der Pfetten
neigung     = 8;      // Dachneigung in Grad
traufe_uk   = 2450;   // lichte Hoehe an der tiefen Traufe, Variante 1
pf_plus     = 500;    // Variante 2 baut hoeher, damit das Fenster groesser wird

// ------------------------- Querschnitte ------------------------------
pfosten     = 100;    // Pfosten 100 x 100 (KVH, 4 x 3,00 m)
pf_ueber    = 120;    // Pfosten steht neben dem Unterzug hoch, fuer 2 Schrauben
uz_b        = 60;     // Unterzug KVH 60 x 160
uz_h        = 160;
schraube_d  = 12;     // Sechskantschraube M12 durch Pfosten und Unterzug
pf_b        = 40;     // Pfette Latte rau 40 x 100
pf_h        = 100;
pf_n        = 5;
blech_dicke = 8;      // Grundblech der Dachhaut
blech_ueb   = 60;     // Ueberstand an beiden Traufen
welle_p     = 76;     // Wellblech: Teilung
welle_t     = 18;     // Wellblech: Tiefe
bahn_n      = 4;      // Anzahl Bahnen nebeneinander

// ------------------------- Futterkasten ------------------------------
brett_d     = 24;     // Brett rau 24 x 180
brett_b     = 180;
brett_n     = 5;      // 5 Reihen -> Oberkante 1000 mm
kasten_uk   = 100;
stiel_b     = 50;     // Mittelstiel Latte rau 50 x 75
stiel_t     = 75;

// ------------------------- Vorhang -----------------------------------
rahmen_r    = 1085;   // Rohrrahmen, innen
gaze_r      = 1003;   // Unten liegt die Gaze flach auf der Kastenschalung,
                      // oben aussen auf dem Rohrrahmen. Die Pferde druecken
                      // sie damit gegen Holz und Rohr, nicht davon weg.
                      // Die Gurte laufen innen und queren die Gaze nie.
gaze_uk     = kasten_uk;  // Unterkante: untere Kante der Kastenschalung
rahmen_zu   = 2200;   // Rahmen geschlossen
rahmen_auf  = 900;    // Rahmen offen, unter der Kastenoberkante
gaze_d      = 6;      // Darstellungsdicke der Gaze
rohr_d      = 33;     // Geruestrohr
klemm_d     = 24;     // Klemmleiste, Brett rau 24 x 100, aussen aufgeschraubt
leiste_h    = 100;    // Hoehe der Klemmleiste

// ------------------------- Antrieb -----------------------------------
gurt_x      = 722;    // Gurtebene, innen an Pfosten und Unterzug vorbei
gurt_ab     = 44;     // Abstand der beiden Scheiben je Seite
umlenk_y    = 1085;   // Umlenkrollen, senkrecht ueber dem Rohrrahmen
welle_sw    = 60;     // Achtkantwelle SW60
scheibe_d   = 170;    // Gurtscheibe
scheibe_b   = 30;
motor_d     = 45;
umlenk_d    = 60;
gurt_b      = 23;     // Rollladengurt

// ------------------------- Variante 2: Sperrholzkiste ------------------
// Dieselbe Aufhaengung, dasselbe Zugsystem. Statt der Gaze haengt eine
// steife Kiste aus vier Platten daran. Hier gilt umgekehrt:
// Kiste unten = geschlossen, Kiste oben = offen.
kiste_r     = 1085;   // Wandebene, wie der Rohrrahmen
kiste_d     = 12;     // Sperrholz
kiste_h     = 700;    // Hoehe der Kiste
kiste_pf    = 60;     // kleine Eckpfosten, 60 x 60
leiste_d    = 80;     // Abschlussleiste: Hoehe
leiste_ab   = 20;     // sie sitzt so weit unter der Kastenoberkante,
                      // damit Kasten und Kiste sich ueberlappen
gurt_luft   = 60;     // Luft zwischen Kistenoberkante und Umlenkrolle

// ------------------------- Kontrollballen -----------------------------
ballen_d    = 1500;
ballen_h    = 1200;

// =====================================================================
// Abgeleitete Werte
// =====================================================================
dach_y    = uz_len * cos(neigung);
wand      = kasten/2;                        // Aussenflaeche der Schalung
pf_a      = wand - brett_d - pfosten/2;      // Pfostenachse, hinter der Schalung
uz_x      = pf_a - pfosten/2 - uz_b/2;       // Unterzug an der Pfosteninnenseite
kasten_ok = kasten_uk + brett_n*brett_b;

fund_ok   = web ? 0 : 100;
e  = [-cos(neigung), sin(neigung)];
nv = [ sin(neigung), cos(neigung)];
L  = uz_len;

// Variante 2 steht pf_plus hoeher. Alles Abgeleitete haengt daran.
function traufe() = traufe_uk + ($v == 2 ? pf_plus : 0);
function u(y)     = traufe() + (dach_y/2 - y)*tan(neigung);
function AA()     = [dach_y/2, traufe()];
function pf_ok(sy)= u(sy*pf_a) + pf_ueber;
// Die Querbalken liegen buendig mit dem Kopf des niedrigen Pfostens.
// Welle und Umlenkrollen haengen 70 mm darunter, damit die Gurtscheiben
// unter den Unterzuegen durchgehen.
// Welle und Umlenkrollen sitzen direkt innen an den Unterzuegen. Weil das
// Dach faellt, liegen sie auf drei verschiedenen Hoehen - den Unterschied
// gleichen die Gurte durch ihren schraegen Lauf aus.
function welle_zz()  = u(0) + 60;
function rolle_z(sy) = u(sy*umlenk_y) + uz_h/2;

pf_abst   = (L - pf_b)/(pf_n - 1);
brett_lang = kasten;                         // Bretter der Y-Seiten
brett_kurz = kasten - 2*brett_d;             // Bretter der X-Seiten
stiel_len = brett_n*brett_b;

// Vorhang
hub       = rahmen_zu - rahmen_auf;
rahmen_z  = rahmen_zu - vorhang_offen*hub;
rahmen_l  = 2*rahmen_r;
gaze_ro   = rahmen_r + rohr_d/2 + gaze_d/2;  // oben, aussen auf dem Rohr
gaze_l    = 2*gaze_ro;                       // Zuschnittbreite je Bahn
gaze_h    = rahmen_zu - gaze_uk;             // Zuschnitthoehe der Gaze

// Klemmleiste: sie liegt aussen auf der untersten Brettreihe und presst
// die Unterkante der Gaze dagegen. Ueberplattet wie die Schalung selbst.
klemm_i    = wand + gaze_d;                  // Innenflaeche, hinter ihr die Gaze
klemm_r    = klemm_i + klemm_d;              // Aussenflaeche
klemm_lang = 2*klemm_r;                      // vorn und hinten, ueber die Ecken
klemm_kurz = 2*klemm_i;                      // links und rechts, dazwischen

// Abschlussleiste: liegt aussen auf den Kastenbrettern und ist genau so
// tief, dass die Kistenwand aussen buendig mit ihr abschliesst. Sie sitzt
// leiste_ab unter der Kastenoberkante, damit sich Kasten und Kiste im
// geschlossenen Zustand ueberlappen.
leiste_t  = kiste_r + kiste_d/2 - wand;      // radiale Tiefe, hier 91 mm
leiste_r  = wand + leiste_t;                 // Aussenflaeche = Kistenaussenflaeche
leiste_ok = kasten_ok - leiste_ab;
leiste_lang = 2*leiste_r;                    // vorn und hinten, ueber die Ecken
leiste_kurz = 2*wand;                        // links und rechts, dazwischen
function kiste_hub() = rolle_z(1) - gurt_luft - leiste_ok - kiste_h;
function kiste_z()   = leiste_ok + vorhang_offen*kiste_hub();
kiste_lang = 2*(kiste_r + kiste_d/2);
kiste_kurz = kiste_lang - 2*kiste_d;
// Gewicht und Drehmoment, damit die Motorwahl nachvollziehbar bleibt
// dieselbe Rechnung wie kiste_hub(), aber mit fest vorgegebener Traufe,
// damit die Schnittliste ausserhalb von raufe() stimmt
function welle_h(t) = t + (dach_y/2 - umlenk_y)*tan(neigung) + uz_h/2;
kiste_hub2 = welle_h(traufe_uk + pf_plus) - gurt_luft - leiste_ok - kiste_h;
kiste_kg  = 4*kiste_lang/1000*kiste_h/1000*kiste_d/1000*700
            + 4*kiste_pf*kiste_pf*kiste_h/1e9*500;
kiste_nm  = kiste_kg*9.81*scheibe_d/2000;

// Gurtebene: je Seite zwei Scheiben, aussen fuer -Y, innen fuer +Y
function gurt_pos(sx, sy) = sx*(gurt_x + sy*gurt_ab/2);
welle_len = 2*(uz_x - uz_b/2);               // Welle zwischen den Unterzuegen

// lichte Innenmasse
licht_ecke  = 2*(pf_a - pfosten/2);
licht_mitte = 2*(wand - brett_d - stiel_t);

G = 8000;

// =====================================================================
// Hilfsmodule
// =====================================================================
module prisma_x(len, pts) {
    translate([-len/2, 0, 0])
        rotate([0, 90, 0])
            linear_extrude(height = len)
                polygon(points = [for (q = pts) [-q[1], q[0]]]);
}
module ueber_ebene(dz = 0) {
    p0 = AA() + dz*nv - G*e;
    p1 = AA() + dz*nv + G*e;
    prisma_x(4*G, [p0, p1, p1 + G*nv, p0 + G*nv]);
}
module auf_ebene(len, t0, t1, dz, h) {
    a = AA() + dz*nv + t0*e;
    b = AA() + dz*nv + t1*e;
    prisma_x(len, [a, b, b + h*nv, a + h*nv]);
}
module rohr_x(len, d) {
    rotate([0, 90, 0]) cylinder(h = len, d = d, center = true, $fn = 24);
}

// =====================================================================
// TRAGWERK
// =====================================================================
// Pfosten stehen neben dem Unterzug hoch und sind waagerecht abgesaegt.
// Kein Schraegschnitt mehr noetig.
module pfosten_koerper() {
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx*pf_a - pfosten/2, sy*pf_a - pfosten/2, fund_ok])
            cube([pfosten, pfosten, pf_ok(sy) - fund_ok]);
}
// Unterzug liegt seitlich an der Pfosteninnenseite, nicht mehr oben auf.
module unterzuege() {
    for (sx = [-1, 1])
        translate([sx*uz_x, 0, 0]) auf_ebene(uz_b, 0, L, 0, uz_h);
}
// Je Anschluss zwei durchgehende Bolzen M12: Kopf und Scheibe aussen am
// Pfosten, Scheibe und Mutter innen am Unterzug. Nichts steht vor.
module scheibe_kopf(x, richtung, kopf_h) {
    translate([x, 0, 0]) rotate([0, 90*richtung, 0]) {
        cylinder(h = 3, d = 2.2*schraube_d, $fn = 20);                 // Scheibe
        translate([0, 0, 3])
            cylinder(h = kopf_h, d = 1.75*schraube_d, $fn = 6);        // Sechskant
    }
}
module bolzen(sx, y, z) {
    xa = sx*(pf_a + pfosten/2);        // Pfostenaussenseite: Kopf
    xi = sx*(uz_x - uz_b/2);           // Unterzuginnenseite: Mutter
    translate([0, y, z]) {
        translate([min(xa, xi), 0, 0]) rotate([0, 90, 0])              // Schaft
            cylinder(h = abs(xa - xi), d = schraube_d, $fn = 14);
        scheibe_kopf(xa,  sx,  8);                                     // Kopf
        scheibe_kopf(xi, -sx, 10);                                     // Mutter
    }
}
module schrauben() {
    for (sx = [-1, 1], sy = [-1, 1], k = [0, 1])
        bolzen(sx, sy*pf_a + (k ? 32 : -32), pf_ok(sy) - 35 - k*55);
}

module pfetten() {
    for (i = [0 : pf_n-1]) {
        t = pf_b/2 + i*pf_abst;
        auf_ebene(dach_x, t - pf_b/2, t + pf_b/2, uz_h, pf_h);
    }
}
module tragwerk() {
    color("BurlyWood") pfosten_koerper();
    color("Tan")       unterzuege();
    color("Wheat")     pfetten();
    color("DimGray")   schrauben();
}

// =====================================================================
// DACH
// =====================================================================
// Wellblech als echtes Sinusprofil, quer zur Neigung gewellt.
// Die Wellentaeler liegen auf den Pfetten auf.
module wellprofil() {
    n_w = floor(dach_x/welle_p);                  // ganze Wellen
    b   = n_w*welle_p;
    n_p = n_w*8;                                  // 8 Punkte je Welle
    unten = [for (i = [0 : n_p])
                let (x = -b/2 + i*b/n_p)
                [x, welle_t/2*(1 - cos(360*x/welle_p))]];
    oben  = [for (i = [n_p : -1 : 0])
                let (x = -b/2 + i*b/n_p)
                [x, welle_t/2*(1 - cos(360*x/welle_p)) + blech_dicke]];
    polygon(points = concat(unten, oben));
}
module dach() {
    p = AA() + (uz_h + pf_h)*nv - blech_ueb*e;       // Anfang, unter der tiefen Traufe
    color("DimGray")
        translate([0, p[0], p[1]])
            rotate([90 - neigung, 0, 0])
                linear_extrude(height = L + 2*blech_ueb)
                    wellprofil();
}

// =====================================================================
// FUTTERKASTEN mit Klemmleiste fuer die Gaze
// =====================================================================
module kasten() {
    // Beide Lagen liegen in derselben Ebene. Die langen Bretter der
    // Y-Seiten laufen bis ganz aussen und decken die Stirnkanten der
    // kurzen Bretter ab. Die Ecke schliesst damit buendig.
    for (i = [0 : brett_n-1]) {
        z = kasten_uk + i*brett_b;
        color("BurlyWood")
        for (sy = [-1, 1])
            translate([-brett_lang/2, sy*wand - (sy > 0 ? brett_d : 0), z])
                cube([brett_lang, brett_d, brett_b]);
        color("Peru")
        for (sx = [-1, 1])
            translate([sx*wand - (sx > 0 ? brett_d : 0), -brett_kurz/2, z])
                cube([brett_d, brett_kurz, brett_b]);
    }
    color("Tan")                                  // Mittelstiele innen
    for (i = [0:3]) rotate([0, 0, 90*i])
        translate([-stiel_b/2, wand - brett_d - stiel_t, kasten_uk])
            cube([stiel_b, stiel_t, stiel_len]);
    leiste();
}

// =====================================================================
// VORHANG
// =====================================================================
// Oben am Rohrrahmen, unten an der Klemmleiste. Dazwischen laeuft die
// Bahn schraeg - im Browser uebernimmt das die Stoffsimulation.
module gaze() {
    color("DarkOliveGreen", 0.45)
    for (i = [0:3]) rotate([0, 0, 90*i])
        prisma_x(gaze_l, [[gaze_ro - gaze_d/2, rahmen_z],
                          [gaze_ro + gaze_d/2, rahmen_z],
                          [gaze_r  + gaze_d/2, gaze_uk],
                          [gaze_r  - gaze_d/2, gaze_uk]]);
}
module rahmen() {
    color("Silver") {
        for (i = [0:3]) rotate([0, 0, 90*i])
            translate([0, rahmen_r, rahmen_z]) rohr_x(rahmen_l, rohr_d);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*rahmen_r, sy*rahmen_r, rahmen_z])
                sphere(d = rohr_d*1.35, $fn = 20);
    }
}

// =====================================================================
// ANTRIEB
// =====================================================================
module welle() {
    color("Silver") {
        translate([0, 0, welle_zz()])                     // Achtkantwelle
            rotate([0, 90, 0])
                cylinder(h = welle_len, d = welle_sw/cos(22.5),
                         center = true, $fn = 8);
        for (sx = [-1, 1], sy = [-1, 1]) {
            translate([gurt_pos(sx, sy), 0, welle_zz()])  // 4 Gurtscheiben,
                rotate([0, 90, 0])                        // eine je Richtung
                    cylinder(h = scheibe_b, d = scheibe_d,
                             center = true, $fn = 32);
            translate([gurt_pos(sx, sy), sy*umlenk_y, rolle_z(sy)])
                rotate([0, 90, 0])                        // 4 Umlenkrollen,
                    cylinder(h = 40, d = umlenk_d,        // innen am Unterzug
                             center = true, $fn = 24);
        }
    }
    color("DimGray")                                      // Motorkopf in der Welle
        translate([-welle_len/2, 0, welle_zz()])
            rotate([0, 90, 0]) cylinder(h = 80, d = motor_d + 22, $fn = 24);
}
// Angriffspunkt der Gurte: Variante 1 am Rohrrahmen, Variante 2 an der
// Oberkante der Kiste.
function heb_z(v) = v == 1 ? rahmen_z : kiste_z() + kiste_h;

module gurte_fest() {
    color("Gainsboro")
    for (sx = [-1, 1], sy = [-1, 1]) {
        a = [0, welle_zz()];                    // Gurtscheibe
        b = [sy*umlenk_y, rolle_z(sy)];         // Umlenkrolle
        translate([gurt_pos(sx, sy), 0, 0])     // schraeger Lauf dazwischen
            prisma_x(gurt_b, [a, b, b - [0, 6], a - [0, 6]]);
    }
}
// Je Seite eine eigene Gruppe. Die beiden Umlenkrollen liegen auf
// verschiedenen Hoehen, also braucht jede Seite ihren eigenen Ankerpunkt.
module gurte_hub_seite(sy, v = 1) {
    color("Gainsboro")
    for (sx = [-1, 1])
        translate([gurt_pos(sx, sy) - gurt_b/2, sy*umlenk_y - 3, heb_z(v)])
            cube([gurt_b, 6, rolle_z(sy) - heb_z(v)]);    // senkrecht nach unten
}
module gurte_hub(v = 1) { gurte_hub_seite(1, v); gurte_hub_seite(-1, v); }
module gurte(v = 1) { gurte_fest(); gurte_hub(v); }

// Variante 1: Klemmleiste ganz unten, dort ist die Gaze festgeschraubt.
// Variante 2: Abschlussleiste oben, wie die Kastenschalung aufgebaut -
//             lange Stuecke vorn und hinten ueber die Ecken, kurze
//             dazwischen. Die Kiste setzt darauf auf.
module leiste() {
    color("Sienna")
    if ($v == 2) {
        for (sy = [-1, 1])                       // lang, vorn und hinten
            translate([-leiste_r, sy*leiste_r - (sy > 0 ? leiste_t : 0),
                       leiste_ok - leiste_d])
                cube([leiste_lang, leiste_t, leiste_d]);
        for (sx = [-1, 1])                       // kurz, dazwischen
            translate([sx*leiste_r - (sx > 0 ? leiste_t : 0), -wand,
                       leiste_ok - leiste_d])
                cube([leiste_t, leiste_kurz, leiste_d]);
    } else {
        for (sy = [-1, 1])                       // lang, ueber die Ecken
            translate([-klemm_lang/2, sy*klemm_r - (sy > 0 ? klemm_d : 0),
                       gaze_uk])
                cube([klemm_lang, klemm_d, leiste_h]);
        for (sx = [-1, 1])                       // kurz, dazwischen
            translate([sx*klemm_r - (sx > 0 ? klemm_d : 0), -klemm_kurz/2,
                       gaze_uk])
                cube([klemm_d, klemm_kurz, leiste_h]);
    }
}

// =====================================================================
// VARIANTE 2: Sperrholzkiste
// Vier Platten, an den Ecken mit kleinen Pfosten verschraubt. Die Gurte
// greifen oben an derselben Stelle an wie sonst am Rohrrahmen.
// =====================================================================
module kiste() {
    color("Tan")                                   // 4 Eckpfosten, in den Ecken
    for (sx = [-1, 1], sy = [-1, 1]) {
        a = kiste_r - kiste_d/2;                   // Innenflaeche der Platten
        translate([sx*a - (sx > 0 ? kiste_pf : 0),
                   sy*a - (sy > 0 ? kiste_pf : 0), kiste_z()])
            cube([kiste_pf, kiste_pf, kiste_h]);
    }
    color("BurlyWood")                             // lange Platten, Y-Seiten
    for (sy = [-1, 1])
        translate([-kiste_lang/2, sy*(kiste_r + kiste_d/2)
                   - (sy > 0 ? kiste_d : 0), kiste_z()])
            cube([kiste_lang, kiste_d, kiste_h]);
    color("Peru")                                  // kurze Platten, X-Seiten
    for (sx = [-1, 1])
        translate([sx*(kiste_r + kiste_d/2) - (sx > 0 ? kiste_d : 0),
                   -kiste_kurz/2, kiste_z()])
            cube([kiste_d, kiste_kurz, kiste_h]);
}

// =====================================================================
// Rundballen zur Kontrolle
// =====================================================================
module ballen() {
    color("Khaki", 0.45)
        translate([0, 0, ballen_d/2]) rotate([0, 90, 0])
            cylinder(h = ballen_h, d = ballen_d, center = true, $fn = 64);
}

// =====================================================================
// Zusammenbau / Exportauswahl
// =====================================================================
// Eine komplette Raufe. v = 1 Gaze-Vorhang, v = 2 Sperrholzkiste.
module raufe(v = 1) {
    tragwerk();
    dach();
    kasten();
    welle();
    gurte(v);
    if (v == 1) { rahmen(); gaze(); }
    else          kiste();
    if (zeige_ballen) ballen();
}
module alles() {
    if (nebeneinander) {
        translate([-abstand/2, 0, 0]) let($v = 1) raufe(1);
        translate([ abstand/2, 0, 0]) let($v = 2) raufe(2);
    } else let($v = variante) raufe(variante);
}

let ($v = variante) {
    if      (teil == "tragwerk")      tragwerk();
    else if (teil == "dach")          dach();
    else if (teil == "kasten")        kasten();
    else if (teil == "welle")         welle();
    else if (teil == "rahmen")        rahmen();
    else if (teil == "kiste")         kiste();
    else if (teil == "gurte_fest")    gurte_fest();
    else if (teil == "gurte_hub_t")   gurte_hub_seite( 1, variante);
    else if (teil == "gurte_hub_h")   gurte_hub_seite(-1, variante);
    else if (teil == "gaze")          gaze();
    else if (teil == "ballen")        ballen();
    else                              alles();
}

// =====================================================================
// Schnittliste
// =====================================================================
pf_kurz   = pf_ok( 1) - fund_ok;
pf_lang   = pf_ok(-1) - fund_ok;
brett_ges = 4*brett_n;

echo(str("---- WEB: Zahlen fuer index.html, in Millimetern ----"));
for (vv = [1, 2]) {
    t  = traufe_uk + (vv == 2 ? pf_plus : 0);
    echo(str("  Variante ", vv,
             ": welle ", round(t + (dach_y/2)*tan(neigung) + 60),
             ", rolle_tief ", round(t + (dach_y/2 - umlenk_y)*tan(neigung) + uz_h/2),
             ", rolle_hoch ", round(t + (dach_y/2 + umlenk_y)*tan(neigung) + uz_h/2)));
}
echo(str("  V1 rahmen zu ", rahmen_zu, " auf ", rahmen_auf,
         " | gaze unten ", gaze_uk, " r ", gaze_r, " breite ", gaze_l));
echo(str("  V2 kiste  zu ", leiste_ok, " auf ", round(leiste_ok + kiste_hub2),
         " hoehe ", kiste_h));
echo(str("======================================================"));
echo(str("HEURAUFE MIT PULTDACH UND GAZE-VORHANG, 4 SEITEN"));
echo(str("Kasten ", kasten, " x ", kasten, "    Dach ", dach_x, " x ",
         round(dach_y)));
echo(str("======================================================"));
echo(str("Lichte Hoehe tiefe Traufe: ", traufe_uk, " mm"));
echo(str("Lichte Hoehe hohe Traufe:  ", round(u(-dach_y/2)), " mm"));
echo(str("Gesamthoehe:               ",
         round(u(-dach_y/2) + (uz_h + pf_h + blech_dicke + welle_t)/cos(neigung)), " mm"));
echo(str("Kastenoberkante:           ", kasten_ok, " mm"));
echo(str("------------------ VORHANG ---------------------------"));
echo(str("Gaze unten fest auf:       ", gaze_uk,
         " mm (Klemmleiste, Unterkante der Schalung)"));
echo(str("Rahmen geschlossen:        ", rahmen_zu, " mm"));
echo(str("Rahmen offen:              ", rahmen_auf,
         " mm  (unter der Kastenoberkante)"));
echo(str("Hub:                       ", hub, " mm"));
echo(str("Fressoeffnung offen:       ", kasten_ok, " bis ",
         round(u(kasten/2)), " mm = ", round(u(kasten/2) - kasten_ok),
         " mm hoch, rundum"));
echo(str("Gaze gerafft in:           ", rahmen_auf - gaze_uk, " mm Hoehe"));
echo(str("------------------ HOLZLISTE -------------------------"));
echo(str("2 x Pfosten niedrig  ", pfosten, " x ", pfosten,
         "   Laenge ", round(pf_kurz)));
echo(str("2 x Pfosten hoch     ", pfosten, " x ", pfosten,
         "   Laenge ", round(pf_lang), "   -> 4 Stueck a 3,00 m kaufen"));
echo(str("     Kopf waagerecht absaegen, kein Schraegschnitt"));
echo(str("8 x Sechskantschraube M", schraube_d,
         " x ", pfosten + uz_b + 40, "   je Anschluss zwei Stueck"));
echo(str("2 x Unterzug         ", uz_b, " x ", uz_h, "   Laenge ", L));
echo(str(pf_n, " x Pfette           ", pf_b, " x ", pf_h,
         "   Laenge ", dach_x));
echo(str("2 x Windrispenband 40 x 2 mm, 5,00 m, diagonal unter den Pfetten"));
echo(str(2*brett_n, " x Brett rau lang ", brett_d, " x ", brett_b,
         "   Laenge ", brett_lang, "   (Y-Seiten, decken die Ecken ab)"));
echo(str(2*brett_n, " x Brett rau kurz ", brett_d, " x ", brett_b,
         "   Laenge ", brett_kurz, "   (X-Seiten)"));
echo(str("     -> ", ceil(brett_ges/2), " Bretter a 4,00 m halbieren"));
echo(str("4 x Mittelstiel      ", stiel_b, " x ", stiel_t,
         "   Laenge ", stiel_len));
echo(str("2 x Klemmleiste lang ", klemm_d, " x ", leiste_h,
         "   Laenge ", klemm_lang, "   (ueber die Ecken)"));
echo(str("2 x Klemmleiste kurz ", klemm_d, " x ", leiste_h,
         "   Laenge ", klemm_kurz));
echo(str("------------------ VORHANG UND ANTRIEB ---------------"));
echo(str("Gaze: 4 Bahnen ", gaze_l, " x ", gaze_h,
         " mm, Bauzaun-Mesh mit Oesen, Kabelbinder"));
echo(str("Rohrrahmen: 4 x Geruestrohr ", rohr_d, " mm, Laenge ", rahmen_l,
         ", dazu 4 Eckverbinder"));
echo(str("1 x Achtkantwelle SW", welle_sw, "   Laenge ", welle_len,
         "   (mittig, Lager an den Querbalken)"));
echo(str("4 x Gurtscheibe SW", welle_sw, " / ", scheibe_d,
         " mm - je Seite zwei, eine je Richtung"));
echo(str("4 x Umlenkrolle, innen an den Unterzuegen, ueber dem Rohrrahmen"));
echo(str("2 x Wellenlager, ebenfalls innen an den Unterzuegen"));
echo(str("     keine Balken mehr oben, alles haengt am Dachtragwerk"));
echo(str("1 x Rollladenmotor 50 Nm (100-kg-Klasse)"));
echo(str("Gurt: 4 Straenge, gesamt ca. ",
         round((4*(welle_zz() - rahmen_auf) + 4*umlenk_y)/1000), " m"));
echo(str("------------------ VARIANTE 2: SPERRHOLZKISTE --------"));
echo(str("2 x Platte lang    ", kiste_d, " mm   ", kiste_lang, " x ", kiste_h));
echo(str("2 x Platte kurz    ", kiste_d, " mm   ", kiste_kurz, " x ", kiste_h));
echo(str("4 x Eckpfosten     ", kiste_pf, " x ", kiste_pf,
         "   Laenge ", kiste_h));
echo(str("2 x Abschlussleiste lang  ", leiste_t, " x ", leiste_d,
         "   Laenge ", leiste_lang));
echo(str("2 x Abschlussleiste kurz  ", leiste_t, " x ", leiste_d,
         "   Laenge ", leiste_kurz));
echo(str("     Oberkante ", leiste_ok, " mm, also ", leiste_ab,
         " mm unter der Kastenoberkante"));
echo(str("Kiste zu:  ", leiste_ok, " bis ", leiste_ok + kiste_h, " mm"));
echo(str("Kiste auf: ", round(leiste_ok + kiste_hub2), " bis ",
         round(leiste_ok + kiste_hub2 + kiste_h), " mm"));
echo(str("Fressfenster offen: ", round(kiste_hub2), " mm"));
echo(str("Variante 2 baut ", pf_plus, " mm hoeher:"));
echo(str("  2 x Pfosten niedrig ", round(pf_kurz + pf_plus),
         ",  2 x Pfosten hoch ", round(pf_lang + pf_plus),
         "   -> 4 Stueck a 4,00 m"));
echo(str("  Lichte Hoehe tiefe Traufe: ", traufe_uk + pf_plus, " mm"));
echo(str("Gewicht der Kiste: ", round(kiste_kg), " kg"));
echo(str("Drehmoment an der Gurtscheibe: ", round(kiste_nm), " Nm"));
echo(str("     -> Motor mindestens ", round(kiste_nm*1.4/10)*10,
         " Nm, oder Gegengewicht"));
echo(str("------------------ FUTTERRAUM ------------------------"));
echo(str("Lichte Weite Ecken:  ", licht_ecke, " mm"));
echo(str("Lichte Weite Mitte:  ", licht_mitte, " mm"));
echo(str("Rundballen bis Durchmesser ", licht_mitte - 40, " mm"));
echo(str("======================================================"));

// =====================================================================
// Heuraufe fuer Rundballen - Pultdach, zeitgesteuerter Gaze-Vorhang
// ---------------------------------------------------------------------
// Alle Masse in Millimetern. Nullpunkt in der Mitte, Z = 0 am Boden.
// Das Dach faellt in +Y-Richtung. Die hohe Seite liegt bei -Y.
//
// Gaze auf allen vier Seiten. Befuellt wird bei offenem Vorhang von oben.
//
// SPERRE, Bewegungsrichtung:
//   Die Gaze ist UNTEN fest, an einer Fussleiste auf der Kastenwand.
//   Oben ist sie aussen auf einen Rahmen aus Geruestrohr geklemmt.
//   Der Rollladenmotor sitzt mittig unter dem Dach. Vier Gurte laufen
//   waagerecht nach aussen, ueber Umlenkrollen und dann senkrecht
//   hinunter an den Rahmen - immer innerhalb der Gaze.
//   Der Rollladenmotor zieht den Rahmen HOCH -> geschlossen.
//   Der Rahmen faellt durch sein Gewicht -> offen, die Gaze rafft sich
//   unten zusammen.
//   Warum nach oben schliessen: das bewegte Teil schiebt einen Pferdekopf
//   nach oben aus der Oeffnung heraus. Es klemmt ihn nicht von oben ein.
//   Warum die Fussleiste auf 400 mm sitzt: die geraffte Gaze darf nie den
//   Boden erreichen. Sonst stehen die Pferde darauf, die Motorsperre
//   spricht an, und die Raufe schliesst nicht mehr.
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
//   gaze    -> Skalierung in Z, verankert an der Unterkante (z = 400)
//   gurte_hub -> Skalierung in Z, verankert an der Oberkante (Welle)
// =====================================================================

// ------------------------- Ansicht -----------------------------------
web           = true;      // true = ohne Fundamente, Pfosten bis Boden
teil          = "alles";   // Exportgruppe, siehe Kopf
vorhang_offen = 0;         // 0 = geschlossen (Rahmen oben), 1 = offen
zeige_ballen  = false;

// ------------------------- Hauptmasse --------------------------------
kasten      = 2000;   // Aussenmass des Futterkastens
uz_len      = 4000;   // Lagerlaenge der Unterzuege -> bestimmt die Dachlaenge
dach_x      = 4000;   // Dachbreite quer zur Neigung = Lagerlaenge der Pfetten
neigung     = 8;      // Dachneigung in Grad
traufe_uk   = 2450;   // lichte Hoehe an der tiefen Traufe

// ------------------------- Querschnitte ------------------------------
pfosten     = 100;    // Pfosten 100 x 100 (KVH, 4 x 3,00 m)
uz_b        = 60;     // Unterzug KVH 60 x 160
uz_h        = 160;
pf_b        = 40;     // Pfette Latte rau 40 x 100
pf_h        = 100;
pf_n        = 5;
blech_d     = 35;     // Trapezblech
blech_ueb   = 60;

// ------------------------- Futterkasten ------------------------------
brett_d     = 24;     // Brett rau 24 x 180
brett_b     = 180;
brett_n     = 5;      // 5 Reihen -> Oberkante 1000 mm
kasten_uk   = 100;
stiel_b     = 50;     // Mittelstiel Latte rau 50 x 75
stiel_t     = 75;

// ------------------------- Vorhang -----------------------------------
rahmen_r    = 1085;   // Rohrrahmen, innen
gaze_r      = 1104;   // Gaze liegt aussen auf dem Rahmen. Die Pferde
                      // druecken sie damit gegen das Rohr, nicht davon weg.
                      // Die Gurte laufen innen und queren die Gaze nie.
gaze_uk     = 400;    // Unterkante: feste Fussleiste
rahmen_zu   = 2200;   // Rahmen geschlossen
rahmen_auf  = 900;    // Rahmen offen, unter der Kastenoberkante
gaze_d      = 6;      // Darstellungsdicke der Gaze
rohr_d      = 33;     // Geruestrohr
leiste_h    = 100;    // Fussleiste, Kantholz von der Kastenwand nach aussen

// ------------------------- Antrieb -----------------------------------
welle_z     = 2400;   // Achse der Wickelwelle, mittig unter dem Dach
welle_len   = 2000;   // Welle zwischen den beiden Querbalken
gurt_x      = 960;    // Abstand der vier Gurte von der Mitte
umlenk_y    = 1085;   // Umlenkrollen an den Enden der Querbalken
qb_x        = 1030;   // Querbalken, aussen an den Pfosten
qb_b        = 60;     // Querbalken KVH 60 x 100
qb_h        = 100;
qb_z        = 2440;   // Unterkante Querbalken
welle_sw    = 60;     // Achtkantwelle SW60
scheibe_d   = 170;    // Gurtscheibe
scheibe_b   = 30;
motor_d     = 45;
umlenk_d    = 60;
gurt_b      = 23;     // Rollladengurt

// ------------------------- Kontrollballen -----------------------------
ballen_d    = 1500;
ballen_h    = 1200;

// =====================================================================
// Abgeleitete Werte
// =====================================================================
dach_y    = uz_len * cos(neigung);
pf_a      = kasten/2 - pfosten/2;
kasten_ok = kasten_uk + brett_n*brett_b;
fund_ok   = web ? 0 : 100;

A  = [dach_y/2, traufe_uk];
e  = [-cos(neigung), sin(neigung)];
nv = [ sin(neigung), cos(neigung)];
L  = uz_len;

// Unterkante Unterzug an der Stelle y
function u(y) = traufe_uk + (dach_y/2 - y)*tan(neigung);

pf_abst   = (L - pf_b)/(pf_n - 1);
brett_l   = kasten;
stiel_len = brett_n*brett_b;

// Vorhang
hub       = rahmen_zu - rahmen_auf;
rahmen_z  = rahmen_zu - vorhang_offen*hub;
rahmen_l  = 2*rahmen_r;
gaze_l    = 2*gaze_r;
gaze_h    = rahmen_zu - gaze_uk;          // Zuschnitthoehe der Gaze

// lichte Innenmasse
licht_ecke  = kasten - 2*pfosten;
licht_mitte = kasten - 2*stiel_t;

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
    p0 = A + dz*nv - G*e;
    p1 = A + dz*nv + G*e;
    prisma_x(4*G, [p0, p1, p1 + G*nv, p0 + G*nv]);
}
module auf_ebene(len, t0, t1, dz, h) {
    a = A + dz*nv + t0*e;
    b = A + dz*nv + t1*e;
    prisma_x(len, [a, b, b + h*nv, a + h*nv]);
}
module rohr_x(len, d) {
    rotate([0, 90, 0]) cylinder(h = len, d = d, center = true, $fn = 24);
}

// =====================================================================
// TRAGWERK
// =====================================================================
module pfosten_koerper() {
    for (sx = [-1, 1], sy = [-1, 1]) {
        y0 = sy*pf_a - pfosten/2;
        y1 = sy*pf_a + pfosten/2;
        translate([sx*pf_a, 0, 0])
            prisma_x(pfosten, [[y0, fund_ok], [y1, fund_ok],
                               [y1, u(y1)], [y0, u(y0)]]);
    }
}
module unterzuege() {
    for (sx = [-1, 1])
        translate([sx*pf_a, 0, 0]) auf_ebene(uz_b, 0, L, 0, uz_h);
}
module pfetten() {
    for (i = [0 : pf_n-1]) {
        t = pf_b/2 + i*pf_abst;
        auf_ebene(dach_x, t - pf_b/2, t + pf_b/2, uz_h, pf_h);
    }
}
// Zwei Querbalken aussen an den Pfosten. Sie tragen die Welle in der Mitte
// und die vier Umlenkrollen an ihren Enden. Weil sie aussen sitzen, fallen
// die Gurte dicht neben den Rahmenrohren herunter und liegen am Rahmen an.
module querbalken() {
    for (sx = [-1, 1])
        translate([sx*qb_x - qb_b/2, -umlenk_y, qb_z])
            cube([qb_b, 2*umlenk_y, qb_h]);
}
module tragwerk() {
    color("BurlyWood") pfosten_koerper();
    color("Tan")       unterzuege();
    color("Wheat")     pfetten();
    color("Peru")      querbalken();
}

// =====================================================================
// DACH
// =====================================================================
module dach() {
    color("DimGray")
        auf_ebene(dach_x, -blech_ueb, L + blech_ueb, uz_h + pf_h, blech_d);
}

// =====================================================================
// FUTTERKASTEN mit Fussleiste fuer die Gaze
// =====================================================================
module kasten() {
    for (i = [0 : brett_n-1]) {
        z = kasten_uk + i*brett_b;
        color("BurlyWood")
        for (sy = [-1, 1])
            translate([-brett_l/2, sy*kasten/2 - (sy > 0 ? 0 : brett_d), z])
                cube([brett_l, brett_d, brett_b]);
        color("Peru")
        for (sx = [-1, 1])
            translate([sx*kasten/2 - (sx > 0 ? 0 : brett_d), -brett_l/2, z])
                cube([brett_d, brett_l, brett_b]);
    }
    color("Tan")                                  // Mittelstiele innen
    for (i = [0:3]) rotate([0, 0, 90*i])
        translate([-stiel_b/2, kasten/2 - stiel_t, kasten_uk])
            cube([stiel_b, stiel_t, stiel_len]);
    color("Sienna")                               // Fussleiste der Gaze
    for (i = [0:3]) rotate([0, 0, 90*i])
        translate([-gaze_l/2, kasten/2 + brett_d, gaze_uk])
            cube([gaze_l, gaze_r - kasten/2 - brett_d, leiste_h]);
}

// =====================================================================
// VORHANG
// =====================================================================
module gaze() {
    color("DarkOliveGreen", 0.45)
    for (i = [0:3]) rotate([0, 0, 90*i])
        translate([-gaze_l/2, gaze_r - gaze_d/2, gaze_uk])
            cube([gaze_l, gaze_d, rahmen_z - gaze_uk]);
}
module rahmen() {
    color("Silver") {
        for (i = [0:3]) rotate([0, 0, 90*i])
            translate([0, rahmen_r, rahmen_z]) rohr_x(rahmen_l, rohr_d);
        for (sx = [-1, 1], sy = [-1, 1])
            translate([sx*rahmen_r, sy*rahmen_r, rahmen_z])
                sphere(d = rohr_d*1.6, $fn = 20);
    }
}

// =====================================================================
// ANTRIEB
// =====================================================================
module welle() {
    color("Silver") {
        translate([0, 0, welle_z])                        // Achtkantwelle
            rotate([0, 90, 0])
                cylinder(h = welle_len, d = welle_sw/cos(22.5),
                         center = true, $fn = 8);
        for (sx = [-1, 1])                                // 2 Gurtscheiben,
            translate([sx*gurt_x, 0, welle_z])            // je 2 Gurte
                rotate([0, 90, 0])
                    cylinder(h = scheibe_b, d = scheibe_d,
                             center = true, $fn = 32);
        for (sx = [-1, 1], sy = [-1, 1])                  // 4 Umlenkrollen
            translate([sx*gurt_x, sy*umlenk_y, welle_z])
                rotate([0, 90, 0])
                    cylinder(h = 40, d = umlenk_d, center = true, $fn = 24);
    }
    color("DimGray")                                      // Motorkopf in der Welle
        translate([-welle_len/2, 0, welle_z])
            rotate([0, 90, 0]) cylinder(h = 80, d = motor_d + 22, $fn = 24);
}


// Die waagerechten Straenge aendern ihre Laenge nie, die senkrechten schon.
// Deshalb zwei Exportgruppen: nur "gurte_hub" wird im Browser animiert.
module gurte_fest() {
    color("Gainsboro")
    for (sx = [-1, 1])
        // waagerecht von der Gurtscheibe zu den Umlenkrollen, entgegengesetzt
        translate([sx*gurt_x - gurt_b/2, -umlenk_y, welle_z - 3])
            cube([gurt_b, 2*umlenk_y, 6]);
}
module gurte_hub() {
    color("Gainsboro")
    for (sx = [-1, 1], sy = [-1, 1])
        // senkrecht hinunter zu den Rahmenrohren
        translate([sx*gurt_x - gurt_b/2, sy*umlenk_y - 3, rahmen_z])
            cube([gurt_b, 6, welle_z - rahmen_z]);
}
module gurte() { gurte_fest(); gurte_hub(); }

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
module alles() {
    tragwerk();
    dach();
    kasten();
    welle();
    gurte();
    rahmen();
    gaze();
    if (zeige_ballen) ballen();
}

if      (teil == "tragwerk") tragwerk();
else if (teil == "dach")     dach();
else if (teil == "kasten")   kasten();
else if (teil == "welle")    welle();
else if (teil == "rahmen")   rahmen();
else if (teil == "gurte")      gurte();
else if (teil == "gurte_fest") gurte_fest();
else if (teil == "gurte_hub")  gurte_hub();
else if (teil == "gaze")       gaze();
else if (teil == "ballen")     ballen();
else                         alles();

// =====================================================================
// Schnittliste
// =====================================================================
pf_kurz   = u(pf_a - pfosten/2) - fund_ok;
pf_lang   = u(-pf_a - pfosten/2) - fund_ok;
brett_ges = 4*brett_n;

echo(str("======================================================"));
echo(str("HEURAUFE MIT PULTDACH UND GAZE-VORHANG, 4 SEITEN"));
echo(str("Kasten ", kasten, " x ", kasten, "    Dach ", dach_x, " x ",
         round(dach_y)));
echo(str("======================================================"));
echo(str("Lichte Hoehe tiefe Traufe: ", traufe_uk, " mm"));
echo(str("Lichte Hoehe hohe Traufe:  ", round(u(-dach_y/2)), " mm"));
echo(str("Gesamthoehe:               ",
         round(u(-dach_y/2) + (uz_h + pf_h + blech_d)/cos(neigung)), " mm"));
echo(str("Kastenoberkante:           ", kasten_ok, " mm"));
echo(str("------------------ VORHANG ---------------------------"));
echo(str("Gaze unten fest auf:       ", gaze_uk, " mm (Fussleiste)"));
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
echo(str("2 x Unterzug         ", uz_b, " x ", uz_h, "   Laenge ", L));
echo(str(pf_n, " x Pfette           ", pf_b, " x ", pf_h,
         "   Laenge ", dach_x));
echo(str("2 x Querbalken       ", qb_b, " x ", qb_h, "   Laenge ", 2*umlenk_y,
         "   (aussen an den Pfosten, tragen den Antrieb)"));
echo(str("2 x Windrispenband 40 x 2 mm, 5,00 m, diagonal unter den Pfetten"));
echo(str(brett_ges, " x Brett rau     ", brett_d, " x ", brett_b,
         "   Laenge ", brett_l, "   -> ", ceil(brett_ges/2),
         " Bretter a 4,00 m halbieren"));
echo(str("4 x Mittelstiel      ", stiel_b, " x ", stiel_t,
         "   Laenge ", stiel_len));
echo(str("4 x Fussleiste       ", round(gaze_r - kasten/2 - brett_d),
         " x ", leiste_h, "   Laenge ", gaze_l));
echo(str("------------------ VORHANG UND ANTRIEB ---------------"));
echo(str("Gaze: 4 Bahnen ", gaze_l, " x ", gaze_h,
         " mm, Bauzaun-Mesh mit Oesen, Kabelbinder"));
echo(str("Rohrrahmen: 4 x Geruestrohr ", rohr_d, " mm, Laenge ", rahmen_l,
         ", dazu 4 Eckverbinder"));
echo(str("1 x Achtkantwelle SW", welle_sw, "   Laenge ", welle_len,
         "   (mittig, Lager an den Querbalken)"));
echo(str("2 x Gurtscheibe SW", welle_sw, " / ", scheibe_d,
         " mm, je 2 Gurte entgegengesetzt gewickelt"));
echo(str("4 x Umlenkrolle auf Stummelachse, 2 x Wellenlager"));
echo(str("     alles an den Querbalken verschraubt"));
echo(str("1 x Rollladenmotor 50 Nm (100-kg-Klasse)"));
echo(str("Gurt: 4 Straenge, gesamt ca. ",
         round((4*(welle_z - rahmen_auf) + 4*umlenk_y)/1000), " m"));
echo(str("------------------ FUTTERRAUM ------------------------"));
echo(str("Lichte Weite Ecken:  ", licht_ecke, " mm"));
echo(str("Lichte Weite Mitte:  ", licht_mitte, " mm"));
echo(str("Rundballen bis Durchmesser ", licht_mitte - 40, " mm"));
echo(str("======================================================"));

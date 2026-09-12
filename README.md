🌿 Eko-Szepty: Ostatni Strażnik
Eko-Szepty: Ostatni Strażnik to przygodowa gra zręcznościowo-logiczna w klimacie Stealth z widokiem top-down, stworzona w silniku Godot 4. Projekt stawia na mroczny, nastrojowy klimat, dynamiczne oświetlenie 2D, zarządzanie zasobami oraz ścisłą współpracę w trybie lokalnej kooperacji (Couch Co-Op).
🎮 Koncept i Fabuła
Świat został opanowany przez mechaniczną skażoną grzybnię oraz patrolowe maszyny pożerające naturę. Gracze wcielają się w dwa małe Duszki Światła. Ich celem jest wspólne przedzieranie się przez niebezpieczne sektory, unikanie wykrycia, sadzenie wspierającej roślinności i ładowanie energii w starożytnych Sanktuariach, by przywrócić w lesie życie.
🌟 Mechanika Kooperacji (Couch Co-Op)
Gra została zaprojektowana z myślą o dwóch gracza na jednym ekranie. Kluczem do sukcesu jest podział obowiązków i utrzymywanie bliskiego kontaktu.
Postacie
 * Gracz 1 (Duszek Słońca – Żółty):
   * Rola: Ofensywa i torowanie drogi.
   * Zdolność specjalna: Silny Rozbłysk, który ogłusza mechanicznych wrogów.
   * Roślinność: Sadzi Spring Mushrooms (grzyby odbijające i pozwalające na szybką ucieczkę).
 * Gracz 2 (Duszek Księżyca – Błękitny):
   * Rola: Wsparcie i defensywa.
   * Zdolność specjalna: Efektywniejsze i szybsze ładowanie Sanktuariów.
   * Roślinność: Sadzi Fog Flowers (kwiaty generujące mgłę, która ukrywa przed wzrokiem maszyn).
Więź Światła (Light Tether)
Światło jest jednocześnie zdrowiem graczy i ich źródłem widoczności. Gdy duszki przebywają blisko siebie:
 * Zużycie energii spada o 50%.
 * Poziomy energii obu postaci powoli się wyrównują.
 * Zwiększa się całkowity promień oświetlenia terenu.
👾 Przeciwnicy i Skradanie
Maszyny patrolowe poruszają się po wyznaczonych ścieżkach i reagują na światło oraz ruch:
 * Stożek wzroku: Wrogowie widzą w określonym promieniu. Wejście w ich pole widzenia wywołuje pościg.
 * Strefy ukrycia: Wchodząc w mgłę generowaną przez kwiaty (Fog Flowers), gracze stają się niewidoczni dla patroli.
 * Rozbłysk: Ostatnia linia obrony — pozwala ogłuszyć maszynę na kilka sekund kosztem sporej części energii.
🛠️ Architektura Projektu w Godot 4
Gra wykorzystuje modułową strukturę scen, co ułatwia jej rozbudowę:
 * Player.tscn – Scena postaci obsługująca fizykę ruchu, system oświetlenia PointLight2D zależny od energii oraz obszar rozbłysku.
 * Enemy.tscn – Scena przeciwnika zawierająca maszynę stanów (Patrol / Pościg / Ogłuszenie), stożek wzroku oparty o detekcję obszarową i testy kolizji promieniem (RayCast2D).
 * Sanctuary.tscn – Punkt docelowy na mapie. Wymaga przytrzymania interakcji i przekazania energii, aby na stałe rozświetlić dany obszar.
 * Plant_Base.tscn – Baza dla sadzonych roślin, modyfikujących zachowanie graczy i wrogów w swoim zasięgu.
 * Events.gd – Centralna magistrala sygnałów (Global Signal Bus) obsługująca komunikację między interfejsem UI, graczami a stanem gry.
🎛️ Sterowanie
| Akcja | Gracz 1 (Klawiatura / Pad 1) | Gracz 2 (Klawiatura / Pad 2) |
|---|---|---|
| Ruch | W, A, S, D / Lewa gałka | Strzałki ↑, ↓, ←, → / Lewa gałka |
| Rozbłysk (Flash) | Space / Przycisk A (Cross) | Numpad 0 / Przycisk A (Cross) |
| Sadzenie rośliny | E / Przycisk B (Circle) | Numpad Enter / Przycisk B (Circle) |
| Interakcja (Ładowanie) | F / Przycisk X (Square) | Numpad . / Przycisk X (Square) |
🚀 Jak uruchomić projekt
 * Zainstaluj silnik Godot 4.x (zalecana wersja 4.2 lub nowsza).
 * Pobierz lub sklonuj repozytorium do wybranego folderu.
 * Otwórz Godot Engine, wybierz Importuj i wskaż plik project.godot.
 * Uruchom projekt przyciskiem F5.

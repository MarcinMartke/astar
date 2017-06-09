Dodaj START do tablicy OPEN
dodaj przeszkody do tablicy CLOSE

while(nie osiagnieto punktu || koniec mozliwych tras)
%     dodaj OK_SASIAD(obecny punkt) do Sasiad
for i=1:Sasiad % dla kazdego n-sasiada
if (SASIAD == OPEN)
    if SASIAD.FN < OPEN.FN
        OPEN.rodzic =obecny_punkt
        OPEN.Gn = Sasiad.Gn
        OPEN.Hn = Sasiad.Hn
    end
    if Sasiad <> OPEN % nie jest jeszcze w OPEN
%         dopisz Sasiad(n) do OPEN
    end
end

Znajdz minimum OPEN.Fn
if (nie osiagnieto punktu koncowego)
%     NowePole = pole(min(OPEN.Fn));
%     Sciezka = Hn(min(OPEN.Fn));
%     Wpisz NowePole -> CLOSE
end
if(koniec mozliwosci)
    koniec=1;
end

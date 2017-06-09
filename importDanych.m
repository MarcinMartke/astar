clear;clc;close all;
mapA = xlsread('labirynt.xlsx','lab1','A1:AD30');
mapB = xlsread('labirynt.xlsx','lab2','A1:AD30');
mapC = xlsread('labirynt.xlsx','lab3','A1:AD30');
valueStart = 128; valueTarget=200; walls = 255;
valueStart = 200; valueTarget=128; walls = 255;

%% Budowa ograniczen zwiazanych z ruchem na skos (ochrona przed zderzeniem)
close all;
MAP = mapA;
[point.xTarget,point.yTarget]=find(MAP==valueTarget);
[point.xStart,point.yStart]=find(MAP==valueStart);
% MAP=limitMove(mapB,valueStart,valueEnd,walls); % wybierz mape:
%% Szukaj punktów mapy:

MAP(point.xTarget,point.yTarget)=valueTarget;
MAP(point.xStart,point.yStart)=valueStart;
MAPout=MAP;
figure(1)
imagesc(MAP)
[rozmiarX,rozmiarY]=size(MAP);
%% Algorytm sk³ada sie z 2 macierzy:
% OPEN - mozliwe do zwiedzenia w sasiedztwie aktualnego punktu (8 pkt),
% CLOSED - zwiedzone / zablokowane punkty.
OPEN = []; CLOSED = [];
kOPEN=1;   kClosed=1;
%% Wstawianie scian do listy zamknietych:

for i=1:rozmiarX
    for j=1:rozmiarY
        if(MAP(i,j)==walls)
            CLOSED(kClosed,1)=i; % dodanie w osi i
            CLOSED(kClosed,2)=j; % dodanie w osi j
            kClosed=kClosed+1;
        end
    end
end
%% Pierwsza petla programu
% rozpoczecie w punkcie Map(Xstart,Ystart)
currentX=point.xStart; currentY=point.yStart;
point.goalDistance=valueDistance(point.xStart,point.yStart,point.xTarget,point.yTarget);
%koszt ruchu z pkt :
% Map(Xstart,Ystart) -> Map(Xstart,Ystart)
path_cost=0;
% dodanie punktu startowego do listy otwartej
OPEN(kOPEN,:)=insert_to_OPEN(currentX,currentY,currentX,currentY,path_cost,point.goalDistance,point.goalDistance);
% dodanie punktu startowego do CLOSED & OPEN(1,1) = 0.
OPEN(kOPEN,1)=0;
CLOSED(kClosed,1)=currentX; % dodaj do CLOSEDx : currentX
CLOSED(kClosed,2)=currentY; % dodaj do CLOSEDy : currentY
% wyswietlanie wynikow
MAPout(currentX,currentY)=60;
figure(2)
imagesc(MAPout)
kClosed=kClosed+1;
NoPath=1;
%% rozpoczecie algorytmu:
path_cost=0;
while((currentX ~= point.xTarget || currentY ~= point.yTarget) && NoPath == 1)
    %%
    % szukanie dozwolonych sasiadow (walls + sprawdzone + skos)
    [tab_neighbors,count_neighbors]=find_neighbor(currentX,currentY,path_cost,point.xTarget,point.yTarget,CLOSED,rozmiarX,rozmiarY,MAP,walls);
    % animacja zaznaczonych sasiadow
    for INTmap=1:count_neighbors
        MAPout(tab_neighbors(INTmap,1),tab_neighbors(INTmap,2))=115;
        % jasno zielone w figure(2)
    end
    figure(2)
    imagesc(MAPout);
    
    for iPath=1:count_neighbors
        trasaLepsza=0;
        for j=1:kOPEN
            % czy macierz sasiedztwa - tab_neighbors znajduje siê juz w OPEN
            if(tab_neighbors(iPath,1) == OPEN(j,2) && tab_neighbors(iPath,2) == OPEN(j,3) )
                if OPEN(j,8)> tab_neighbors(iPath,5)
                    % dzialaj, jesli wartosc OPEN(j,8)-FN  == tab_neigbors(iPath,5) - FN nowe, czyli
                    % bardziej oplaca pojsc sie do pkt MAP(OPEN(j,2),OPEN(j3))
                    % zaktualizuj lepsza trase
                    %aktualizacja rodzicX,rodzicY,Gn,Hn
                    OPEN(j,4)=currentX; %podmiana do rodzica
                    OPEN(j,5)=currentY;
                    OPEN(j,6)=tab_neighbors(iPath,3); % Hn
                    OPEN(j,7)=tab_neighbors(iPath,4); % Gn
                    OPEN(j,8)=tab_neighbors(iPath,5); % Fn
                end;%
                trasaLepsza=1;
            end;% koniec polepszenia trasy
        end;%koniec w przeszukiwaniu punktow sasiad - tablica w OPEN
        % jezeli nie ma punktu tab_neibors w OPEN,
        % dodaj macierz open punkt z macierzy tab_neighbors do OPEN
        if trasaLepsza == 0
            kOPEN = kOPEN+1; % zwieksz liste mozliwych do drogi puntkow X/Y
            % jasno zielone w figure(2)
            OPEN(kOPEN,:)=insert_to_OPEN(tab_neighbors(iPath,1),tab_neighbors(iPath,2),currentX,currentY,tab_neighbors(iPath,3),tab_neighbors(iPath,4),tab_neighbors(iPath,5));
        end;
    end;
    % znajdz minimalna wartosc FN w zbiorze OPEN nieruszonym (OPEN(:,1)==1)
    index_min_move= minFN(OPEN,kOPEN,point.xTarget,point.yTarget);
    %jezeli z index_min_nod
    if (index_min_move ~= -1)
        % aktualizacja punktu: X, Y, Hn
        currentX=OPEN(index_min_move,2); % nastepny ruchX
        currentY=OPEN(index_min_move,3); % nastepny ruchY
        path_cost=OPEN(index_min_move,6);% Hn
        % dodaj nowy ruch do CLOSED:
        kClosed=kClosed+1; %przygotowanie do nastepnego kClosed
        CLOSED(kClosed,1)=currentX;
        CLOSED(kClosed,2)=currentY;
        OPEN(index_min_move,1)=0; % ruch zbadany
        %% aktualizacja mapy
        MAPout(currentX,currentY)=60;
        figure(2)
        imagesc(MAPout)
        pause(0.001)
    else
        %brak sciezki
        NoPath=0;% brak
    end;%koniec index_min_move
end;% WHILE
%% powrót
i=size(CLOSED,1);
Path=[];
%pobierz ostatniego CLOSED jako koniec
backX=CLOSED(i,1);
backY=CLOSED(i,2);
% tworzenie iPath do zwiekszania wektora sciezki programu
iPath=1;

figure(3)
MAPout(backX,backY)=510;
imagesc(MAPout)
pause(0.01)
% poczatek powrotu
Path(iPath,1)=backX;
Path(iPath,2)=backY;
iPath=iPath+1;

if ( (backX == point.xTarget) && (backY== point.yTarget))
    %     szukanie rodzica nr 2
    rodzicX=OPEN(findparent(OPEN,backX,backY),4);
    rodzicY=OPEN(findparent(OPEN,backX,backY),5);
    Path(iPath,1) = rodzicX;
    Path(iPath,2) = rodzicY;
    MAPout(rodzicX,rodzicY)=510;
    imagesc(MAPout)
    pause(0.01)
    % przeszukaj dopoki nie znajdzie sie punkt startowy
    while( rodzicX ~= point.xStart || rodzicY ~= point.yStart)
        Path(iPath,1) = rodzicX;
        Path(iPath,2) = rodzicY;
        %szukaj rodzicow - rodzicow
        iParent=findparent(OPEN,rodzicX,rodzicY);
        rodzicX=OPEN(iParent,4);%pobieraj rodzicowX
        rodzicY=OPEN(iParent,5);%pobieraj rodzicowY
        iPath=iPath+1;
        figure(3)
        MAPout(rodzicX,rodzicY)=510;
        imagesc(MAPout)
        pause(0.01)
    end;
end
MAPout(point.xStart,point.yStart)=valueStart;
MAPout(point.xTarget,point.yTarget)=valueTarget;
figure(3)
imagesc(MAPout)

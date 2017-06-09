function [tab_neighbors,count_neighbors,wrogowie] = find_neighbor(currentX,currentY,Hn,xTarget,yTarget,CLOSED,rozmiarX,rozmiarY,MAP,walls)

tab_neighbors = [];
count_neighbors=1;
closed2=size(CLOSED,1); % do sprawdzania czy nie jest w zamknieciu

for k=-1:1 % X
    for j=-1:1 % Y
        if (k~=j || k~=0) %pkt wszystkie wokol x/y
            sasiad_x=currentX+k;
            sasiad_y=currentY+j;
            sasiad_zabroniony=1; % temp-odswiez czy jest x/y jest w "Closed"
            %sprawdzanie granic:
            if((sasiad_x>0 && sasiad_x<=rozmiarX) && (sasiad_y>0 && sasiad_y<=rozmiarY))
                %% sprawdzanie czy plik nadaje sie do dalszej analizy (czy nie jest ruchem zablokowanym)
                for closed1=1:closed2
                    if(sasiad_x == CLOSED(closed1,1) && sasiad_y== CLOSED(closed1,2))
                        sasiad_zabroniony=0;
                    end
                end
                %%                 "nie scinaj scian"
                %% prawy dolny naroznik
                if (sasiad_x == currentX+1) %prawa
                    if (sasiad_y ==currentY-1) %dol
                        % V>
                        if MAP(currentX,currentY-1)==walls || ...
                                MAP(currentX+1,currentY) == walls
                            sasiad_zabroniony=0;
                        end
                %% prawy gorny naroznik
                    else if (sasiad_y == currentY+1) %gora
                            % >^
                            if MAP(currentX,currentY+1)==walls || ...
                                    MAP(currentX+1,currentY) == walls
                                sasiad_zabroniony=0;
                            end
                        end
                    end
                end
                if (sasiad_x == currentX-1)
                    %% lewy dolny naroznik
                    if (sasiad_y ==currentY-1) % dol
                        % <V
                        if MAP(currentX-1,currentY)==walls || ...
                                MAP(currentX,currentY-1) == walls
                            sasiad_zabroniony=0;
                        end
                    %% lewy gorny naroznik    
                    else if (sasiad_y == currentY+1) % gora
                            %<^
                            if MAP(currentX,currentY+1)==walls || ...
                                    MAP(currentX-1,currentY) == walls
                                sasiad_zabroniony=0;
                            end
                        end
                    end
                end
                % czy ruch nie jest zablokowany
                if (sasiad_zabroniony==1)
                    %% parametry wspolrzednych:
                    tab_neighbors(count_neighbors,1)=sasiad_x; % sasiad_x
                    tab_neighbors(count_neighbors,2)=sasiad_y; % sasiad_y
                    %% parametry jakosci:
                    tab_neighbors(count_neighbors,3)=Hn+valueDistance(currentX,currentY,sasiad_x,sasiad_y); % Hn
                    tab_neighbors(count_neighbors,4)=valueDistance(xTarget,yTarget,sasiad_x,sasiad_y); % Gn (x/yTarget)->sasiad_x/y
                    tab_neighbors(count_neighbors,5)=tab_neighbors(count_neighbors,3)+tab_neighbors(count_neighbors,4); % Fn - funkcja optymalizacji
                    %% przygotuj sie na sasiada
                    count_neighbors=count_neighbors+1;
                end % koniec sasiad_zabroniony
            end% koniec granic
        end%koniec sasiadow
    end%koniec j
end%koniec k
count_neighbors = size(tab_neighbors,1);
end%koniec funkcji
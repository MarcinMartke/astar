function optimalIndex=minFN(OPEN,kOPEN,xTarget,yTarget)
temp=[];
k=1; koniecTrasy=0;
goalIndex=0;

for j=1:kOPEN
    % jezeli temp bedzie pusty, to oznacza ze nie ma gdzie juz isc
    % (zablokowana trasa)
     if (OPEN(j,1)==1) % nie biore pod uwage punktow w tabeli CLOSED (walls + zbadane punkty)
         temp(k,:)=[OPEN(j,:) j];% jty - index OPEN nie zbadany
         % cel osiagniety:
         if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget)
             koniecTrasy=1;
             goalIndex=j;%w 'j'-tym indexie OPEN(j,:)
         end;
         k=k+1; %predykcja zwiekszenia temp
     end;
 end;%sprawdzono wszystkie wezly z OPEN
 
 if koniecTrasy == 1 % znaleziono droge
     optimalIndex=goalIndex;
 elseif koniecTrasy==0 
 if size(temp ~= 0)
[~,temp_min]=min(temp(:,8));%index o najmniejszym Fn w 
% nie zbadanej tabeli OPEN (:,1) ==1
  % dokad isc?
  % optimalIndex - index w liscie otwartej!
  optimalIndex=temp(temp_min,9);%index o najmniejszej wadze FN
 else
     optimalIndex=-1;% koniec drogi, nie ma przejscia
 end;
end
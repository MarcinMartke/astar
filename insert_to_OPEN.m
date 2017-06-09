function newOPEN = insert_to_OPEN(currentX,currentY,rodzic_X,rodzic_Y,Hn,Gn,Fn)
% mozliwosc badania punktu / zmienna do budowy sciezki
newOPEN(1,1)= 1;
newOPEN(1,2)=currentX; % current X value
newOPEN(1,3)=currentY; % current Y value
newOPEN(1,4)=rodzic_X; % rodzic X
newOPEN(1,5)=rodzic_Y; % rodzic Y
newOPEN(1,6)=Hn; % dystans do pokonania Hn
newOPEN(1,7)=Gn; % ca³ka ruchów Gn
newOPEN(1,8)=Fn; % suma G+H;

end
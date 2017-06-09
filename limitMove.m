function immap = limitMove(map,valueStart,valueEnd,walls)

immap=map;
% [xStart,yStart]=find(map==valueStart);
% [xEnd,yEnd]=find(map==valueEnd);

immap(immap==valueStart)=0; 
immap(immap==valueEnd)=0; 
SE = strel('square', 3);
immap=imdilate(immap,SE);

immap=imadd(immap,map);
immap(immap==walls*2)=walls;

end
function d=valueDistance(x1,y1,x2,y2)
potencjalX=abs(x1-x2);
potencjalY=abs(y1-y2);
d=14*min(potencjalX,potencjalY)+10*(max(potencjalX,potencjalY)-min(potencjalX,potencjalY));
end

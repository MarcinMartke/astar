function indexParent=findparent(OPEN,backX,backY)

i=1;
while(OPEN(i,2) ~= backX || OPEN(i,3) ~= backY )
    i=i+1;
end;
indexParent=i;
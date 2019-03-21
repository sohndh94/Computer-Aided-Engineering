function D=planestress(E,v)
D=E/(1-v^2)*[1,v,0 ; v,1,0 ; 0,0,(1-v)/2];
end
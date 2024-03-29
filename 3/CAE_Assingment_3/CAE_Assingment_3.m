%주어진 환경
u1x=0;u2y=0;u2x=0;u3x=0;u3y=0;u4y=0;u4x=0;
%좌표 표시
x1=0;y1=0;p1=[x1,y1];
x2=0.5;y2=0;p2=[x2,y2];
x3=0.5;y3=0.5;p3=[x3,y3];
x4=0;y4=0.5;p4=[x4,y4];
x5=0.25;y5=0.25;p5=[x5,y5];
%상수 정리
T=100;t=5*10^-3;
E1=70*10^9;E4=70*10^9;E2=210*10^9;E3=210*10^9;v=0.3;
alpha=12*10^-6;A=0.5^2;
%Bmatix
B1=Bmatrix(p1,p2,p5,A);
B2=Bmatrix(p2,p3,p5,A);
B3=Bmatrix(p3,p4,p5,A);
B4=Bmatrix(p1,p5,p4,A);
%D
D1=planestress(E1,v);
D2=planestress(E2,v);
D3=planestress(E3,v);
D4=planestress(E4,v);
% 각각의 K
k1=t*A*B1'*D1*B1;
k2=t*A*B2'*D2*B2;
k3=t*A*B3'*D3*B3;
k4=t*A*B4'*D4*B4;
%Global K
K=zeros(10);
%k1을 글로벌K
K(1:2,1:2)=k1(1:2,1:2);
K(1:2,3:4)=k1(1:2,3:4);
K(1:2,9:10)=k1(1:2,5:6);
K(3:4,1:2)=k1(3:4,1:2);
K(3:4,3:4)=k1(3:4,3:4);
K(3:4,9:10)=k1(3:4,5:6);
K(9:10,1:2)=k1(5:6,1:2);
K(9:10,3:4)=k1(5:6,3:4);
K(9:10,9:10)=k1(5:6,5:6);
%k2을 글로벌K
K(3:4,3:4)=K(3:4,3:4)+k2(1:2,1:2);
K(3:4,5:6)=K(3:4,5:6)+k2(1:2,3:4);
K(3:4,9:10)=K(3:4,9:10)+k2(1:2,5:6);
K(5:6,3:4)=K(5:6,3:4)+k2(3:4,1:2);
K(5:6,5:6)=K(5:6,5:6)+k2(3:4,3:4);
K(5:6,9:10)=K(5:6,9:10)+k2(3:4,5:6);
K(9:10,3:4)=K(9:10,3:4)+k2(5:6,1:2);
K(9:10,5:6)=K(9:10,5:6)+k2(5:6,3:4);
K(9:10,9:10)=K(9:10,9:10)+k2(5:6,5:6);
%k3을 글로벌K
K(5:6,5:6)=K(5:6,5:6)+k3(1:2,1:2);
K(5:6,7:8)=K(5:6,7:8)+k3(1:2,3:4);
K(5:6,9:10)=K(5:6,9:10)+k3(1:2,5:6);
K(7:8,5:6)=K(7:8,5:6)+k3(3:4,1:2);
K(7:8,7:8)=K(7:8,7:8)+k3(3:4,3:4);
K(7:8,9:10)=K(7:8,9:10)+k3(3:4,5:6);
K(9:10,5:6)=K(9:10,5:6)+k3(5:6,1:2);
K(9:10,7:8)=K(9:10,7:8)+k3(5:6,3:4);
K(9:10,9:10)=K(9:10,9:10)+k3(5:6,5:6);
%k4을 글로벌K
K(1:2,1:2)=K(1:2,1:2)+k4(1:2,1:2);
K(1:2,9:10)=K(1:2,9:10)+k4(1:2,3:4);
K(1:2,7:8)=K(1:2,7:8)+k4(1:2,5:6);
K(9:10,1:2)=K(9:10,1:2)+k4(3:4,1:2);
K(9:10,9:10)=K(9:10,9:10)+k4(3:4,3:4);
K(9:10,7:8)=K(9:10,7:8)+k4(3:4,5:6);
K(7:8,1:2)=K(7:8,1:2)+k4(5:6,1:2);
K(7:8,9:10)=K(7:8,9:10)+k4(5:6,3:4);
K(7:8,7:8)=K(7:8,7:8)+k4(5:6,5:6);
%thermal force
f1=thermf(p1,p2,p5,E1);
f2=thermf(p2,p3,p5,E2);
f3=thermf(p3,p4,p5,E3);
f4=thermf(p1,p5,p4,E4);
%Global Thermalforce
f=[];
f(1:2)=f1(1:2)+f4(1:2);
f(3:4)=f1(3:4)+f4(1:2);
f(5:6)=f2(3:4)+f3(1:2);
f(7:8)=f3(3:4)+f4(5:6);
f(9:10)=f1(5:6)+f4(5:6)+f3(5:6)+f4(3:4);

%절점변위
u=f(9:10)./K(9:10);
u5x=u(1);
u5y=u(2);
u=zeros(10,1);
u(9)=u5x;
u(10)=u5y;

%stress 구하기

%element1
ns1= planestress(E1,v)*B1*[u(1:4);u(9:10)] - planestress(E1,v)*alpha*[100;100;0];

%element2
ns2= planestress(E2,v)*B2*[u(3:6);u(9:10)] - planestress(E2,v)*alpha*[100;100;0];

%element3
ns3= planestress(E3,v)*B3*u(5:10) - planestress(E3,v)*alpha*[100;100;0];

%element4
ns4= planestress(E4,v)*B4*[u(1:2);u(9:10);u(7:8)] - planestress(E4,v)*alpha*[100;100;0];


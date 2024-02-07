
clc;
clear;
format long;

for i = 1:8
n = (i-1)*10;

data = importdata('Gap.txt');
E = [2, 5, 10, 18.5, 35, 70, 120, 177.5, 240, 300];
G = data((n+1):(n+10),2);
G = G*10^6;

plot (E,G, 'lineWidth',2);
set(gca,'FontSize',20)
xlabel('E_S_E');
ylabel('Gap (nm)')
hold on;
end;

hold on;
legend({'Y=0.5','Y=1','Y=2','Y=4', 'Y=8', 'Y=12.6', 'Y=16', 'Y=20'})

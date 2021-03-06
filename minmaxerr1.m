%Code to find the best controller K
%PI: Sridevi Sarma
%Pseudocode: Michelle Chyn
%TF/Edits: Melissa Lin, Debra Huang
clear all; close all; clc;
%Load global variables
global lags psth

%Set up parameters based on the 'best' values found in earlier trials
A_normal = 4.6560;%11;
gamma_normal = 0.9544;%0.6;
w_normal = 6.3461;%3.5;
d_normal = 6;%7;

x_n = [A_normal gamma_normal w_normal d_normal];

A_pd = 4.232389;%8;
gamma_pd = 0.9497;%0.8;
w_pd = 0.0631;%0.4;
d_pd = 6;%7;

x_pd = [A_pd gamma_pd w_pd d_pd];

%Set up unmodified transfer functions based on Sabatino's code
den = [1 -2*gamma_normal*cos(w_normal) gamma_normal^2];
num = [A_normal -A_normal*gamma_normal*cos(w_normal) 0];
den1 = [1 -2*gamma_pd*cos(w_pd) gamma_pd^2];
num1 = [A_pd -A_pd*gamma_pd*cos(w_pd) 0];
Ts  = 0.1;



%finding controller K
maxerr=zeros(1,1);

for j = 1:21 %can change to first order etc.
    K = (j-11)/10;
    H_n = tf(num,den,Ts,'variable','z^-1','InputDelay',d_normal);
    H_p = tf(num1,den1,Ts,'variable','z^-1','InputDelay',d_pd); %Use Sabatino code to find; %Parkinsonian
    H_control = tf(num1,(den1+num1*K),Ts,'variable','z^-1','InputDelay',d_normal);
    mag = zeros(1,360);
    mag_p = zeros(1,360);
    mag_n = zeros(1,360);
    w=360*10:360*30;
        [mag,~] = bode(H_control,w);
        [mag_p,~] = bode(H_p,w);
        [mag_n,~] = bode(H_n,w);
        %zplane(num,den);
        
        %disp('Running');
    poles=pole(H_control);
    r=length(poles);
    count=0;
    for s=1:r
        if abs(poles(r))>10000 %arbitrary threshold for unstable system
            count=count+1;
        end
    end
    if count==0
        error = zeros(360,1);
        for q=1:360*20
            error(q) = abs(mag_n(q)-mag(q));
        end
        [maxerr(j), index] = max(error);
    end
end

[y,i] = min(maxerr);
K = -1:2/21:1;
K=K(i);
H_control = tf(num1,(den1+num1*K),Ts,'variable','z^-1','InputDelay',d_normal);
bodeplot(H_n,'b',H_control,'m',H_p, 'r');



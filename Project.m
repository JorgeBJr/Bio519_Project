%% Project - magnetic
clear all; close all; clc;

%import stuff
data_centroid_m = csvread('811m_Centerxypts.csv',1,0); %This will import the 
%CSV file of the centroid (i.e. input stimulus) with the appropriate offset
%that imports the two columns without the headers. 
data_abdomen_m = csvread('811m_Abdoxypts.csv',1,0); %This will import the 
%CSV file of the abdomen (i.e. output response) with the appropriate offset 
%that imports the two columns without the headers. 

Centroid_X_m = data_centroid_m(:,1);
Centroid_Y_m = data_centroid_m(:,2);
StaticPoint_X_m = 530.810347;
StaticPoint_Y_m = 174.693939;
Abdomen_X_m = data_abdomen_m(:,1);
Abdomen_Y_m = data_abdomen_m(:,2);

figure;
plot(Centroid_X_m',Centroid_Y_m','.','MarkerSize',20)
hold on;
plot(Abdomen_X_m',Abdomen_Y_m','.','MarkerSize',20)
plot(StaticPoint_X_m, StaticPoint_Y_m,'k.','MarkerSize',20)
xlabel('x position')
ylabel('y position')
legend('Centroid (input stimulus', 'Abdomen (output response)',...
    'Static Point')

%The following five lines of code are from 
%http://www.mathworks.com/help/matlab/ref/fft.html 
Fs = 500; %Sample frequency
T = 1/Fs; %This is the period
L = 1000; %This is the length of the signal since our data sets are arrays 
%of 1000 x 1
t = (0:L-1)*T; %This is how we get our time vector.

%Finding theta of the centroid with respect to the static point
deltaX_Centroid_m = Centroid_X_m - StaticPoint_X_m;
deltaY_Centroid_m = Centroid_Y_m - StaticPoint_Y_m;
deltaCentroid_Fraction_m = deltaY_Centroid_m./deltaX_Centroid_m;
theta_Centroid_m = atand(deltaCentroid_Fraction_m); %This returns the arctan 
%of the function IN DEGREES

%Finding theta of the abdomen with respect to the static point
deltaX_Abdomen_m = Abdomen_X_m - StaticPoint_X_m;
deltaY_Abdomen_m = Abdomen_Y_m - StaticPoint_Y_m;
deltaAbdomen_Fraction_m = deltaY_Abdomen_m./deltaX_Abdomen_m;
theta_Abdomen_m = atand(deltaAbdomen_Fraction_m); %This returns the arctan 
%of the function IN DEGREES

%Because I want to see the theta with respect to time...
figure;
plot(t,theta_Centroid_m,'LineWidth',2)
hold on;
plot(t,theta_Abdomen_m,'LineWidth',2)
xlabel('Time (in seconds)')
ylabel('Theta (in degrees)')
legend('Centroid','Abdomen')

%Fast Fourier transform stuff with subtracting the mean to reduce noise
stuff_centroid_m = fft(theta_Centroid_m-mean(theta_Centroid_m),L);
stuff_abdomen_m = fft(theta_Abdomen_m-mean(theta_Aentroid_m),L);

f = Fs*(0:(L/2))/L;
%f=(1./(T.*L)).*([0:(L/2), ((L/2)-1):-1:1]);
ampscale = L/2+1; %This is to scale the amplitude
figure;
plot(f(1:100),(abs(stuff_centroid_m(1:100))/ampscale),'LineWidth',2);
hold on;
plot(f(1:100),(abs(stuff_abdomen_m(1:100))/ampscale),'LineWidth',2);
xlabel('f (Hz)')
ylabel('Amplitude')
legend('Centroid','Abdomen')

%% Non-magnetic

%import stuff
data_centroid_nm = csvread('811nm_Centerxypts.csv',1,0); %This will import the 
%CSV file of the centroid (i.e. input stimulus) with the appropriate offset
%that imports the two columns without the headers. 
data_abdomen_nm = csvread('811nm_Abdoxypts.csv',1,0); %This will import the 
%CSV file of the abdomen (i.e. output response) with the appropriate offset 
%that imports the two columns without the headers. 

Centroid_X_nm = data_centroid_nm(:,1);
Centroid_Y_nm = data_centroid_nm(:,2);
StaticPoint_X_nm = 530.810347;
StaticPoint_Y_nm = 174.693939;
Abdomen_X_nm = data_abdomen_nm(:,3);
Abdomen_Y_nm = data_abdomen_nm(:,4);

figure;
plot(Centroid_X_nm',Centroid_Y_nm','.','MarkerSize',20)
hold on;
plot(Abdomen_X_nm',Abdomen_Y_nm','.','MarkerSize',20)
plot(StaticPoint_X_nm, StaticPoint_Y_nm,'k.','MarkerSize',20)
title('Non-magnetic')
xlabel('x position')
ylabel('y position')
legend('Centroid (input stimulus', 'Abdomen (output response)',...
    'Static Point')

%The following five lines of code are from 
%http://www.mathworks.com/help/matlab/ref/fft.html 
Fs = 500; %Sample frequency
T = 1/Fs; %This is the period
L = 1000; %This is the length of the signal since our data sets are arrays 
%of 1000 x 1
t = (0:L-1)*T; %This is how we get our time vector.

%Finding theta of the centroid with respect to the static point
deltaX_Centroid_nm = Centroid_X_nm - StaticPoint_X_nm;
deltaY_Centroid_nm = Centroid_Y_nm - StaticPoint_Y_nm;
deltaCentroid_Fraction_nm = deltaY_Centroid_nm./deltaX_Centroid_nm;
theta_Centroid_nm = atand(deltaCentroid_Fraction_nm); %This returns the 
%arctan of the function IN DEGREES

%Finding theta of the abdomen with respect to the static point
deltaX_Abdomen_nm = Abdomen_X_nm - StaticPoint_X_nm;
deltaY_Abdomen_nm = Abdomen_Y_nm - StaticPoint_Y_nm;
deltaAbdomen_Fraction_nm = deltaY_Abdomen_nm./deltaX_Abdomen_nm;
theta_Abdomen_nm = atand(deltaAbdomen_Fraction_nm); %This returns the 
%arctan of the function IN DEGREES

%Because I want to see the theta with respect to time...
figure;
plot(t,theta_Centroid_nm,'LineWidth',2)
hold on;
plot(t,theta_Abdomen_nm,'LineWidth',2)
title('Non-magnetic')
xlabel('Time (in seconds)')
ylabel('Theta (in degrees)')
legend('Centroid','Abdomen')

%Fast Fourier transform stuff
stuff_centroid_nm = fft(theta_Centroid_nm-mean(theta_Centroid_nm),L);
stuff_abdomen_nm = fft(theta_Abdomen_nm-mean(theta_Abdomen_nm),L);

f = Fs*(0:(L/2))/L;
ampscale = L/2+1; %This is to scale the amplitude
figure;
plot(f(1:100),(abs(stuff_centroid_nm(1:100))/ampscale),'LineWidth',2);
hold on;
plot(f(1:100),(abs(stuff_abdomen_nm(1:100))/ampscale),'LineWidth',2);
title('Non-magnetic')
xlabel('f (Hz)')
ylabel('Amplitude')
legend('Centroid','Abdomen')

%% Find the Gain

%Gain of the magnetic 
Gain_m = abs(stuff_abdomen_nm(find(ismember(f,3))))/...
    abs(stuff_centroid_nm(find(ismember(f,3))))
%find(ismember(f,3)) finds the location of the cell where the value of the
%frequency is 3 Hz. Taking the absolute value of the abdomen and the
%centroid at the 3 Hz frequency location gives us the gain.

%Gain of the non-magnetic 
Gain_nm = abs(stuff_abdomen_nm(find(ismember(f,3))))/...
    abs(stuff_centroid_nm(find(ismember(f,3))))

%% Find the Phase

%Phase of the magnetic 
Phase_m = (angle(stuff_abdomen_m(find(ismember(f,3))))/...
    angle(stuff_centroid_m(find(ismember(f,3)))))*180/pi

%Phase of the non-magnetic 
Phase_nm = (angle(stuff_abdomen_nm(find(ismember(f,3))))/...
    angle(stuff_centroid_nm(find(ismember(f,3)))))*180/pi
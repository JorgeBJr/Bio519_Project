%% Project - magnetic
clear all; close all; clc;

%import stuff
data_centroid = csvread('811m_Centerxypts.csv',1,0); %This will import the 
%CSV file of the centroid (i.e. input stimulus) with the appropriate offset
%that imports the two columns without the headers. 
data_abdomen = csvread('811m_Abdoxypts.csv',1,0); %This will import the 
%CSV file of the abdomen (i.e. output response) with the appropriate offset 
%that imports the two columns without the headers. 

Centroid_X = data_centroid(:,1);
Centroid_Y = data_centroid(:,2);
StaticPoint_X = 530.810347;
StaticPoint_Y = 174.693939;
Abdomen_X = data_abdomen(:,1);
Abdomen_Y = data_abdomen(:,2);

figure;
plot(Centroid_X',Centroid_Y','.','MarkerSize',20)
hold on;
plot(Abdomen_X',Abdomen_Y','.','MarkerSize',20)
plot(StaticPoint_X, StaticPoint_Y,'k.','MarkerSize',20)
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
deltaX_Centroid_nm = Centroid_X - StaticPoint_X;
deltaY_Centroid_nm = Centroid_Y - StaticPoint_Y;
deltaCentroid_Fraction = deltaY_Centroid_nm./deltaX_Centroid_nm;
theta_Centroid = atand(deltaCentroid_Fraction); %This returns the arctan 
%of the function IN DEGREES

%Finding theta of the abdomen with respect to the static point
deltaX_Abdomen = Abdomen_X - StaticPoint_X;
deltaY_Abdomen = Abdomen_Y - StaticPoint_Y;
deltaAbdomen_Fraction = deltaY_Abdomen./deltaX_Abdomen;
theta_Abdomen_nm = atand(deltaAbdomen_Fraction); %This returns the arctan 
%of the function IN DEGREES

%Because I want to see the theta with respect to time...
figure;
plot(t,theta_Centroid,'LineWidth',2)
hold on;
plot(t,theta_Abdomen_nm,'LineWidth',2)
xlabel('Time (in seconds)')
ylabel('Theta (in degrees)')
legend('Centroid','Abdomen')

%Fast Fourier transform stuff
stuff_centroid = fft(theta_Centroid,L);
stuff_abdomen = fft(theta_Abdomen_nm,L);

%Subtract mean
CentroidSub=stuff_centroid-mean(stuff_centroid);
AbdomenSub=stuff_abdomen-mean(stuff_abdomen);
f = Fs*(0:(L/2))/L;
%f=(1./(T.*L)).*([0:(L/2), ((L/2)-1):-1:1]);
ampscale = L/2+1; %This is to scale the amplitude
figure;
plot(f(1:100),(abs(CentroidSub(1:100))/ampscale),'LineWidth',2);
hold on;
plot(f(1:100),(abs(AbdomenSub(1:100))/ampscale),'LineWidth',2);
xlabel('f (Hz)')
ylabel('Amplitude of abdomen response')
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
theta_Centroid_nm = atand(deltaCentroid_Fraction_nm); %This returns the arctan 
%of the function IN DEGREES

%Finding theta of the abdomen with respect to the static point
deltaX_Abdomen_nm = Abdomen_X_nm - StaticPoint_X_nm;
deltaY_Abdomen_nm = Abdomen_Y_nm - StaticPoint_Y_nm;
deltaAbdomen_Fraction_nm = deltaY_Abdomen_nm./deltaX_Abdomen_nm;
theta_Abdomen_nm = atand(deltaAbdomen_Fraction_nm); %This returns the arctan 
%of the function IN DEGREES

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
stuff_centroid_nm = fft(theta_Centroid_nm,L);
stuff_abdomen_nm = fft(theta_Abdomen_nm,L);

%Subtract mean
CentroidSub_nm = stuff_centroid_nm-mean(stuff_centroid_nm);
AbdomenSub_nm = stuff_abdomen_nm-mean(stuff_abdomen_nm);
f = Fs*(0:(L/2))/L;
%f=(1./(T.*L)).*([0:(L/2), ((L/2)-1):-1:1]);
ampscale = L/2+1; %This is to scale the amplitude
figure;
plot(f(1:100),(abs(CentroidSub_nm(1:100))/ampscale),'LineWidth',2);
hold on;
plot(f(1:100),(abs(AbdomenSub_nm(1:100))/ampscale),'LineWidth',2);
title('Non-magnetic')
xlabel('f (Hz)')
ylabel('Amplitude of abdomen response')
legend('Centroid','Abdomen')
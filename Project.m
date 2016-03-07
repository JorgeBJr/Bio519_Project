%% Project
clear all; close all; clc;

%import stuff
data_centroid = csvread('811m_Centerxypts.csv',1,0); %This will import the 
%CSV file of the centroid (i.e. input stimulus) with the appropriate offset
%that imports the two columns without the headers. 
data_abdomen = csvread('811m_completexypts.csv',1,0); %This will import the 
%CSV file of the abdomen (i.e. output response) with the appropriate offset 
%that imports the two columns without the headers. 

Centroid_X = data_centroid(:,1);
Centroid_Y = data_centroid(:,2);
Abdomen_X = data_abdomen(:,1);
Abdomen_Y = data_abdomen(:,2);

figure;
plot(Centroid_X',Centroid_Y','.','MarkerSize',20)
hold on;
plot(Abdomen_X',Abdomen_Y','.','MarkerSize',20)
xlabel('x position')
ylabel('y position')
%Frequency is 3 Hz? Check with Brandon

%The following five lines of code are from 
%http://www.mathworks.com/help/matlab/ref/fft.html 
Fs = 3; %frequency is 3 Hertz
T = 1/Fs; %This is the period
L = 1000; %This is the length of the signal since our data sets are arrays 
%of 1000 x 1
t = (0:L-1)*T; %This is how we get our time vector.


%Finding theta by determining the difference between the input and output
deltaX = Centroid_X - Abdomen_X;
deltaY = Centroid_Y - Abdomen_Y;
deltaFraction = deltaY./deltaX;
theta = atand(deltaFraction); %This returns the arctan of the function 
%IN DEGREES

%Because I want to see the theta with respect to time...
figure;
plot(t,theta,'LineWidth',2)
xlabel('Time (in seconds)')
ylabel('Theta (in degrees)')

%Fast Fourier transform stuff
junk = fft(theta);
f = Fs*(0:(L/2))/L;
ampscale = L/2+1; %This is to scale the amplitude
figure;
plot(f(1:100),(abs(junk(1:100))/ampscale),'LineWidth',2);
find(abs(junk(1:100)) == max(abs(junk(1:100))))
xlabel('f (Hz)')
ylabel('|P1(f)| <-- Something about a theta transform?')
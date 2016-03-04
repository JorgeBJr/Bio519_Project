%% Project
clear all; close all; clc;

%import stuff
data = csvread('811m_Centerxypts.csv',1,0); %This will import the CSV file
%with the appropriate offset that imports the two columns without the
%headers.

Centroid_X = data(:,1);
Centroid_Y = data(:,2);

figure;
plot(Centroid_X',Centroid_Y','.','MarkerSize',20)
xlabel('x position')
ylabel('y position')
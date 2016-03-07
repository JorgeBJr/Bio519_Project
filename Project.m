%% Project
clear all; close all; clc;

%import stuff
data_centroid = csvread('811m_Centerxypts.csv',1,0); %This will import the CSV file
%of the centroid (i.e. input stimulus) with the appropriate offset that 
%imports the two columns without the headers. 
data_abdomen = csvread('811m_completexypts.csv',1,0); %This will import the CSV 
%file of the abdomen (i.e. output response) with the appropriate offset 
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

%Frequency is 3 Hz?
%% Project
clear all; close all; clc;

%import stuff
data = csvread('811m_Centerxypts.csv',1,0); %This will import the CSV file
%with the appropriate offset that imports the two columns without the
%headers.


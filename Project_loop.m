%% Project - magnetic
clearvars; close all; clc;

listofcsvfiles = dir('*.csv');  %the asterisk is a wildcard
%The dir function returns a "listing" of an M x 1 "structure." The 
%structure has five fields in this case listing: name, date, byte, isdir, 
%datenum.
%I used the wildcard because I know the number of text files will
%definitely increase as we gather more data.
%For more information enter   help dir   into MATLAB mainframe

%We are ONLY concerned with the number of elements in this array AND the
%names of the files.
%The next line saves the number of elements into a variable using the 
%numel() function
NumOfCSVFiles = numel(listofcsvfiles);

for i = 1:NumOfCSVFiles;
%% Inside the loop
filename = listofcsvfiles(i).name;
    %Remember the filename has to be a SPECIFIC file name.
    %NOW we want the NAMES of the files. So we refer to our listofcsvfiles
    %structure and add the extension '.name' to the end of 
    %'listofcsvfile(i)' to get the NAME of the specific text file.
    
    %The "i" comes in handy here because it lets us iterate the process for
    %all files and ultimately does NOT import the same file twice.
    
%Import stuff
data_centroid = csvread(filename,1,0); %This will import the 
%CSV file of the centroid (i.e. input stimulus) with the appropriate offset
%that imports the two columns without the headers. 

Centroid_X = data_centroid(:,1);
Centroid_Y = data_centroid(:,2);
StaticPoint_X = 530.810347;
StaticPoint_Y = 174.693939;
Abdomen_X = data_abdomen_m(:,1);
Abdomen_Y = data_abdomen_m(:,2);

%The following five lines of code are from 
%http://www.mathworks.com/help/matlab/ref/fft.html 
Fs = 500; %Sample frequency
T = 1/Fs; %This is the period
L = 1000; %This is the length of the signal since our data sets are arrays 
%of 1000 x 1
t = (0:L-1)*T; %This is how we get our time vector.

%Finding theta of the centroid with respect to the static point
deltaX_Centroid = Centroid_X - StaticPoint_X;
deltaY_Centroid = Centroid_Y - StaticPoint_Y;
deltaCentroid_Fraction = deltaY_Centroid./deltaX_Centroid;
theta_Centroid = atand(deltaCentroid_Fraction); %This returns the arctan 
%of the function IN DEGREES

%Finding theta of the abdomen with respect to the static point
deltaX_Abdomen = Abdomen_X - StaticPoint_X;
deltaY_Abdomen = Abdomen_Y - StaticPoint_Y;
deltaAbdomen_Fraction = deltaY_Abdomen./deltaX_Abdomen;
theta_Abdomen = atand(deltaAbdomen_Fraction); %This returns the arctan 
%of the function IN DEGREES

%Fast Fourier transform stuff with subtracting the mean to reduce noise
stuff_centroid = fft(theta_Centroid-mean(theta_Centroid),L);
stuff_abdomen = fft(theta_Abdomen-mean(theta_Abdomen),L);

f = Fs*(0:(L/2))/L;
%% Find the Gain

%Gain of the signal
Gain = abs(stuff_abdomen(find(ismember(f,3))))/...
    abs(stuff_centroid(find(ismember(f,3))));
%find(ismember(f,3)) finds the location of the cell where the value of the
%frequency is 3 Hz. Taking the absolute value of the abdomen and the
%centroid at the 3 Hz frequency location gives us the gain.

%% Find the Phase difference

%Phase of the signal
Phase = (angle(stuff_abdomen(find(ismember(f,3))))-...
    angle(stuff_centroid(find(ismember(f,3)))))*180/pi;

%% Now to ouput the sucker
output(i,1) = cellstr(filename); %This will tell us what filename is 
%associated with this row of data
output(i,2) = cellstr(filename(4)); %This will distinguish whether the 
%data is the magnetic or non-magnetic category.
output(i,3) = cellstr(num2str(Gain)); %This is the gain of this particular 
%file
output(i,4) = cellstr(num2str(Phase)); %This is the phase difference 
%of this particular file
end

%The next line has our column headers as appropriate.
col_header={'Filename','MagneticOrNot','Gain','PhaseDifference(deg)'};

%The code below concatenates our output array with the appropriate column
%header array, for convenience.
output_mat1 = [col_header
    output];

filename1 = 'Gain_Phase_project.xlsx'; %This creates the Excel file.
xlswrite(filename1,output_mat1); %This outputs the appropriate data into 
%the appropriate sheet on Excel.

% Now we can manipulate our output matrix
Gain_m = output((find(ismember(output(:,2),'m'))),3);
Gain_nm = output((find(ismember(output(:,2),'n'))),3);
Phase_m = output((find(ismember(output(:,2),'m'))),4);
Phase_nm = output((find(ismember(output(:,2),'n'))),4);

%Mean(s)
Avg_Gain_m = mean(Gain_m)
Avg_Gain_nm = mean(Gain_nm)
Avg_Phase_m = mean(Phase_m)
Avg_Phase_nm = mean(Phase_nm)

%Standard deviation(s)
std_Gain_m = std(Gain_m)
std_Gain_nm = std(Gain_nm)
std_Phase_m = std(Phase_m)
std_Phase_nm = std(Phase_nm)
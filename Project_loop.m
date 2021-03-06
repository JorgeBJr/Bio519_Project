%% Project- iterative method to extract all values in an automated fashion
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

%Let's import the static points first
staticpts_raw = importdata('StaticPoints.xlsx',',',1);
staticpts_filename = staticpts_raw.textdata(:,1);
staticpts_data_X = staticpts_raw.data(:,1);
staticpts_data_Y = staticpts_raw.data(:,2);

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
data = csvread(filename,1,0); %This will import the 
%CSV file of the centroid (i.e. input stimulus) with the appropriate offset
%that imports the two columns without the headers. 

Centroid_X = data(:,5);
Centroid_Y = data(:,6);
Abdomen_X = data(:,1);
Abdomen_Y = data(:,2);
Wing_X = data(:,3); %This is for a post-Winter quarter project
Wing_Y = data(:,4); %This is for a post-Winter quarter project ;)

%Locate the static points
Static_location = find(ismember(staticpts_filename,filename));
StaticPoint_X = staticpts_data_X(Static_location-1);
StaticPoint_Y = staticpts_data_Y(Static_location-1);

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
output_mat1 = [col_header; output];

filename1 = 'Gain_Phase_project.xlsx'; %This creates the Excel file.
%xlswrite(filename1,output_mat1); %This outputs the appropriate data into 
%the appropriate sheet on Excel. For some reason this isn't working right
%now

% Now we can manipulate our output matrix
Gain_m = output((find(ismember(output(:,2),'m'))),3);
Gain_nm = output((find(ismember(output(:,2),'n'))),3);
Phase_m = output((find(ismember(output(:,2),'m'))),4);
Phase_nm = output((find(ismember(output(:,2),'n'))),4);
SampleSize_m = numel(Gain_m);
SampleSize_nm = numel(Gain_nm);

%Mean(s)
Avg_Gain_m = mean(str2double(Gain_m))
Avg_Gain_nm = mean(str2double(Gain_nm))
Avg_Phase_m = mean(str2double(Phase_m))
Avg_Phase_nm = mean(str2double(Phase_nm))
GainVals = [Avg_Gain_m; Avg_Gain_nm];
PhaseVals = [Avg_Phase_m; Avg_Phase_nm];

%Standard deviation(s)
std_Gain_m = std(str2double(Gain_m))
std_Gain_nm = std(str2double(Gain_nm))
std_Phase_m = std(str2double(Phase_m))
std_Phase_nm = std(str2double(Phase_nm))
StdGainVals = [std_Gain_m; std_Gain_nm];
StdPhaseVals = [std_Phase_m; std_Phase_nm];

%Two SEM
TwoSEM_Gain_m = 2*std_Gain_m/sqrt(SampleSize_m);
TwoSEM_Gain_nm = 2*std_Gain_nm/sqrt(SampleSize_nm);
TwoSEM_GainVals = [TwoSEM_Gain_m; TwoSEM_Gain_nm];

bar(GainVals, 0.4)
ylabel('Gain')
legend('1 = Magnets ON, 2 = Magnets OFF')
hold on;
errorbar(GainVals,StdGainVals,'k.')

figure;
bar(GainVals, 0.4)
ylabel('Gain')
legend('1 = Magnets ON, 2 = Magnets OFF')
hold on;
errorbar(GainVals,TwoSEM_GainVals,'k.')

%T-test for data
[h_gain, p_gain] = ttest(GainVals)
[h_phase, p_phase] = ttest(PhaseVals)
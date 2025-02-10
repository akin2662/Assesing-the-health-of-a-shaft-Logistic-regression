%{
This is the code to generate the LR model for health monitoring of the
vibration system
Group Members
Murilo Nicoluzzi
Advait Kinikar
Aniket Bharamgonda
%}


%%
clear all
clc


%% Code for extracting the healthy data

% Load training data set
% healthy data
healthydatafolder='C:\Users\abharamg\Box Sync\ENME691\HW\Homework 2\Training\Healthy';
fielpattern=fullfile(healthydatafolder, '*.txt');
textfiles=dir(fielpattern);
healthydata=zeros(length(textfiles),2);

for i=1:length(textfiles)
    healthyfileName=textfiles(i).name;
    filename=fullfile(textfiles(i).folder,healthyfileName);
    NS1=readmatrix(filename);
    [healthydata(i,1),healthydata(i,2)]=fFTonsignal(NS1);
end

%% Code for extracting the Faulty data and FFT on it

% Load training data set
% Faulty data
faultydatafolder='C:\Users\abharamg\Box Sync\ENME691\HW\Homework 2\Training\Faulty';
fielpattern=fullfile(faultydatafolder, '*.txt');
textfiles=dir(fielpattern);
faultydata=zeros(length(textfiles),2);

for i=1:length(textfiles)
    faultyfileName=textfiles(i).name;
    filename=fullfile(textfiles(i).folder,faultyfileName);
    U1=readmatrix(filename);
    [faultydata(i,1),faultydata(i,2)]=fFTonsignal(U1);
end

%% Plotting Healthy and Faulty Data

healthysamples=1:length(healthydata);
faultysamples=1:length(faultydata);

figure(1)
hold on
plot(faultysamples, faultydata(:,2),'-o');
xlabel('Sample','FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
ylabel('Amplitude', 'FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
set(gca,'FontSize',25, 'FontWeight', 'bold','FontName','Times New Roman');
title('Feature View', 'FontSize',45, 'FontName','Times New Roman');
plot(healthysamples, healthydata(:,2),'-o');

hold off

%% Plotting Healthy and Faulty Data
Feq=2560;
tstart=0;
t=1/Feq;
L=length(NS1);
time=(0:(L-1))*t;

figure(2)
hold on 
plot(time, NS1);
xlabel('Time','FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
ylabel('Amplitude', 'FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
set(gca,'FontSize',25, 'FontWeight', 'bold','FontName','Times New Roman');
title('Healthy Data', 'FontSize',45, 'FontName','Times New Roman');
hold off

figure(3)
hold on 
plot(time, U1);
xlabel('Time','FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
ylabel('Amplitude', 'FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
set(gca,'FontSize',25, 'FontWeight', 'bold','FontName','Times New Roman');
title('Faulty Data', 'FontSize',45, 'FontName','Times New Roman');
hold off

%% Training the LR model

Label=[ones(size(healthydata,1),1)*0.95; ones(size(faultydata,1),1)*0.05];
beta = glmfit([healthydata; faultydata],Label,'binomial');

%%  Code for extracting the Test data and FFT on it
testingdatafolder='C:\Users\abharamg\Box Sync\ENME691\HW\Homework 2\Training\Testing';
fielpattern=fullfile(testingdatafolder, '*.txt');
textfiles=dir(fielpattern);
testingdata=zeros(length(textfiles),2);

for i=1:length(textfiles)
    testingfileName=textfiles(i).name;
    filename=fullfile(textfiles(i).folder,testingfileName);
    T1=readmatrix(filename);
    [testingdata(i,1),testingdata(i,2)]=fFTonsignal(T1);
end

%% Plotting Testing Data

testingsamples=1:length(testingdata);

figure(4)
hold on
plot(testingsamples, testingdata(:,1),'-o');
xlabel('Sample','FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
ylabel('Amplitude', 'FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
set(gca,'FontSize',25, 'FontWeight', 'bold','FontName','Times New Roman');
title('Feature View', 'FontSize',45, 'FontName','Times New Roman');
hold off

%% Health Value LR Model

CV_Test = glmval(beta,testingdata,'logit') ;  %Use LR Model

%% Plotting CV Results
figure(5)
hold on
plot(testingsamples, CV_Test,'-o');
xlabel('Test Sample #','FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
ylabel('CV', 'FontSize',30,'FontWeight', 'bold', 'FontName','Times New Roman');
set(gca,'FontSize',25, 'FontWeight', 'bold','FontName','Times New Roman');
title('Model Testing', 'FontSize',45, 'FontName','Times New Roman');
hold off

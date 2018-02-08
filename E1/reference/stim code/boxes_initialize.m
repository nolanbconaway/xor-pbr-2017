clc; close all; clear

% - - - - - - - - - - - - - - - - - - - - - -
% GENERAL SPECIFICATIONS
numpositions=7;
savesize=[320, 320]; % size of saved images in pixels
savesize=savesize/2.0833; % i don't know why you have to do this

generalaxis=[0 10 0 10];
middle=mean(generalaxis);
figurewidth=9.5 ;
lwidth=2;

% get folder name
time=fix(clock); time=time(4:6);
folder=[pwd '/full-' ...
	num2str(time(1)) '-' num2str(time(2)) '-' num2str(time(3)) '/'] ;
mkdir(folder);addpath(folder)

% - - - - - - - - - - - - - - - - - - - - - -
% SPECIFICATIONS FOR THE SQUARE SIZE

sizestart=1.5;
sizestop=4;
sizeincrement=(sizestop-sizestart)/(numpositions-1);
baseline=2;

% - - - - - - - - - - - - - - - - - - - - - -
% SPECIFICATIONS FOR THE shading

shadestart=.1;
shadestop=.9;
shadeincrement=(shadestop-shadestart)/(numpositions-1);

% - - - - - - - - - - - - - - - - - - - - - -
% CREATE IMAGES
boxes_run

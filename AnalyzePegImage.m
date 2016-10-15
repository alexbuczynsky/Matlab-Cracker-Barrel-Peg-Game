function [ positions ] = AnalyzePegImage( imageName )
%AnalyzePegImage Find peg locations of a Cracker Barrel Peg Game
%   Input some image e.g. AnalyzePegImage('MyImage.png')
%   Ouput a Vector of length 15 with peg positions
%
%
%
%   TITLE: COP2271 - Final Project
%   AUTHORS: Alexander Buczynsky, Vraj Patel

%% load image
%image values
[img,map1]     = imread(imageName);
r       = img(:,:,1);
g       = img(:,:,2);
b       = img(:,:,3);
binaryPegs   = false(size(img,1), size(img,2));
binaryBoard  = false(size(img,1), size(img,2));
%Threshold values [min, max]
%% Pegs
pegTr = [0   30];
pegTg = [0   40];
pegTb = [50 200];
%Create threshold image for Pegs
binaryPegs(...
    (r >= min(pegTr) & r <= max(pegTr)) &...
    (g >= min(pegTg) & g <= max(pegTg)) &...
    (b >= min(pegTb) & b <= max(pegTb))  ...
    ) = 1;

%FIND RADIUS (IN PIXELS) OF PEGS
[pegR,pegC] = find(binaryPegs==1);
boardTop = min(pegR);
ii  = min(pegR);
C   = find(binaryPegs(min(pegR),:)== 1,1);
while true
    if sum(binaryPegs(ii+1:ii+10,C)) == 0
        diameter = abs(min(pegR)-ii);
        break
    end
    ii = ii + 1;
end
%% Board
boardTr = [165  205];
boardTg = [145  190];
boardTb = [100  159];

%Create threshold image for Board
binaryBoard(...
    (r >= min(boardTr) & r <= max(boardTr)) &...
    (g >= min(boardTg) & g <= max(boardTg)) &...
    (b >= min(boardTb) & b <= max(boardTb))  ...
    ) = 1;
%board dimensions
[binaryR,binaryC] = find(binaryBoard == 1);
boardLeft   = [max(binaryR), min(binaryC)];
boardRight  = [max(binaryR), max(binaryC)];
boardTop    = [min(binaryR), round((max(binaryC)+min(binaryC))/2)];

%% RATIO MADNESS
boardH = abs(boardTop(1)-boardLeft(1));
boardB = abs(boardLeft(2)-boardRight(2));

%check all rows for pegs
positions = zeros(1,15);
axisR = boardTop(1);
axisC = boardTop(2);
row = round(axisR+1/7*boardH);
radius = round(diameter/2);
n = 0;
count = 1;
interval = 0.09*boardB;
for R = 1:5
    pos = axisC-n;
    while pos >= axisC-n && pos <= axisC+n
        if ...
                any(binaryPegs(row,(pos-radius):(pos+radius)) == 1) ||...
                any(binaryPegs((row-radius):(row+radius),pos) == 1)
            positions(count) = 1;
        end
        count   = count + 1;
        pos     = round(pos + 2*interval);
    end
    row = round(row + 3/16*boardH);
    n   = ceil(n + interval);
end
end
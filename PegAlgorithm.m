function [ solutionPaths ] = PegAlgorithm( boardStart )
%PegAlgorithm 
%   Given a vector of length 15 with peg positions, calculate all possible
%   solution that result in one peg remaining.
%   Input: vector of length 15 containing only 1's and 0's
%   Output: 2D matrix of solution paths
%
%
%
%   TITLE: COP2271 - Final Project
%   AUTHORS: Alexander Buczynsky, Vraj Patel

%% Original peg positions
startVal = find(boardStart == 1);

%% Possible Jumps
    % A list of all possible jumps
possibleJumps = {}';
    possibleJumps{01}   =   [01 02 04; 01 03 06];
    possibleJumps{02}   =   [02 04 07; 02 05 09];
    possibleJumps{03}   =   [03 05 08; 03 06 10];
    possibleJumps{04}   =   [04 02 01; 04 05 06; 04 07 11; 04 08 13];
    possibleJumps{05}   =   [05 08 12; 05 09 14];
    possibleJumps{06}   =   [06 03 01; 06 05 04; 06 09 13; 06 10 15];
    possibleJumps{07}   =   [07 04 02; 07 08 09];
    possibleJumps{08}   =   [08 05 03; 08 09 10];
    possibleJumps{09}   =   [09 05 02; 09 08 07];
    possibleJumps{10}   =   [10 06 03; 10 09 08];
    possibleJumps{11}   =   [11 07 04; 11 12 13];
    possibleJumps{12}   =   [12 08 05; 12 13 14];
    possibleJumps{13}   =   [13 12 11; 13 08 04; 13 09 06; 13 14 15];
    possibleJumps{14}   =   [14 13 12; 14 09 05];
    possibleJumps{15}   =   [15 10 06; 15 14 13];

%% Setup Explore List
    %The explorelist is configured in this way:
    %explorelist{index} = {row,parentID,childBoard}
        %row:           the path taken at an index (e.g. [13 12 11])
        
        %parentID:      the previous index from where the jump started.
            %NOTE: if the parentID is -1, there is no parentID and it is
            %the first move or jump.
            
        %childBoard:    the board after the jump (row) has occured.
        
explorelist = {};   index = 1;

%All values that are possible given the initial board's peg layout:
for ii = 1:size(startVal,2)
    for jj = 1:size(possibleJumps{startVal(ii)})
        childBoard = boardStart;
        row = possibleJumps{startVal(ii)}(jj,:);
        
        %-------------------IF JUMP AT ROW IS POSSIBLE--------------------%
        if ...
                childBoard(row(1)) == 1 &&...
                childBoard(row(2)) == 1 &&...
                childBoard(row(3)) == 0
            
            childBoard(row(1))  =   0;
            childBoard(row(2))  =   0; 
            childBoard(row(3))  =   1;
            explorelist{index}  =   {row,-1,childBoard};
            index               =   index + 1;
        end
    end
end

%% Explore All Paths
%start at index 1 and end at the last column
parentID = 0;   solution = 0;   solutionIndeces = [];

while true
    parentID = parentID + 1;
    
    %If the parentID exceeds the size of the explorelist, the loop should
    %terminate...
    if parentID > size(explorelist,2)
        break
    end
    
    parentBoard     =  explorelist{parentID}{3};
    parentStartVal  =  find(parentBoard == 1); 
    for ii = 1:length(parentStartVal)
        move = possibleJumps{parentStartVal(ii)};
        for jj = 1:size(move,1)
            row = move(jj,:);
            %-----------------IF JUMP AT ROW IS POSSIBLE------------------%
            if ...
                    parentBoard(row(1)) == 1 &&...
                    parentBoard(row(2)) == 1 && ...
                    parentBoard(row(3)) == 0
                
                childBoard          = parentBoard;
                childBoard(row(1))  = 0;
                childBoard(row(2))  = 0; 
                childBoard(row(3))  = 1;
                explorelist{index}  = {row,parentID,childBoard};
                
                %---------------CHECK IF SOLUTION EXISTS------------------%
                if sum(childBoard) == 1
                    solution = solution + 1;
                    %index where solution is found:
                    solutionIndeces(solution) = index; 
                end
                index = index + 1;
            end
        end
    end
end

%% Find Solution Paths
solutionPaths = zeros(2,2);

for ii = 1:solution
    %Starting values
    jj = 1;
    parentID = 1; %value of 1 is just a placeholder
    
    %start (Value of peg jumped from), finish (value of peg jumped to)
    start  = explorelist{solutionIndeces(ii)}{1}(1);
    finish = explorelist{solutionIndeces(ii)}{1}(3);
    solutionPaths(ii, jj)   = finish;
    solutionPaths(ii, jj+1) = start;
    jj = jj + 2;
    parentID = explorelist{solutionIndeces(ii)}{2};
    while true
        %parentID of the current index
        if parentID == -1
            break
        end
        start   = explorelist{parentID}{1}(1);
        finish  = explorelist{parentID}{1}(3);
        solutionPaths(ii, jj)   = finish;
        solutionPaths(ii, jj+1) = start;
        parentID = explorelist{parentID}{2};
        jj = jj + 2; 
    end
end
solutionPaths = flip(solutionPaths,2);
solutionPaths = flip(solutionPaths,1);
keyboard
end
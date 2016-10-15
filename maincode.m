%TITLE: COP2271 - Final Project
%AUTHORS: Alexander Buczynsky, Vraj Patel

clc;clear;
for ii = 1:10
    tic
    fprintf('\n\n%%---------------IMAGE: %.2d.png---------------%%\n\n',ii)
    image = sprintf('%.2d.png',ii);
    vector = AnalyzePegImage(image);
    fprintf('%d',vector)
    fprintf('\n')
    fprintf('Solutions: %d\n', size(PegAlgorithm(vector)) )
    toc
end
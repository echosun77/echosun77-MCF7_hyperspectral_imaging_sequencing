

% features for Yike


% Steps: 

% step1: Extract cell region: "A" is the matrix of the specific region

% step2: Calculate mean value of each channel: "X(i)"is the mean cell value of
% channle i

% Feature set 1: average cell value: each cell average is one feature

X(i)= mean(A);


% feature set 2:  feature ratios RA(k): the ratio of X(i) and X(j): i and j are channel numbers


RA(k)= X(i)/X(j);


% feature set 3: first order features: you need to compute for each channel
% and find the ratios

Var(i)=var(A);            %variance of the image
Kurt(i)=kurtosis(A);      %kurtosis of the image
Skew(i) = skewness(A);    % skewness of the image













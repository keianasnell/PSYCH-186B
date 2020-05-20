% PROBLEM 3

dimensions = [10, 20, 50, 100, 250, 500, 1000, 2000];
num_tries = 10 %if num_tries is significantly large (>100), program takes FOREVER to run

final = [];

for t = 1 : num_tries
    for d = dimensions
        values = dp(d);
        final = [final ; values];
    end
end

histogram(final);
% m = mean(final);
% s = std(final);

function [result] = dp(d)
    rng('default');
    A = randn(d);
    A = A/norm(A);
    B = randn(d);
    B = B/norm(B);
    
    result = dot(A,B,2);

end


% (a) What does this dot product actually mean, geometrically?
%       It gives the cosine of the angle between the two vectors.

% (b) Compute the mean and standard deviations of each dot product.
%     Dimension: 10, Mean: 0.016870, Standard Deviation: 0.070442
%     Dimension: 20, Mean: 0.021135, Standard Deviation: 0.056084
%     Dimension: 50, Mean: -0.011957, Standard Deviation: 0.038293
%     Dimension: 100, Mean: 0.001607, Standard Deviation: 0.026466
%     Dimension: 250, Mean: -0.000320, Standard Deviation: 0.017231
%     Dimension: 500, Mean: 0.000515, Standard Deviation: 0.011262
%     Dimension: 1000, Mean: -0.000051, Standard Deviation: 0.007647
%     Dimension: 2000, Mean: -0.000153, Standard Deviation: 0.005643

% (c) What should the mean of the resulting distribution of dot products
% be (and why) and compare it with your results.
%       The mean should be 0. Because there is a degree of error that is
%       expected with the generation of random numbers on a computer, my
%       results did not come up with the exact match of the expected mean.


% (e) Guess "roughly" what the standard deviation of the resulting
% distribution of dot product.
%       From my results, it looks like the standard deviation should also
%       be 0. I would expect that increasing the dimension would decrease
%       the result of standard deviation (with more data available in the
%       vector to change the dot product).
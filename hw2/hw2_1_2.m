% PROBLEM 1
% see if the system can associate a single pair of vectors. 

%  (a) Generate two vectors f, g.  (Use dimensionality of 100)
dim = 100;
f = [];
g = [];

% rand function 'draws values from a uniform distribution in the open
% interval (a,b)'
% subtract 0.5 to set mean values to 0
rng('default');
a = 0;
b = 1;
f = (b-a).*rand(dim,1) + a - 0.5;
g = (b-a).*rand(dim,1) + a - 0.5;
% mean(f)
% mean(g)

%  (c) Normalize them, i.e. set the lengths to equal one. 
f = f / norm(f);
g = g / norm(g);
% norm(f)
% norm(g)

%  (d) Compute A. 
A = g*(f.');

g_prime = A*f;

% (e) Compute the cosine between g and g’ to demonstrate that they are in the same direction. 
% It should be one. 
g_angle = (dot(g_prime, g)/(norm(g_prime)*(norm(g))))

% Compute the length of g’.  It should be also one.
length_g_prime = sqrt(dot(g_prime,g_prime))  % can also use norm(g_prime)



% PROBLEM 2
% see if the system can discriminate between new and old input vectors.

%  (a) Generate a new normalized random vector, f'.
f_prime = [];
f_prime = (b-a).*rand(dim,1) + a - 0.5;
f_prime = f_prime / norm(f_prime);

%  (b) Check to see if it is more or less orthogonal to f by looking at the cosine of the angle between f and f'.  
f_angle = (dot(f_prime, f)/(norm(f_prime)*(norm(f))))

%  (c) Compute Af' and look at the length of this vector.  What do you think it should be?  What is it?
%       The length of Af' comes out to ~0.
A_f_prime = A*f_prime;
length_A_f_prime = sqrt(dot(A_f_prime,A_f_prime)) % can also use norm(A_f_prime)

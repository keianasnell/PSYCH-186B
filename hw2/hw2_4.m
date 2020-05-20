% PROBLEM 4
%{
  (A) Destroy parts of the matrix at random (by setting random indexes to zero) and see how it distorts the output.  
      One of the virtues of matrix models is generally felt to be their resistance to noise and damage.  
      You can use the cosine between pre- and post- ablated outputs as a measure of damage.  
%}

rng('default');
A = zeros(100,100);
num_pairs = 100;
dim = 100;
f_total= {};
g_total = {};

for pair = 1 : num_pairs
    f = generate_pairs(dim);
    f_total{pair} = f;
    g = generate_pairs(dim);
    g_total{pair} = g;
    Ai = g*(f.');
    A = A + Ai;
end

A_destr = A;

% destroy x% (`num` # of values) in the matrix to simulate ablation
num = 1000;
rand_destr = randi([1,100],num,2);
for i = 1 : num
    x = rand_destr(i,1) ;
    y = rand_destr(i,2);
    A_destr(x, y) = 0;
end

avg_angle = 0;

for i = 1 : length(f_total)
    g_i = A*f_total{i};
    g_ii = A_destr*f_total{i};
    g_angle = (dot(g_i, g_ii)/(norm(g_i)*(norm(g_ii))));
    avg_angle = avg_angle + g_angle;
end

avg_angle = avg_angle/num_pairs

%{ 
    CHANGE IN COSINE WITH INCREASE IN DESTRUCTION OF MATRIX
    We have an expected value of 1.000 if the pre- and post- ablated outputs are the same.

    Number of cells destroyed            Average angle
    0                                    1.000
    100                                  0.9974
    500                                  0.9876
    1000                                 0.9752
    5000                                 0.8686
    7500                                 0.7989
    10000                                0.7417

    There's a discrepancy in the decrease of the avg. angle with increased
    # of cells destroyed because of the potential of repeated values from
    the random number generator. It demonstrates the strength of the matrix
    despite significant damage.
     
%}

function vec = generate_pairs(dim)
    a = 0;
    b = 1;
    vec = (b-a).*rand(dim,1) + a - 0.5;
    vec = vec / norm(vec);
end
% PROBLEM 3
rng('default');


% (e) Repeat (a) – (d) for different numbers of pairs of stored vectors.
num_num_pairs = [1, 20, 40, 60, 80, 100];
dim = 100;


for x = 1 : length(num_num_pairs)
    num_pairs = num_num_pairs(x);
    A = zeros(100,100);
    f_total = {};
    g_total = {};
    total_g_length = 0;
    
   
    for pair = 1 : num_pairs
        index = mod(num_pairs, pair-1) + 1
        f = generate_pairs(dim);
        f_total{pair} = f;
        g = generate_pairs(dim);
        g_total{pair} = g;
        length_g = sqrt(dot(g,g));
        total_g_length = total_g_length + length_g;
       % (b) Compute the outer product matrices, Ai = gi*fiT.
        Ai = g*(f.');
       % (c) Form the overall connectivity matrix, A
        A = A + Ai;
    end

    for i = 1 : length(f_total)
        % (d)(i) Compute the predicted output, let’s call it g’,  for each stored input, fi using A.
        g_i = A*f_total{i};
        % (d)(ii) Compute the cosine between your predicted output, g’, and the actual/observed output gi.
        g_angle = (dot(g_i, g)/(norm(g_i)*(norm(g))));
        % (d)(iii) Compute the length of the output vector, g’.
        length_g_i = sqrt(dot(g_i,g_i));
    end


    % (d)(iv) Test the selectivity with a new set of 50 random vectors `h` and
    % testing against A.
    h_i_total = {};
    total_h_i_length = 0; 
    for pair = 1 : num_pairs
        h = generate_pairs(dim);
        h_i = A*h;
        h_i_total{pair} = h_i;
        length_h_i = sqrt(dot(h_i,h_i));
        total_h_i_length = total_h_i_length + length_h_i;
    end

    
    % Compare the average length of hi’ to the average length of gi. 
    avg_g_length = total_g_length/num_pairs;
    avg_h_i_length = total_h_i_length/num_pairs;
end


function vec = generate_pairs(dim)
    a = 0;
    b = 1;
    vec = (b-a).*rand(dim,1) + a - 0.5;
    vec = vec / norm(vec);
end
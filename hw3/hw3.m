rng('shuffle')

num_num_pairs = [20, 40, 60, 80];
dim = 100;
epsilon = 0.0001;
k = 0.1; 
overall_A = zeros(dim, dim);

for x = 1 : length(num_num_pairs)
    num_pairs = num_num_pairs(x);
    f_total = {};
    g_total = {};
    A = zeros(dim,dim,num_pairs);
    total_g_length = 0;
   
    for pair = 1 : num_pairs
        f = generate_pairs(dim);
        f_total{pair} = f;
        g = generate_pairs(dim);
        g_total{pair} = g;
        Ai = g*(f.');
        A(:,:,pair) = Ai;
    end
end

%calculate overall A (sum of all Ai) 
for i = 1:dim
    for j = 1:dim
        overall_A(i,j) = sum(A(i,j,:));
    end
end

cos = zeros(200, 1);
chance_cos = zeros(200,1);
count = 1;
while count < 200
    %(d)(ii) to present associations in random order
    index = round(rand(1) * (num_pairs-1) + 1);
    %(d)(i) to present associations in sequence
    %index = mod(count, num_pairs-1) + 1;

    f_curr = f_total{index};
    g_curr = g_total{index};
    
    % (a)(i)  uses k value of constant 0.1 (as defined above)
    % (a)(ii) uses decreasing value of k
    %  vvv    to do so, uncomment the line below
    % k = k/count; 
   
    % Get 'actual' output vector (Afk or g')
    g_i = A(:,:,index)*f_curr;
    delta_A = widrow_hoff(g_curr, g_i, f_curr, k);
    % Update A
    A(:,:,index) = A(:,:,index) + delta_A;
    for i = 1:dim
        for j = 1:dim
            overall_A(i,j) = sum(A(i,j,:));
        end
    end
    

    g_prime = overall_A * f_curr;
    g_angle = dot(g_curr, g_prime);
    cos(count, 1) = g_angle;

    chance_vec = generate_pairs(dim);
    chance_g = A(:,:,index) * chance_vec;
    chance_cos(count,1) = dot(g_curr, chance_g);    
    
    count = count + 1;
end


% (b) How long it takes to converge.
% Use error decrease smaller than 1% (from the previous iteration) as your
% criterion for convergence
for c_counter = 50:count
    mov_avg = mean(cos(c_counter - 49:c_counter,1));
    if mov_avg > 0.99 && mov_avg < 1.01
        break;
    end
end

% plot(cos(1:count,1));
% hold on;
% plot(chance_cos(1:count));
 

function vec = generate_pairs(dim)
    a = 0;
    b = 1;
    vec = (b-a).*rand(dim,1) + a - 0.5;
    vec = vec / norm(vec);
end

function delta_A = widrow_hoff(correct_g, actual_g, f, k)
    difference_vector = correct_g - actual_g;
    weighted_vector = k * difference_vector;
    delta_A = weighted_vector*(f'); 
end


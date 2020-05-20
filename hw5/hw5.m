% HW5 - Train linear associator to identify the origins of ships based on sensor scans
    
ships = readtable('training_set.csv');
ships = table2array(ships);
noisy_ships = readtable('noisy_set.csv');
noisy_ships = table2array(noisy_ships);

num_features = 6; %number of features
num_ships = 20;

for i = 1 : num_ships
   ships(1:6,i) = ships(1:6,i) / norm(ships(1:6,i));
   noisy_ships(1:6,i) = noisy_ships(1:6,i) / norm(noisy_ships(1:6,i));
end

klingons = ships(:,1:5);
k_mean = mean(klingons,2);

romulans = ships(:,6:10);
r_mean = mean(romulans,2);

antareans = ships(:,11:15);
a_mean = mean(antareans,2);

federations = ships(:,16:20);
f_mean = mean(federations,2);

k = .1;
A = zeros(6,6);
rng('shuffle');
num_iterations = 10000;

for i = 1 : num_iterations
    index = randi(20);
    f = ships(1:6,index);
    f = f/norm(f);
    
    origin = ships(7,index);
    if origin == 1
        g = k_mean(1:6, 1);
    elseif origin == 2
        g = r_mean(1:6, 1);
    elseif origin == 3
        g = a_mean(1:6, 1);
    elseif origin == 4
        g = f_mean(1:6, 1);
    end
 
    Ai = g*(f.');
    A = A + Ai;
    g_i = A*f;
    g_i = g_i/norm(g_i);
    d_A = widrow_hoff(g, g_i, f, k);
    A = A + d_A;
end

predictions = zeros(20,1);

for j = 1 : num_ships
    f = noisy_ships(1:6,j);
    g_i = A*f;
    g_i = g_i/norm(g_i);
   
    dif_k = abs(1-dot(g_i,k_mean(1:6,1)));
    dif_r = abs(1-dot(g_i,r_mean(1:6,1)));
    dif_a = abs(1-dot(g_i,a_mean(1:6,1)));
    dif_f = abs(1-dot(g_i,f_mean(1:6,1)));
    
    differences = [dif_k dif_r dif_a dif_f];
    smallest = min(differences);
    prediction = 0;
    
    if smallest == dif_k
        prediction = 1;
    elseif smallest == dif_r
        prediction = 2;
    elseif smallest == dif_a
        prediction = 3;
    elseif smallest == dif_f
        prediction = 4;
    end
    
    predictions(j,1) = prediction;
end


for k = 1 : num_ships
    prediction = predictions(k,1);
    if prediction == 1
        origin = 'Klingon';
        action = 'Hostile';
    elseif prediction == 2
        origin = 'Romulan';
        action = 'Alert';
    elseif prediction == 3
        origin = 'Antarean';
        action = 'Friendly';
    elseif prediction == 4
        origin = 'Federation';
        action = 'Friendly';
    end
    
    fprintf('Ship origin: %s\t\t Required action: %s\n', origin, action);
end


function delta_A = widrow_hoff(correct_g, actual_g, f, k)
    difference_vector = correct_g - actual_g;
    weighted_vector = k * difference_vector;
    delta_A = weighted_vector*(f'); 
end

function score = justMCMC(N, d, it, particles, observation)
    %Assuming that d is the number of params that define the distribution
    %of the poses
    %N is the number of particles that describe the distribution
    %it is the number of iterations limited for this
    
    %Sample N d particles (d is the mxd_ where m is the number of objects
    %and d_ is 6 degree of pose of the object)
    
    %P({d}/Z) propto P(Z/{d})*P({d})
    
    %Initial state P({d}) is uniform
    %P(Z/{d}) is the likelihood I generate
    
    %particles = rand(N, d);
    %observation = rand(1, d);
    sigma = 0.2;
    
    %Un-normalized likelihood for all the N particles
    likelihood = measurementUpdate(particles, observation, N, sigma);
    score = zeros(1, it);
    for n=1:it
        prop_width = 1;
        for i=1:N
            temp = particles(i, :) + normrnd(0, 0.025, [1, d]).*prop_width;
            diff_t = temp - observation;
            diff_t = diff_t*diff_t';
            diff_e = exp(-diff_t/(2*sigma^2));   
            if(diff_e > likelihood(1, i))
                likelihood(1, i) = diff_e;
                particles(i, :) = temp(1, :);
            end   

        end
        [v, ind] = min(likelihood);
        score_t = observation - particles(ind, :);
        score(1, n) = score_t*score_t'; 
        
    end
end

function likelihood = measurementUpdate(p, o, N, sigma)
    diff = zeros(1, N);
    for i=1:N
       temp = p(i, :) - o;
       temp = temp*temp';
       diff(1, i) = exp(-temp/(2*sigma^2));
    end
    likelihood = diff;
end
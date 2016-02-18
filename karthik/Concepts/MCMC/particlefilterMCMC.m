%function [dist, iterations] = particlefilterMCMC(obs, par, N, d, it, isMCMC)
function dist = particlefilterMCMC(obs, par, N, d, it, isMCMC)
    %Get observation simulated
    %obs = generateObservation(d);
    sigma = 0.2;

    %Generate N particles
    %par = rand(N, d);
   
    par_obs = par;
    prev = zeros(N, d);
    dist = zeros(1, N);
    for t=1:it
        %Measurement model P(Z/X)
        diff = measurementUpdate(N, obs, par_obs, sigma);
        prev = par;
        if(isMCMC==1)
            %MCMC sampling
            for q=1:10
                [par, diff] = MCMCSampling(par, diff, N, obs, sigma, par_obs);
            end
        end
        %else
        %Important sampling
        par = importantSampling(par, diff, N);

        %Diffusion 
        noise = 0.005*normrnd(0, 0.2, [N, d])
        prev = par;
        par = par + noise;
        par(par > 1)=1;
        par(par < 0)=0;                              
        %end
        par_obs = par;
        [v, i] = max(diff);
        temp_d = par_obs(i, :)-obs;
        dist(1, t) = temp_d*temp_d';
        
    end
     prev
     [v, i] = max(diff);
     est = prev(i, :)
     obs
     %iterations = it
     %dist = obs - est;
     %dist = dist*dist';
end

function diff = measurementUpdate(N, obs, par_obs, sigma)
    diff_o = zeros(1, N);
    for i=1:N
       temp1 = par_obs(i, :) - obs;
       temp = temp1*temp1';
       diff_o(1, i) = exp(-sum(temp)/(2*sigma^2));%/(sigma*sqrt(2*pi));
    end
    diff = diff_o./sum(diff_o);
end

function obs = generateObservation(d)
    %Six dimentional readings
    obs = rand(1, d);
end

function par = importantSampling(old, score, n_par)
    
    prior = score;
    cdf = zeros(1, size(prior, 2));
    for i=1:size(prior, 2)
        cdf(i) = sum(prior(1:i));
    end
    %Sample from cdf 
    r = rand(1, n_par); %Randomly generate particles just less than the actual number
    pos_ind = zeros(1, n_par);
    for i=1:n_par
        for j=1:n_par
           if(cdf(j) >= r(i))
               pos_ind(i) = j;
               break;
           end
        end
    end
    %old
    %pos_ind
    par = old(pos_ind, :);
    new_par = par
end

function [par, score] = MCMCSampling(old, score, n_par, obs, sigma, par_obs)
    d = size(old, 2);
    par = old;
    for i=1:n_par
       %prop_width = 1-score(1, i);
       prop_width = 1;
       par(i, :) = par(i, :)+normrnd(0, 0.025, [1, d]).*prop_width;
       new_par = par(i, :);
       new_par(new_par > 1)=1;
       new_par(new_par < 0)=0;
       par(i, :) = new_par;
       %Check with par where i changed now
       check=checkProposed(obs, n_par, old(i, :), sigma);
       if(check==0)
           disp(i);
           disp('yes');
           par(i) = old(i);
           
       end       
    end   
    score = measurementUpdate(n_par, obs, par, sigma);
    
end

function yesorno = checkProposed(obs, par_e, old_e, s)
    old_d = obs - old_e;
    par_d = obs - par_e;
    score_o = old_d*old_d'
    score_n = par_d*par_d'
    escore_o = exp(-score_o/(2*s^2));
    escore_n = exp(-score_n/(2*s^2));
    if(escore_o < escore_n)
        yesorno = 1;
        
    else
        yesorno = 0;
        
    end    
end
function [Imp, MC, MCMC] = runParticleFilter(M, N, it, d)
    observations = rand(M, d);
    particles = rand(N, d);

    %Choose an observation
    obs = observations(1, :);
    
    bestDistImp = particlefilterMCMC(observations(1, :), particles, N, d, it, 0);
    bestDistMC = particlefilterMCMC(observations(1, :), particles, N, d, it, 1);
    bestDistMCMC = justMCMC(N, d, it, particles, observations(1, :));
    Imp = bestDistImp;
    MC  = bestDistMC;
    MCMC = bestDistMCMC;

end
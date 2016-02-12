function plotfunction(D, it, M, N)
    m = 9;
    fig = figure;
    for i=1:m
        [Imp, MC] = runParticleFilter(M, N, it, D(1, i))
        subplot(3, 3, i)
        X = 1:it;
        plot(X, Imp, X, MC);
        title(['Plot with ' num2str(D(1,i)) ' as dimension of state space']);
    end
    %print(fig, 'DimensionplotMCvsNoMC','-dpng')
end
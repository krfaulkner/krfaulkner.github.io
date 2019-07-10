% epidemic simulator with interventions

% % % PARAMETERS % % %
% Population size
N = 1;
% Population turn-over rate (birth and death rate)
r = 1;
% Infectiveness of virus (rate of I and S contact, probability contact
% results in infection)
beta = 8;
% Recovery rate of infection (probability that in infected person recovers)
gamma = 0.6;
% Vaccination rate and effectiveness (probability that in infected person recovers)
v = 0;

% function dydt = EpiSim(t,y)
% dydt = [r*N-r*y(1)-beta*y(1)*y(2); beta*y(1)*y(2)-gamma*y(2)-r*y(2)];
% end
T1 = 0;
T2 = 1;
I1 = 0.001*N;
S1 = N-I1;

[t,y] = ode45(@(t,y) [r*N-r*y(1)-beta*y(1)*y(2)-v*y(1); beta*y(1)*y(2)-gamma*y(2)-r*y(2)],[T1 T2],[S1; I1]);

Recov=N-y(:,1)-y(:,2);

figure
hold on
plot(t,y(:,1), '-b', 'DisplayName', 'Susceptible', 'LineWidth', 4)
plot(t,y(:,2), '--r', 'DisplayName', 'Infected', 'LineWidth', 4)
plot(t,Recov, ':g', 'DisplayName', 'Recovered', 'LineWidth', 4)
legend('Location','EastOutside','AutoUpdate','off')
line([5 5], [0 100], 'Color', [0.3 0.3 0.3], 'LineWidth', 2)
% xline(5,'-',{'Intervention 1','Vaccines'})
xlim([0 4])
ylim([0 N])
xlabel('Time (years)')
ylabel('Population')
set(findall(gcf,'-property','FontSize'),'FontSize',18)

for i=1:5
    disp('Make your intervention now by updating a parameter or the model. Click F5 when done.')
    keyboard
    disp('Intervention processing...')

    T1 = T1+1;
    T2 = T2+1;
    
    S1 = y(length(y(:,1)),1);
    I1 = y(length(y(:,2)),2);
    if (y(length(y(:,1)),1)+y(length(y(:,2)),2)+Recov(length(y(:,1)),1)) ~= N
        oldN=y(length(y(:,1)),1)+y(length(y(:,2)),2)+Recov(length(y(:,1)),1);
        S1=N*S1/oldN;
        I1=N*I1/oldN;
    end
    
    [t,y] = ode45(@(t,y) [r*N-r*y(1)-beta*y(1)*y(2)-v*y(1); beta*y(1)*y(2)-gamma*y(2)-r*y(2)],[T1 T2],[S1; I1]);

    Recov=N-y(:,1)-y(:,2);
    
    hold on
    plot(t,y(:,1), '-b', 'DisplayName', 'Susceptible', 'LineWidth', 4)
    plot(t,y(:,2), '--r', 'DisplayName', 'Infected', 'LineWidth', 4)
    plot(t,Recov, ':g', 'DisplayName', 'Recovered', 'LineWidth', 4)
    line([T1 T1], [0 N], 'Color', [0.3 0.3 0.3], 'LineWidth', 2)
end

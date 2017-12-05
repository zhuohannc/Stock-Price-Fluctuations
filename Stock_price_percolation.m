%
%   A Percolation Model of Stock Price Fluctuations
%       This program tries to simulate the general alogoritm shown in the
%       paper. In the paper, the author used NIKKEI 225's data for the
%       simulation. This program uses S&P 500 instead. This program only
%       uses the aforementioned paper as a general guideline. Changes were
%       made to better suit the data.
% 
%   Title     : A Percolation Model of Stock Price Fluctuations 
%             (Mathematical Economics : Mathematical Finance)
%   Author    : Tanaka, Hisatoshi
%   Publisher : ???????????
%   URL       : http://hdl.handle.net/2433/42059
%
%   By Zhuo Hann Cheah.
%



% the 2 variables below are not necessary and removing it will not change
% the result

pricecheck = 0;         %this is used to check whether the price is at certain value at certain day
runtimes = 1;           % this will show how many runs were ran to meet the price check value

L = 10;                 % the length of the lattice L*L
days = input('Days: '); % input for how many days to run 
alpha = 0.213948394;    % alpha value 
sigma = 0.320575857;    % sigma value
row = 0.002;            % row value
onoff = 0;              % setting this to 0 will make sure the graph produces has a certain val at certain time.

while pricecheck ~= 1
    i = 1;
    j = 1;
    lattice = zeros(L,L);
    
    % After generating an L*L size lattice, the while loop procedes to fill
    % the the lattice with 1s and 0s
    
    while i ~= L || j ~= L 
        if rand <= 0.5923
            lattice(i,j) = 1;
        end
        i = i + 1;
        if i == L + 1
            i = 1;
            j = j + 1;
        end
    end
    
    %lattice = randi([0 1], L,L);
    %the array below will be used to record the change when someone buys or
    %sells
    
    changeinlattice = zeros(L,L);
    
    %deltaS is the change in price S
    
    deltaS = zeros(days);
    returnperday = zeros(days,1);
    S = zeros(days,1);
    deltaS(days) = 0;
    S(1) = 2444.24/1000;
    deltas(1) = 0;
    day = 1;
    
    %the loop below repeats from day 1 to set days
    
    while day <= days
        changeinlattice = zeros(L,L);
        
        %first it calculates the influence rate PU and PD, which is
        %dependent on price, alpha and sigma
        
        pu = exp(-alpha*S(day));
        pd = 1 - exp(-sigma*S(day));
        
        %then rand function is used to generate a number between 0 to 1 and
        %in this case if rand is less than 0.5 it means that someone will
        %buy and sell for the opposite case.This will then decide the
        %influence rate.
        
        if rand <= 0.5
            buy = 1;
            influence_rate = pu;
            neutral =  1 - pu;
        else
            buy = -1;
            influence_rate = pd;
            neutral = 1 - pd;
        end
        
        %A site in the lattice with value 1 means that there is a person
        %that holds a particular stock and 0 means the opposite.Random
        %function is then used to generate 2 numbers to pick a site from
        %the lattice and repeats itself until a lattice with value of 1 is
        %chosen.
        
        xcoor = ceil(rand*L);
        ycoor = ceil(rand*L);
        while lattice(xcoor,ycoor) == 0
            xcoor = ceil(rand*L);
            ycoor = ceil(rand*L);
        end
        changeinlattice(xcoor,ycoor) = 1;
        
        %this part of the program checks the 4 neighbours of a the chosen 
        %site on a 2-Dimentional Torous lattuce if it is 1, it will then 
        %create a rand number if the number is below the influence rate, 
        %the neighbour will take an action,sell or buy depending on the 
        %influence rate. If PU is used as infleunce rate, the action will be
        %to buy and the opposite for the other case.This process repeats for
        %each direction and so on.
      
        if (rand <= influence_rate)
            y = ycoor + 1;
            if y > L
                y = y - L;
            end
            if lattice(xcoor,y) == 1
                changeinlattice(xcoor,y) = 1;
            end
        end
        if (rand <= influence_rate)
            y = ycoor - 1;
            if y < 1
                y =  L;
            end
            if lattice(xcoor,y) == 1
                changeinlattice(xcoor,y) = 1;
            end
        end
        if (rand <= influence_rate)
            x = xcoor + 1;
            if x > L
                x = x - L;
            end
            if lattice(x,ycoor) == 1
                changeinlattice(x,ycoor) = 1;
            end
        end
        if (rand <= influence_rate)
            x = xcoor - 1;
            if x < 1
                x =  L;
            end
            if lattice(x,ycoor) == 1
                changeinlattice(x,ycoor) = 1;
            end
        end
        size = sum(sum(changeinlattice));
        [ii,jj]=find(changeinlattice == 1);
        ct = 1;
        while ct <= size
            if (xcoor ~= ii(ct)) || (ycoor ~=jj(ct))
                if (rand <= influence_rate)
                    y = jj(ct) + 1;
                    x = ii(ct);
                    if y > L
                        y = y - L;
                    end
                    if lattice(x,y) == 1
                        changeinlattice(x,y) = 1;
                    end
                end
                if (rand <= influence_rate)
                    y = jj(ct) - 1;
                    x = ii(ct);
                    if y < 1
                        y =  L;
                    end
                    if lattice(x,y) == 1
                        changeinlattice(x,y) = 1;
                    end
                end
                if (rand <= influence_rate)
                    x = ii(ct) + 1;
                    y = jj(ct);
                    if x > L
                        x = x - L;
                    end
                    if lattice(x,y) == 1
                        changeinlattice(x,y) = 1;
                    end
                end
                if (rand <= influence_rate)
                    x = ii(ct) - 1;
                    y = jj(ct);
                    if x < 1
                        x =  L;
                    end
                    if lattice(x,y) == 1
                        changeinlattice(x,y) = 1;
                    end
                end
            end
            ct = ct + 1;
        end
        
        %After being infleunced, the change in lattice will have a record
        %of how many site was influenced.The sum of site influenced, along
        %with the aforementioned row will decide the return for each day.
        %The variable 'buy' in the returnperday function decides whether
        %the return will be positive or negative.
        %
        %The deltaS calculates the change in price and affects the price
        %for the next day. The program then repeats itself on a new lattice
        %but with new price.
        
        returnperday(day) = 100* row * buy * sum(sum(changeinlattice));
        deltaS(day) = S(day)*row*buy*sum(sum(changeinlattice));
        S(day+1) = deltaS(day) + S(day);
        day = day + 1;
    end
    ct = 1;
    counter = 2;
    price1 = zeros(1,300);
    price1(1) = 0;
    while counter <= 400
        price1(counter) = price1(counter - 1) + 0.01;
        counter = counter + 1;
    end
    while ct <= 400
        putest(ct) = exp(-alpha*price1(ct));
        pdtest(ct) = 1 - exp(-sigma*price1(ct));
        ct = ct + 1;
    end
    % This part of the program checks the price at certain day, if the
    % conditions were not met, the program will run again, while
    % incrementing runtimes by 1.Only when the conditions are met, the
    % program will use the data for the graphs below.
    if  true || S(65) > 2.60 && S(32) > S(1) && S(100) < 3 
        pricecheck = 1;
    end
    runtimes = runtimes + 1;
end

%the program below plots the result for 1 run.

figure

subplot(2,2,1)
hold on;
SMA = movmean(S,10);
plot(SMA)
plot(S)
title('S&P 500 (Currency in USD/1000)');
ylabel('USD/1000');
legend('SMA','Price index','Location','northwest')
xlabel('time(day)');
hold off;
pc = 0.592;
min = (-1/alpha)*log(pc);
max = (-1/sigma)*log(1-pc);

pd = fitdist(abs(returnperday),'Lognormal');
x_values = 0:0.001:10;
y = pdf(pd,x_values);
 
x_values = 0:0.001:10;
subplot(2,2,2)
plot(x_values,y)
title('LOG-Normal plot for return per day')

x_values = 10:0.001:10;
subplot(2,2,3)
histogram(returnperday,x_values)
title('Histogram for retrun per day');
xlabel('Percentage %')
ylabel('Count');

subplot(2,2,4)

plot(price1,transpose(putest),price1,transpose(pdtest))
title('Influnce rate as price increases')
legend('Pu(S)','Pd(S)');
xlabel('Price');
ylabel('Probability');


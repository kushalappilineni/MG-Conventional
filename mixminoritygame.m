function [A] = mixminoritygame(N1,N2,M,S)
%N1 CZMG players with memory M and N2 DIMG players with memory 1, each 
%having S Strategies compete
%   Detailed explanation goes here
Z=zeros(100,2);
X=zeros(M,1);
for j=1:M         %create an array of decreasing powers of 2
    X(j,1)=2^(M-j);
end
for x=1:100
    History1=randi(2,[M,1])-1;    %initial history
    History2=randi(N1+N2+1);    
    Attendance1=zeros(500,1);   %chart showing attendance at side "1" of the N1 players
    Attendance2=zeros(500,1);    %chart showing attendance at side "1" of the N2 players
    Player=cell(1,N1+N2);
    for i=1:N1
        Player{i}=createplayers(M,S);   %N1 Conventional Players
    end
    for i=N1+1:N2+N1
        Player{i}=newcreateplayers(N1+N2,S);    %N2 Conventional Players
    end
    Score=cell(1,N1+N2);
    for i=1:N1+N2                 %create their initial scorecards
        Score{i}=zeros(1,S);
    end
    for i=1:2500
        A=zeros(N1+N2,1);
        Y=sum(History1.*X)+1;  % selecting the row of matrix for each player
        for j=1:N1
            D=zeros(1,S);
            [H,I]=max(Score{j});  %selecting the reqd strategy
            l=1;
            D(1,1)=I;
            for  k=I+1:S;
                 if  Score{j}(1,k)==H
                    l=l+1;
                    D(1,l)=k;
                 end
            end
            U=D(1,randi(l));
            A(j,1)=Player{j}(Y,U);  %the responses of N1 players
        end
        for j=N1+1:N2+N1
            D=zeros(1,S);
            [H,I]=max(Score{j});  %selecting the reqd strategy
            l=1;
            D(1,1)=I;
            for k=I+1:S;
                if  Score{j}(1,k)==H
                    l=l+1;
                    D(1,l)=k;
                end
            end
            U=D(1,randi(l));
            A(j,1)=Player{j}(History2,U);  %the responses of N2 players
        end
        R=cumsum(A);
        if  R(N1+N2,1)<=(N1+N2-1)/2             %deciding the minority
            minority=1;
        else
            minority=0;
        end
        NewHistory=zeros(M,1);
        NewHistory(1,1)=minority;
        if M>=1
        for l=1:M-1             %updating the history
            NewHistory(l+1,1)=History1(l,1);
        end
        end
        History1=NewHistory;       %updated history 
        for j=1:N1             %updating the scorecards for strategies(N1)
            NewScore=zeros(1,S);
            for k=1:S;
                if Player{j}(Y,k)==minority;
                   NewScore(1,k)=Score{j}(1,k)+1;
                else
                   NewScore(1,k)=Score{j}(1,k);
                end
            end
            Score{j}=NewScore;    %updated scorecards(N1)
        end
        for j=1:N2             %updating the scorecards for strategies(N2)
            NewScore=zeros(1,S);
            for k=1:S;
                if Player{j+N1}(History2,k)==minority;
                   NewScore(1,k)=Score{j+N1}(1,k)+1;
                else
                   NewScore(1,k)=Score{j+N1}(1,k);
                end
            end
            Score{j+N1}=NewScore;    %updated scorecards(N2)
        end
        History2=R(N1+N2,1)+1;
       if i>=1501
           if minority==1
               Attendance2(i-1500,1)=(R(N1+N2,1)-R(N1,1))/N2;
               Attendance1(i-1500,1)=R(N1,1)/N1;
           else
               Attendance2(i-1500,1)=(N2-R(N1+N2,1)+R(N1,1))/N2;
               Attendance1(i-1500,1)=(N1-(R(N1,1)))/N1;
           end
        end
    end 
    Z(x,1)=sum(Attendance1)/500;
    Z(x,2)=sum(Attendance2)/500;
end
A=sum(Z)/100;
end
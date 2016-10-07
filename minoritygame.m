function [Output] = minoritygame(N,M,S)
%Classic challet and zhang minority game, using matrices.
%   Detailed explanation goes here
A1=zeros(20,1);
for a=1:30
History=randi(2,[M,1])-1;    %initial history
Attendance=zeros(1000,1); %chart showing attendance at side "1"
Q=zeros(1000,1);  %chart for std.deviation at side "1"
Player=cell(1,N);
for i=1:N
    Player{i}=createplayers(M,S);
end
    Score=cell(1,N);
    for i=1:N                 %create their initial scorecards
        Score{i}=zeros(1,S);
    end
    for i=1:3000
        A=zeros(N,1);
        X=zeros(M,1);
        for j=1:M         %create an array of decreasing powers of 2
            X(j,1)=2^(M-j);
        end
        Z=History.*X;
        Y=sum(Z)+1;  % selecting the row of matrix for each player
        for j=1:N
            D=zeros(1,S);
            [H,I]=max(Score{j});  %selecting the reqd strategy
            l=1;
            D(1,1)=I;
            for k=I:S;
                if Score{j}(1,k)==H
                    l=l+1;
                    D(1,l)=k;
                end
            end
            U=D(1,randi(l));
            A(j,1)=Player{j}(Y,U);  %the responses of N players
        end
        G=sum(A);    
        if G<=(N-1)/2             %deciding the minority
            minority=1;
        else
            minority=0;
        end
        NewHistory=zeros(M,1);
        NewHistory(1,1)=minority;
        for l=1:M-1             %updating the history
            NewHistory(l+1,1)=History(l,1);
        end
        History=NewHistory;       %updated history  
        for j=1:N                 %updating the scorecards for strategies
            NewScore=zeros(1,S);
            for k=1:S;
                if Player{j}(Y,k)==minority;
                   NewScore(1,k)=Score{j}(1,k)+1;
                else
                   NewScore(1,k)=Score{j}(1,k);
                end
            end
            Score{j}=NewScore;    %updated scorecards
        end
        if i>=2001
        Attendance(i-2000,1)=G;        %updating attendance on side "1" after the round
        end
    end
    Q(:,1)=Attendance(:,1)-(sum(Attendance)/1000);
    F=sum(Q.*Q);
    M2=F/1000;
    A1(a,1)=M2/N;
end
Output=sum(A1)/30;
end


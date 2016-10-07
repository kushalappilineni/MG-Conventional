function [Output] = newminoritygame(N,S)
%DIMG game
%   Detailed explanation goes here
    
    Score=cell(1,N);
    Player=cell(1,N);
    Y=zeros(50,1);
   for a=1:50            %averaging over initial history
       History=randi(N+1)-1;    %initial history
       Attendance=zeros(500,1); %chart showing attendance at side "1" 
      for i=1:N
          Player{i}=newcreateplayers(N,S);
      end
       
    for i=1:N                 %create their initial scorecards
        Score{i}=zeros(1,S);
    end   
    for i=1:2000         %the game avg over time
        A=zeros(N,1);
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
            A(j,1)=Player{j}((History)+1,U);%the responses of N player   
        end
        G=sum(A);    
        if G<=(N-1)/2             %deciding the minority
            minority=1;
        else
            minority=0;
        end  
        for j=1:N                 %updating the scorecards for strategies
            NewScore=zeros(1,S);
            for k=1:S;
                if Player{j}((History)+1,k)==minority;
                   NewScore(1,k)=Score{j}(1,k)+1;
                else
                   NewScore(1,k)=Score{j}(1,k);
                end
            end
            Score{j}=NewScore;    %updated scorecards
        end
        History=G;       %updated history
        if i>=1501
        Attendance(i-1500,1)=History;        %updating attendance on side "1" after the round
        end
    end    
    Q=Attendance-(sum(Attendance)/500);
    F=sum(Q.*Q);
    M2=F/500;
    Y(a,1)=M2/N;
   end
   Z=sum(Y);
   Output=Z/50;
end


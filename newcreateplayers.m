function [TrPlayer] = newcreateplayers(N,strategy)
%DIMG Players with memory 1
%   Detailed explanation goes here


   
    TrPlayer=zeros(N+1,strategy);
    
    for i=1:N+1     %because each side can have 0 to N players i.e N+1 options
        for j=1:strategy
            TrPlayer(i,j)=randi(2)-1;
        end
    end
  
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hasObject] = gocfar(refer,value)
%dataΪҪ�������飬iΪҪ���ĵ�Ԫ��NΪ��ⵥԪ���ߵıȽϵ�Ԫ��
global Pfa
N = length(refer);
K=(Pfa)^(-1/(N/2))-1;
hasObject=0;

left=sum(refer(1:N/2));
right=sum(refer(N/2+1:N));
juage=max(left,right)*K;
if(value>juage)
    hasObject=1;
end
end


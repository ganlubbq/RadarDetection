%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hasObject] = cacfar(data,value,K)
%dataΪҪ���Ĳο���Ԫ���飬rΪ������Ԫ����PfΪ�龯����
N = length(data);
hasObject=0;
%K=(Pf)^(-1/N)-1;

juage=K*sum(data);
if(value>juage)
    hasObject=1;
end
end


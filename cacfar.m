function [hasObject] = cacfar(value,refer,K)
%referΪҪ���Ĳο���Ԫ���飬rΪ������Ԫ����PfΪ�龯����
hasObject=0;
%K=(Pf)^(-1/N)-1;

juage=K*sum(refer);
if(value>juage)
    hasObject=1;
end
end


function [hasObject] = gocfar( data,value,K )
%dataΪҪ�������飬iΪҪ���ĵ�Ԫ��NΪ��ⵥԪ���ߵıȽϵ�Ԫ����rΪ������Ԫ����PfaΪ�龯����
N = length(data);
%K=(Pfa)^(-1/(N/2))-1;
hasObject=0;

left=sum(data(1:N/2));
right=sum(data(N/2+1:N));
juage=max(left,right)*K;
if(value>juage)
    hasObject=1;
end
end


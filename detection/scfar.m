%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hasObject = scfar(data,value,alpha,beta1,beta2,Nt)
%dataΪҪ�������飬iΪҪ���ĵ�Ԫ��NΪ��ⵥԪ���ߵıȽϵ�Ԫ����rΪ������Ԫ����PfΪ�龯����
S0=[];
S1=[];
hasObject=0;

N=length(data);
for t=1:N
   if(data(t)>=alpha*value)
       S1=[S1 data(t)];
   else
       S0=[S0 data(t)];
   end
end

n0=length(S0);
if(n0>Nt)
   if(beta1/n0*sum(S0)<value)
       hasObject=1;
   end
else
   if(beta2/N*sum(data)<value)
       hasObject=1;
   end
end 

end


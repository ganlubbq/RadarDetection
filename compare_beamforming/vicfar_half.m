%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%��Ҫ����߽������ֻ�а��ɨ�贰�����
function [ hasObject, choice ] = vicfar_half(refer,value, Pfa)
%refer Ϊ�ο���Ԫ���ݣ�valueΪ�����ݵĵ� ,KVIͳ����VI��ֵ���ޣ�ͳ����MR��ֵ����
global KVI KMR
%Pfa = 1e-2;
N=length(refer); %�ο���Ԫ����
VI =1;
hasObject=0; %�Ƿ����Ŀ��
avg_x=mean(refer(1:N));
for i=1:N
    VI=VI+1/(N-1)*(refer(i)-avg_x)^2/avg_x^2;
end

isAve=1;  %�뻮���Ƿ��Ǿ��Ȼ�����1Ϊ����

if(VI>KVI)
    isAve = 0;
end

CN=Pfa^(-1/N)-1;
CN2=Pfa^(-1/(N/2))-1;

%ѡ�õ�һ�ֲ���
if(isAve == 1)
    hasObject=cacfar(refer,value,CN);
    choice=1;
else
    %ѡ�õڶ��ֲ���    
    hasObject=scfar(refer,value);
    choice=3;
end
end


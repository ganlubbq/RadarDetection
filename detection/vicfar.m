%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ hasObject, choice ] = vicfar(refer,value)
%refer Ϊ�ο���Ԫ���ݣ�valueΪ�����ݵĵ� ,KVIͳ����VI��ֵ���ޣ�ͳ����MR��ֵ����
global KVI KMR Pfa
N=length(refer); %�ο���Ԫ����
VI_before=1;
VI_after=1;
hasObject=0; %�Ƿ����Ŀ��
avg_x=mean(refer);
for i=1:N/2
   VI_before=VI_before+1/(N/2-1)*(refer(i)-avg_x)^2/avg_x^2;
   VI_after=VI_after+1/(N/2-1)*(refer(i+N/2)-avg_x)^2/avg_x^2; 
end
MR=sum(refer(1:N/2))/sum(refer(N/2+1:N));

isAve_before=1;  %ǰ�뻮���Ƿ��Ǿ��Ȼ�����1Ϊ����
isAve_after=1;  %��뻮���Ƿ��Ǿ��Ȼ�����1Ϊ����
HasSameAve=1; %�Ƿ�ͬ��ֵ,1Ϊ��ͬ
if(VI_before>KVI)
    isAve_before=0;
end
if(VI_after>KVI)
    isAve_after=0;
end
if(MR<1/KMR&&MR>KMR)
    HasSameAve=0;    
end

CN=Pfa^(-1/N)-1;
CN2=Pfa^(-1/(N/2))-1;

%ѡ�õ�һ�ֲ���
if(isAve_before==1 && isAve_after==1 && HasSameAve==1)
    hasObject=cacfar(refer,value,CN);
    choice=1;
end
%ѡ�õڶ��ֲ���
if(isAve_before==1 && isAve_after==1 && HasSameAve==0)
    hasObject=gocfar(refer,value,CN2);
    choice=2;
end
%ѡ�õ����ֲ���
if(isAve_before==0 && isAve_after==1)
    hasObject=scfar(refer,value);
    choice=3;
end
%ѡ�õ����ֲ���
if(isAve_before==1 && isAve_after==0)
    hasObject=scfar(refer,value);
    choice=4;
end
%ѡ�õ����ֲ���
if(isAve_before==0 && isAve_after==0)
    hasObject=scfar(refer,value);
    choice=5;
end

end


function [ hasObject, choice ] = svicfar(data,value,KVI,KMR,pfa,alpha,beta1,beta2,Nt)
%data Ϊ�ο���Ԫ���ݣ�valueΪ�����ݵĵ� ,KVIͳ����VI��ֵ���ޣ�ͳ����MR��ֵ����
N=length(data); %�ο���Ԫ����
VI_before=1;
VI_after=1;
hasObject=0; %�Ƿ����Ŀ��
avg_x_1=mean(data(1:N/2));
avg_x_2=mean(data(N/2+1:N));
for i=1:N/2
   VI_before=VI_before+1/(N/2-1)*(data(i)-avg_x_1)^2/avg_x_1^2;
   %VI_after=VI_after+1/(N/2-1)*(data(i+N/2+1)-avg_x)^2/avg_x^2; xiugai
   VI_after=VI_after+1/(N/2-1)*(data(i+N/2)-avg_x_2)^2/avg_x_2^2;
end
MR=avg_x_1/avg_x_2;

isAve_before=1;  %ǰ�뻮���Ƿ��Ǿ��Ȼ�����1Ϊ����
isAve_after=1;  %��뻮���Ƿ��Ǿ��Ȼ�����1Ϊ����
HasSameAve=1; %�Ƿ�ͬ��ֵ,1Ϊ��ͬ
if(VI_before>KVI)
    isAve_before=0;
end
if(VI_after>KVI)
    isAve_after=0;
end
if(MR<1/KMR||MR>KMR)
    HasSameAve=0;    
end

CN=pfa^(-1/N)-1;
CN2=pfa^(-1/(N/2))-1;

%ѡ�õ�һ�ֲ���
if(isAve_before==1 && isAve_after==1 && HasSameAve==1)
    hasObject=cacfar(data,value,CN);
    choice=1;
end
%ѡ�õڶ��ֲ���
if(isAve_before==1 && isAve_after==1 && HasSameAve==0)
    hasObject=gocfar(data,value,CN2);
    choice=2;
end
%ѡ�õ����ֲ���
if(isAve_before==0 && isAve_after==1)
    hasObject=cacfar(data(N/2+1:N),value,CN2);
    choice=3;
end
%ѡ�õ����ֲ���
if(isAve_before==1 && isAve_after==0)
    hasObject=cacfar(data(1:N/2),value,CN2);
    choice=4;
end
%ѡ�õ����ֲ���
%alpha=0.5;
%beta1=22.5;
%beta2=22.5;
%Nt=N-ng-1;
if(isAve_before==0 && isAve_after==0)
    hasObject=scfar(data,value,alpha,beta1,beta2,Nt);
    choice=5;
end

end


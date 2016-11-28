%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function dsig = getdisg(R0,v0, rcs)
%�õ���������Ĳ�Ƶ�ź�
global c B f0 T Fs M
A= 100*sqrt(rcs); %�����źŷ�ֵ
t=0:1/Fs:T-1/Fs; %����ʱ��ά
u=B/T;
%tʱ���������
Rn=R0+v0.*t;
%�ٶȶ�����Ƶ��
fd=2*f0*v0/c;
%���������Ƶ��
fw=2*u.*Rn/c;
%phase0 ��ʼ��λ
phase0=2*pi*f0*2*R0/c;
%��������
fa_num=round(Fs*T);
freq=zeros(M,fa_num);

%��ƵƵ��
for k=1:M
  freq(k,:)=2*pi*((fw+fd).*t + fd*(k-1)*T) + phase0;
end

%��Ƶ�ź�
dsig=A*cos(freq);
end


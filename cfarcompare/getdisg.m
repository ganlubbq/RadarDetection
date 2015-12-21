function dsig = getdisg( R0,v0,B,f0,T,fs,M)
%�õ���������Ĳ�Ƶ�ź�

c=3e8;
A=20; %�����źŷ���

t=0:1/fs:T-1/fs; %����ʱ��ά
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
fa_num=fs*T;
freq=zeros(M,fa_num);

%��ƵƵ��
for k=1:M
  freq(k,:)=2*pi*((fw+fd).*t + fd*(k-1)*T) + phase0;
end

%��Ƶ�ź�
dsig=A*cos(freq);
end


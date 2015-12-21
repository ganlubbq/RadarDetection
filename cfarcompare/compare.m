%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

%����һάca-cfar�㷨, ��άʮ�ִ������㷨����άʮ�ִ��Ľ�����㷨������
c=3e8;
%%%%%%%%%%%%%�������״�ϵͳ����%%%%%%%%%%%%%%%%%%%
T=80e-6; %������ɨƵ����
f0=20e9; %��Ƶ��ʼƵ��
B=500e6; %�������Ƶ����
deltaR=c/(2*B); %��ά�任��ľ���ֱ���
deltaV=2; %��ά�任���ٶ�ά�ֱ���
Rmax=300; %��������
Fs=4*B*Rmax/(T*c); %��Ƶ�źŲ�����
N=round(Fs*T); %����ά��������
M=fix(c/(deltaV*2*T*f0)); %�ٶ�ά��������
Vmax=M*deltaV;  %���ģ������

disg1 = getdisg(100,5,B,f0,T,Fs,M); %����һ����Ŀ��
disg2 = getdisg(99,0,B,f0,T,Fs,M); %����һ����Ŀ��

response = disg1 + disg2; %��Ƶ�ز��ź�
response  = awgn(response, 1); %������
%����Ӳ�
za=zeros(M,N);
for k=1:M
    za(k,:)=wbfb(1.5,2.2);
end
response = response + za;
%һά�任
fft1=zeros(M,N);
for k=1:M
    fft1(k,:)=fft(response(k,:),N);
end
%��άfff�任
fft2=zeros(M,N);
for i=1:N
    fft2(:,i) = fft(fft1(:,i),M);
end

%% CFAR����
%����10000�Σ�����������ĸ������龯�����Լ�©������
for k=1:10000
    for i= 1:N
        for j = 1:M            
            %ʹ��һάca-cfar���� 
            %ʹ�ö�άʮ�ִ������㷨
            %ʹ�ö�άʮ�ִ��Ľ�����㷨
        end
    end
end
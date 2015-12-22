%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
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
%M=16;
Vmax=M*deltaV;  %���ģ������

disg1 = getdisg(100,30,B,f0,T,Fs,M); %����һ����Ŀ��
disg2 = getdisg(98,0,B,f0,T,Fs,M); %����һ����Ŀ��

response = disg1 + disg2; %��Ƶ�ز��ź�
response  = awgn(response, 1); %������

%����N�Σ�����������ĸ������龯�����Լ�©������
cfarrightnum=0; %cfar�㷨��ȷ���ĸ���
cfarclosewrongnum=0; %cfar�㷨��Ŀ���ڽ��龯�ĸ���
cfarawaywrongnum=0; %cfar�㷨���������龯�ĸ���
cfarmissnum=0; %cfar�㷨©���ĸ���

% CFAR����
L_v=16; %�ٶ�ά�ο�������
L_d=20; %����ά�ο�������
r=1; %������Ԫ����
pfa_d=5e-3; %����ά�龯��
pfa_v=5e-3; %�ٶ�ά�龯��
K1=(pfa_d)^(-1/L_d)-1; %�龯����
K2=(pfa_v)^(-1/L_v)-1;

for k=1:50
    %����Ӳ�
    za=zeros(M,N);
    for t=1:M
        za(t,:)=wbfb(1.5,2.2);
    end
    response = response + za;
    %һά�任
    fft1=zeros(M,N);
    for t=1:M
        fft1(t,:)=fft(response(t,:),N);
    end
    %��άfff�任
    fft2=zeros(M,N);
    for i=1:N
        fft2(:,i) = fft(fft1(:,i),M);
    end
    data = abs(fft2(:,1:N/2));
    %ȥ���ٶ�ά0���Ӳ��뾲ֹ����
    data=data(2:M,:);
    H=M-1;
    right=0;
    wrong1=0;
    wrong2=0;
    
    for i= 1:H
        for j = 100:800
            %��ȡ����cfar�ο���
            cankao1=zeros(L_v); %�ο���
            if(i>(L_v/2+r)&&i<=H-L_v/2-r)
                cankao1=[data(i-L_v/2-r:i-r-1,j)' data(i+r+1:i+L_v/2+r,j)'];
            elseif (i==1 || i ==2)
                cankao1=data(i+r+1:i+L_v+r,j)';
            elseif(2<i && i<=L_v/2+r)
                cankao1=[data(1:i-r-1,j)' data(i+r+1:L_v+2*r+1,j)'];
            elseif(i<H-1&&i>H-L_v/2-r)
                cankao1=[data(-2*r-L_v+H:i-r-1,j)' data(i+r+1:H,j)'];
            elseif( i==H || i==H-1)
                cankao1=data(i-L_v-r:i-r-1,j)';
            end
            
            %��ȡ����cfar�ο���
            cankao2=zeros(L_d);
            if(j>(L_d/2+1)&&j<=N-L_d/2-1)
                cankao2=[data(i,j-L_d/2-r:j-r-1) data(i,j+r+1:j+L_d/2+r)];
            elseif (j==1 || j ==2)
                cankao2=data(i,j+r+1:j+L_d+r);
            elseif(2<j && j<=L_d/2+1)
                cankao2=[data(i,1:j-r-1) data(i,j+r+1:L_d+2*1+r)];
            elseif(j<N-1&&j>N-L_d/2-1)
                cankao2=[data(i,-2*r-L_d+N:j-r-1) data(i,j+r+1:N)];
            elseif( j==N || j==N-1)
                cankao2=data(i,j-L_d-r:j-r-1);
            end
            
            %%%%%%%%%%%%%%%%%%%%%%ʹ��һάca-cfar����%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                hasObject1=cacfar(data(i,j),cankao1,K2);
                                                hasObject = hasObject1;
            % %
            %%%%%%%%%%%%%%%%%%%%ʹ�ö�άʮ�ִ������㷨%%%%%%%%%%%%%%%%%%%%%%%%%
%             hasObject1=cacfar(data(i,j),cankao1,K2);
%             hasObject2=cacfar(data(i,j),cankao2,K1);
%             hasObject = hasObject1*hasObject2;
            %%%%%%%%%%%%%%%%%%%ʹ�ö�άʮ�ִ��Ľ�����㷨%%%%%%%%%%%%%%%%%%%%%%
%                         %�жϸõ��Ƿ��Ƕ���
%                         isTop=1;
%                         if(i>1&&i<H&&j>1&&j<N/2)
%                             isTop= (data(i,j) > data(i+1,j)) && (data(i,j) > data(i-1,j)) && (data(i,j) > data(i,j-1)) && (data(i,j) > data(i,j+1));
%                         end
%                         hasObject1=cacfar(data(i,j),cankao1,K2);
%                         hasObject2=cacfar(data(i,j),cankao2,K1);
%                         hasObject = hasObject1*hasObject2*isTop;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if hasObject
                if(j == 335 && i ==15)%�������Ӧ�ĺ�����
                    right = right + 1;
                else
                    if( (i<=19||i>=13) && (j>=331||j<=338))
                        wrong1 = wrong1 + 1;
                    else
                        wrong2 = wrong2 + 1;
                    end
                end
            end
        end
        
    end
    miss = 1 - right;
    cfarrightnum = cfarrightnum + right;
    cfarclosewrongnum = cfarclosewrongnum + wrong1;
    cfarawaywrongnum = cfarawaywrongnum + wrong2;
    cfarmissnum = cfarmissnum + miss;
    k
end
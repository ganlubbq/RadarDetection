%SVI-CFAR�㷨����--�����Ӳ�
clc
close all
clear all
N=24; %�ο���Ԫ����
M=1e4; %���ؿ���������
pfa=1e-6;
KVI=4.56;
KMR=2.9;
SNR_dB=0:1:35;
SNR=10.^(SNR_dB./10);
len=length(SNR); %���泤��
%����Ŀ����
Ng=2;
alpha=0.5;
beta1=22.5;
beta2=22.5;
Nt=N-Ng-1; %���̸���Ŀ��Ng
%pd_svi=zeros(len);
for i=1:len 
    count_svi=0;
    count_vi=0;
    count_go=0;
    count_ca=0;
    count_so=0;
    count_s=0;
    for j=1:M
        %����ָ������
        lambda=1;
        u=rand(1,N);
        exp_noise=log(u)*(-lambda);
        %����Ŀ��ز�
        lambda=SNR(i)+1;
        % lambda=SNR(i);
        u=rand(1);
        exp_target=log(u)*(-lambda);
        
        
        %���ż���ǰ�봰
        location1=randi([1 N/2],1,2);
        u=rand(2);
        exp_noise(location1(1))=log(u(1))*(-lambda);
        exp_noise(location1(2))=log(u(2))*(-lambda);
        %���ż��ں�봰
        location2=randi([N/2+1 N],1,1);
        u=rand(1);
        exp_noise(location2(1))=log(u(1))*(-lambda);
        % exp_noise(location2(2))=log(u(2))*(-lambda);
        
        %����svi-cfar����
        [hasObject_svi ,choice_svi(j)]= svicfar(exp_noise,exp_target,KVI,KMR,pfa,alpha,beta1,beta2,Nt);
        if(hasObject_svi==1)
            count_svi=count_svi+1;
        end
        %����vi-cfar����
        [hasObject_vi ,choice_vi(j)]= vicfar(exp_noise,exp_target,KVI,KMR,pfa);
        if(hasObject_vi==1)
            count_vi=count_vi+1;
        end
        %����ca-cfar����
        K=pfa^(-1/N)-1;
        hasObject_ca=cacfar(exp_noise,exp_target,K);
        if(hasObject_ca==1)
            count_ca=count_ca+1;
        end
        %����so-cfar����
        K=pfa^(-1/(N/2))-1;
        hasObject_so=socfar(exp_noise,exp_target,K);
        if(hasObject_so==1)
            count_so=count_so+1;
        end
        %����go-cfar����
        K=pfa^(-1/(N/2))-1;
        hasObject_go=gocfar(exp_noise,exp_target,K);
        if(hasObject_go==1)
            count_go=count_go+1;
        end
        %����s-cfar����
        
        hasObject_s=scfar(exp_noise,exp_target,alpha,beta1,beta2,Nt);
        if(hasObject_s==1)
            count_s=count_s+1;
        end
    end
    pd_svi(i)=count_svi/M;
    pd_vi(i)=count_vi/M;
    pd_s(i)=count_s/M;
    pd_so(i)=count_so/M;
    pd_go(i)=count_go/M;
    pd_ca(i)=count_ca/M;
    [AB(i), go(i), B(i),  A(i) ,S(i)]=getsvichoice(choice_svi);
end
figure;
% Pd_opt=pfa.^(1./(1+SNR));  %�ض�����ȶ�Ӧ�����ż�����
% plot(SNR_dB,Pd_opt,'bx-');
% hold on
plot(SNR_dB,pd_svi,'r*-');
hold on
%plot(SNR_dB,pd_vi,'m+-');
%hold on
plot(SNR_dB,pd_s,'ks-');
hold on
plot(SNR_dB,pd_ca,'rv-');
hold on
plot(SNR_dB,pd_go,'g.-');
hold on
plot(SNR_dB,pd_so,'k>-');
grid on
legend('SVI-CFAR','S-CFAR','CA-CFAR','GO-CFAR','SO-CFAR');
xlabel('SNR/dB');
ylabel('Pd');
title('�����Ŀ����SVI-CFAR���ܷ���(Ng=2ʱ��ǰ��2������Ŀ�꣬��1������Ŀ��)');

%����ѡ��
figure;
plot(SNR_dB,AB,'bx-');
hold on
plot(SNR_dB,go,'k>-');
hold on
plot(SNR_dB,B,'r*-');
hold on
plot(SNR_dB,A,'m+-');
hold on
plot(SNR_dB,S,'ks-');
grid on
xlabel('SNR/dB');
legend('AB','GO','B','A','S');
ylabel('ѡ������Pd');
title('�����Ŀ����SVI-CFAR����ѡ��(Ng=2ʱ��ǰ��2������Ŀ�꣬��1������Ŀ��)');



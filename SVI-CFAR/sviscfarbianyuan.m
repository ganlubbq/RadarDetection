%SVI-CFAR�㷨����--�Ӳ���Ե
clc
clear all
N=32; %�ο���Ԫ����
M=1e4; %���ؿ���������
pfa=1e-2;
KVI=4.56;
KMR=2.9;

SNR_dB=5;
SNR=10.^(SNR_dB./10);
for Nc=0:N
  if(Nc<=N/2)
  count_go=0;

    for j=1:M
  
    lambda=SNR;
     u1=rand(1,Nc);%%xiu gai
     u2=rand(1,N-Nc);
     exp_noise(1:Nc)=log(u1)*(-lambda);
     exp_noise(Nc+1:N)=log(u2)*(-1);
      %����Ŀ��ز�
      u=rand(1,2);
      exp_target=log(u(1))*(-1);
       % u=rand(1);
       % exp_target=log(u)*(-lambda);
       % exp_target=log(u)*(-1);
       %����go-cfar����
       K=pfa^(-1/(N/2))-1;
       hasObject_go=gocfar(exp_noise,exp_target,K);
       if(hasObject_go==1)
       count_go=count_go+1;
       end
    end
    pd_go(Nc+1)=count_go/M;
  else
  count_go=0;
  for j=1:M
  lambda=SNR;
  u1=rand(1,Nc);
  u2=rand(1,N-Nc);
  exp_noise(1:Nc)=log(u1)*(-lambda);
  exp_noise(Nc+1:N)=log(u2)*(-1);
   %����Ŀ���
   u=rand(1,2);
         %  exp_target=log(u(1))*(-1);
          %  u=rand(1);
  exp_target=log(u(1))*(-lambda);
 K=pfa^(-1/(N/2))-1;
 %K=0.27
  hasObject_go=gocfar(exp_noise,exp_target,K);
  if(hasObject_go==1)
      count_go=count_go+1;
  end
  end
   pd_go(Nc+1)=count_go/M;
    end
end




figure;

hold on
semilogy(0:N,pd_go,'g.-');
%ylim([1e-6 1e-0]);
hold on
grid on
%legend('SVI-CFAR','VI-CFAR','S-CFAR','CA-CFAR','GO-CFAR','SO-CFAR');
%legend('OPT','SVI-CFAR','VI-CFAR','S-CFAR','CA-CFAR','GO-CFAR','SO-CFAR');
xlabel('N');
ylabel('Pfa');
title('��Ե�Ӳ�������SVI-CFAR�龯���ܷ���');

%����ѡ��

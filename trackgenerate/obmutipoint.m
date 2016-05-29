function [ v1, R1, sita1 ] = obmutipoint( R,v, sita, deltaR, deltaV, deltaSita, deltat )
%ģ��һ������Ķ��㼣��������һ��������˶�ģ�Ͳ���������Ƕ����õ����Ƶ��˶�ģ�Ͳ�����ģ��һ������Ķ��ģ��
%v��ʵʱ�ٶ����飬R��ʵʱ�������飬sita��ʵʱ�Ƕ����飬deltaRΪƽ���������
n = length(R);
R_error = (rand(1, n) *2-1)* deltaR; %��������������
v_error = (rand(1,n)*2-1).*deltaV;%��������ٶ����
sita_error = (rand(1,n)*2-1).*deltaSita;%��������Ƕ����
v1=zeros(1,n);
R1=zeros(1,n);
sita1=zeros(1,n);
for i=1:n
    R1(i) = R(i) + deltaR + R_error(i);
    v1(i) = v(i) + v_error(i);
    sita1(i) = sita(i) + sita_error(i);
end
end


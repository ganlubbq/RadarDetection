function [ v1, R1, sita1 ] = obmutipoint( v, R, sita, deltaR )
%ģ��һ������Ķ��㼣��������һ��������˶�ģ�Ͳ���������Ƕ����õ����Ƶ��˶�ģ�Ͳ�����ģ��һ������Ķ��ģ��
%v��ʵʱ�ٶ����飬R��ʵʱ�������飬sita��ʵʱ�Ƕ����飬deltaRΪƽ���������
n = length(R);
R_error = (rand(1, n) *2-1)* deltaR * 0.2; %��������������
v_error = (rand(1,n)*2-1)*v*0.1;%��������ٶ����
sita_error = (rand(1,n)*2-1)*sita*0.1;%��������Ƕ����
v1=zeros(n);
R1=zeros(n);
sita1=zeros(n);
for i=1:n
    R1(i) = R(i) + deltaR + R_error(i);
    v1(i) = v(i) + v_error;
    sita1(i) = sita(i) + sita_error;
end

end


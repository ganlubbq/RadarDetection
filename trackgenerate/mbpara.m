function [VV, RR, Ssita] = mbpara(R0, v0, a, sita0, sita_a, sita_v0, t, deltaR, deltaV, deltaSita)
%�ƶ������������,R0Ϊ��ʼ���룬v0Ϊ��ʼ�ٶȣ��ӽ��״﷽��Ϊ����aΪ���ٶȣ�
%sita0Ϊ��ʼ�Ƕȣ�sita_aΪ�Ƕȱ仯���ٶȣ�sita_v0Ϊ�Ƕȱ仯��ʼ�ٶ�,tΪʱ��
%ģ��һ������Ķ��㼣������Ƕ����õ����Ƶ��˶�ģ�Ͳ�����ģ��һ������Ķ��ģ��
v=v0+a.*t;
R=R0-(v0.*t + 0.5*a.*t.^2);
sita=sita0 + sita_v0.*t + 0.5*sita_a.*t.^2;

n = length(R);
R_error = (rand(1, n) *2-1)* 0.2 * deltaR; %��������������
v_error = (rand(1,n)*2-1).*deltaV;%��������ٶ����
sita_error = (rand(1,n)*2-1).*deltaSita;%��������Ƕ����

R1 = R + R_error + ones(1,n)*deltaR;
V1 = v + v_error;
Sita1 = sita + sita_error;

R_error = (rand(1, n) *2-1)* 0.2 * deltaR; %��������������
v_error = (rand(1,n)*2-1).*deltaV;%��������ٶ����
sita_error = (rand(1,n)*2-1).*deltaSita;%��������Ƕ����

R2 = R + R_error - ones(1,n)*deltaR;
V2 = v + v_error;
Sita2 = sita + sita_error;

VV = [v;V1;V2];
RR = [R;R1;R2];
Ssita = [sita; Sita1; Sita2];
end


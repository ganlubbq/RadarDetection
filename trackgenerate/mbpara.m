function [v R sita] = mbpara(R0, v0, a, sita0, sita_a, sita_v0)
%�ƶ������������,R0Ϊ��ʼ���룬v0Ϊ��ʼ�ٶȣ��ӽ��״﷽��Ϊ����aΪ���ٶȣ�
%sita0Ϊ��ʼ�Ƕȣ�sita_aΪ�Ƕȱ仯���ٶȣ�sita_v0Ϊ�Ƕȱ仯��ʼ�ٶ�
v=v0+a.*t;
R=R0-(v0.*t + 0.5*a.*t.^2);
sita=sita0 + sita_v0.*t + 0.5*sita_a.*t.^2;
end


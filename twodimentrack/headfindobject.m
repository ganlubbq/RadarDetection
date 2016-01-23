function [isTrue, Weightmean]= headfindobject(head, one,time_diff,dis_diff,v_diff,fangwei_diff)
%�ú�����Ҫ�ж�ĳ����ĳ�켣ͷ�Ƿ�����γɹ켣����Ҫͨ��ʱ�䣬���룬�ٶȣ���λ�ȶ෽����Ϣ���й�����
%������ԣ�����������Ĳ����Ȩ�غ�ֵ���趨����ռ30%��ʱ��20%����λ20%���ٶ�30%��ȨֵԽСԽ����
distance = head(1); %��ȡ�켣ͷ�ľ���
velocity = head(2);%��ȡ�켣ͷ���ٶ�
fangwei = head(3);%��ȡ�켣ͷ�ķ�λ
time = head(4); %��ȡ�켣ͷ��ʱ���

one_distance = one(1); %��ȡĿ��ľ���
one_velocity = one(2);%��ȡĿ����ٶ�
one_fangwei = one(3);%��ȡĿ��ķ�λ
one_time = one(4); %��ȡĿ���ʱ���
isTrue = 0;
if( abs(distance-one_distance) <= dis_diff && abs(velocity - one_velocity) <= v_diff && abs(fangwei - one_fangwei) <= fangwei_diff && abs(time-one_time) <= time_diff)
  isTrue = 1;
  Weightmean = 0.3*(distance-one_distance) + 0.2*(time-one_time) + 0.3*(velocity - one_velocity) + 0.2*(fangwei - one_fangwei);%����Ȩ��
end
end
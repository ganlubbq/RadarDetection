function [isTrue, Weightmean] = temptrackfindobject(onetemptrack, one, time_diff, dis_diff, v_diff, fangwei_diff,TT,t)
%�ú�����Ҫ�ж�ĳ����ĳ��ʱ�켣�ܷ�������γ���ʽ�켣��������ʱ�켣�����㣬����ͨ��������Ԥ����һ�������Ϣ��Ȼ������
%��Ӧ�Ĳ��ţ��ڲ�����Ѱ��Ŀ�꣬���ڲ����ڿ����ж��Ŀ�꣬��ʱ����ͨ������������Ϣ���вο�������ʱ�䣬���룬�ٶȣ���λ
%����Ϣ������������Ĳ����Ȩ�غ�ֵ���趨����ռ30%��ʱ��20%����λ20%���ٶ�30%��ȨֵԽСԽ����

%һ����ʱ�켣�������㣬�ֱ�ȡ����
point1 = onetemptrack(1,:);
point2 = onetemptrack(2,:);
%����������Ԥ���������
point3 = twoPredict(point1, point2,t);
distance = point3(1); %��ȡԤ���ľ���
velocity = point3(2);%��ȡԤ�����ٶ�
fangwei = point3(3);%��ȡԤ���ķ�λ
time = point3(4); %��ȡԤ����ʱ���


one_distance = one(1); %��ȡĿ��ľ���
one_velocity = one(2);%��ȡĿ����ٶ�
one_fangwei = one(3);%��ȡĿ��ķ�λ
one_time = one(4); %��ȡĿ���ʱ���
%�������ú������Χ���ж�ʵ�ʵ���Ԥ����Ƿ����
isTrue = 0;
if( abs(distance-one_distance) <= dis_diff && abs(velocity - one_velocity) <= v_diff && abs(fangwei - one_fangwei) <= fangwei_diff && abs(time-one_time) <= time_diff)
  isTrue = 1;
  Weightmean = 0.3*(distance-one_distance) + 0.2*(time-one_time) + 0.3*(velocity - one_velocity) + 0.2*(fangwei - one_fangwei);%����Ȩ��
end
end
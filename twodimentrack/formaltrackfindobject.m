%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function  [isTrue, Weightmean] = formaltrackfindobject(oneformaltrack, one, time_diff,time_diff_min, dis_diff, v_diff, fangwei_diff,TT,t)
%�ú�����Ҫ�����ж�ĳ����ĳ��ʽ�켣�ܷ������������ʽ�켣���ڵ���3�㣬���Ϊ�˼�����������ȡ��ʽ�켣����������Ԥ����һ�����Ϣ��
%Ȼ����Ԥ���λ��������Ӧ���ţ��ڲ�����Ѱ��Ŀ�꣬����Ŀ�����ӵ�ж������ʱ����ͨ���෽�����Ϣ���вο�������ʱ�䣬���룬�ٶȣ���λ
%����Ϣ������������Ĳ����Ȩ�غ�ֵ���趨����ռ30%��ʱ��20%����λ20%���ٶ�30%��ȨֵԽСԽ����

%ȡ����ʽ�켣�ĺ�����
p1 = oneformaltrack(end-2,:);
p2 = oneformaltrack(end-1,:);
p3 = oneformaltrack(end,:);
%����������Ԥ����ĸ���
p4 = threePredict(p1, p2, p3, t);
%p4 = twoPredict(p2,p3,t);

distance = p4(1); %��ȡԤ���ľ���
velocity = p4(2);%��ȡԤ�����ٶ�
fangwei = p4(3);%��ȡԤ���ķ�λ
time = p4(4); %��ȡԤ����ʱ���

one_distance = one(1); %��ȡĿ��ľ���
one_velocity = one(2);%��ȡĿ����ٶ�
one_fangwei = one(3);%��ȡĿ��ķ�λ
one_time = one(4); %��ȡĿ���ʱ���
%�������ú������Χ���ж�ʵ�ʵ���Ԥ����Ƿ����
isTrue = 0;
Weightmean = 1;
if( abs(distance-one_distance) <= dis_diff && abs(velocity - one_velocity) <= v_diff && abs(fangwei - one_fangwei) <= fangwei_diff && abs(time-one_time) <= time_diff && abs(p3(4)-one_time) >= time_diff_min)
  isTrue = 1;
  Weightmean = 0.3*abs(distance-one_distance) + 0.4*abs(velocity - one_velocity) + 0.3*abs(fangwei - one_fangwei);%����Ȩ��
end
end
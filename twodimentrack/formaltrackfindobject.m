%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function  [isTrue, Weightmean] = formaltrackfindobject(oneformaltrack, one, time_diff, dis_diff, v_diff, fangwei_diff,TT,t)
%�ú�����Ҫ�����ж�ĳ����ĳ��ʽ�켣�ܷ������������ʽ�켣���ڵ���3�㣬���Ϊ�˼�����������ȡ��ʽ�켣����������Ԥ����һ�����Ϣ��
%Ȼ����Ԥ���λ��������Ӧ���ţ��ڲ�����Ѱ��Ŀ�꣬����Ŀ�����ӵ�ж������ʱ����ͨ���෽�����Ϣ���вο�������ʱ�䣬���룬�ٶȣ���λ
%����Ϣ������������Ĳ����Ȩ�غ�ֵ���趨����ռ30%��ʱ��20%����λ20%���ٶ�30%��ȨֵԽСԽ����

%ȡ����ʽ�켣�ĺ�����
p1 = oneformaltrack(end-2,:);
p2 = oneformaltrack(end-1,:);
p3 = oneformaltrack(end,:);
%����������Ԥ����ĸ���
p4 = threePredict(p1, p2, p3, t);

end
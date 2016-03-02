%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [track_normal, ones_result] = maintain_formaltrack(track_normal, ones_result, TT, t)
%�켣ά�ֺ������ж�һ��������ʽ�켣�Ƿ�ƥ�䡣��Ҫͨ����ȡ��ʽ�켣�����㣬���й켣Ԥ�⣬Ȼ������������
%�Ƚϣ��ж��Ƿ�����Χ��
formal_num = length(track_normal); %��ʽ�켣����Ŀ
scan_num = size(ones_result, 1); %����ɨ���������ۺϺ����Ŀ
time_diff = 2*TT; %Ŀ��������Ĺ켣Ŀ������ʱ�䲻�ܳ�����������
fangwei_diff = 5; %Ŀ��������켣Ŀ�����ķ�λ���ܳ���fangwei_diff ��
dis_diff = 10; %Ŀ��������켣Ŀ�����ľ��벻�ܳ���dis_diff m
v_diff = 5; %Ŀ���ٶ���Ԥ���ٶ����ܳ���v_diff
track_normal1 = track_normal; %����track_normal����һ��ѭ���У����ϱ仯���²���i����ʧ�ܣ������������
for i=1:formal_num
    oneformaltrack = track_normal{i}; %��ȡһ����ʽ�켣
    scan_result = 1; %�ٶ������Ҫ���Ŀ������Ϊ1
    minWeight = 10000; %��ʼ����СȨ��ֵΪһ���ܴ��ֵ
    for j = 1:scan_num
        one = ones_result(j,:); %��ȡһ��ɨ��Ŀ��
        [isTrue, Weightmean] = formaltrackfindobject(oneformaltrack, one, time_diff, dis_diff, v_diff, fangwei_diff,TT,t);%�õ��Ƿ������������ϣ��������Ȩ�ؼӺ�Ϊ����
        if(Weightmean < minWeight && isTrue)
            minWeight = Weightmean;
            scan_result = j;
        end
    end


end
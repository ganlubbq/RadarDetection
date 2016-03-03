%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [track_temp1, track_normal, ones_result] = create_formaltrack(track_temp, track_normal, ones_result, TT, t)
%������ʱ�켣����Ŀ�괴����ʽ�켣��3�㼴���γ���ʽ�켣
temp_num = length(track_temp);%��ʱ�켣����Ŀ
scan_num = size(ones_result,1); %����ɨ���������ۺϺ����Ŀ
time_diff = 2*TT;%Ŀ��������Ĺ켣Ŀ������ʱ�䲻�ܳ�����������
fangwei_diff = 4; %Ŀ��������켣Ŀ�����ķ�λ���ܳ���fangwei_diff ��
dis_diff = 3; %Ŀ��������켣Ŀ�����ľ��벻�ܳ���dis_diff m
v_diff = 3; %Ŀ���ٶ���Ԥ���ٶ����ܳ���v_diff
track_temp1 = track_temp; %����track_temp����һ��ѭ���У����ϱ仯���²���i����ʧ�ܣ������������
for i=1:temp_num
    onetemptrack = track_temp{i}; %��ȡһ����ʱ�켣
    scan_result = 1; %�ٶ������Ҫ���Ŀ������Ϊ1
    minWeight = 10000; %��ʼ����СȨ��ֵΪһ���ܴ��ֵ
    for j = 1:scan_num
        if(~isempty(ones_result))
            one = ones_result(j,:); %��ȡһ��ɨ��Ŀ��
            [isTrue, Weightmean] = temptrackfindobject(onetemptrack, one, time_diff, dis_diff, v_diff, fangwei_diff,TT,t);%�õ��Ƿ������������ϣ��������Ȩ�ؼӺ�Ϊ����
            if(Weightmean < minWeight && isTrue)
                minWeight = Weightmean;
                scan_result = j;
            end
        end
    end
    if(minWeight ~= 10000) %ȷ���ҵ����ʵ�Ŀ��
        formal = [onetemptrack; ones_result(j,:)];
        track_normal = [track_normal formal];%������ʽ�켣�����뵽������
        track_temp1(i) = []; %ɾ����ʱ�켣
        ones_result(j,:) = []; %ɾ���Ѵ����Ŀ��
    end
end
end
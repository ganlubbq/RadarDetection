%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [track_temp, track_head1, ones_result1] = create_temptrack(track_temp, track_head, ones_result, TT)
%���ݹ켣ͷ��ƥ����ʵ���ʱ�켣
head_num = size(track_head, 1);%�켣ͷ������
scan_num = size(ones_result,1);%����ɨ���������ۺϺ����Ŀ
time_diff = 2*TT;%�켣ͷ��Ŀ������ʱ�䲻�ܳ�����������
time_diff_min = 0.5*TT;%����С��һ������
dis_diff = 4; %�켣ͷ��Ŀ�����ľ��벻�ܳ���dis_diff m
v_diff = 3; %�켣ͷ��Ŀ�������ٶȲ��ܳ���v_diff
fangwei_diff = 3; %�켣ͷ��Ŀ�����ķ�λ���ܳ���fangwei_diff ��
track_head1 = track_head; %����track_head����һ��ѭ���У����ϱ仯���²���i����ʧ�ܣ������������
ones_result1 = ones_result;
k=0;
for i=1: head_num
    head = track_head(i, :); %��ȡһ���켣ͷ
    scan_result = 1; %�ٶ������Ҫ���Ŀ������Ϊ1
    minWeignt = 10000;%��ʼ����СȨ��ֵΪһ���ܴ��ֵ
    for j = 1:scan_num
        if(~isempty(ones_result1))
            one = ones_result(j,:); %��ȡһ��ɨ��Ŀ��
            [isTrue, Weightmean]= headfindobject(head, one, time_diff,time_diff_min,dis_diff,v_diff,fangwei_diff); %�õ��Ƿ������������ϣ��������Ȩ�ؼӺ�Ϊ����
            if(Weightmean < minWeignt && isTrue)
                minWeignt = Weightmean;
                scan_result = j;
            end
        end
    end
    if(minWeignt ~= 10000)%ȷ���ҵ����ʵ�Ŀ��
        temp = [head; ones_result(j,:)];
        track_temp = [track_temp temp];%������ʱ�켣�����뵽������
        track_head1(i,:) = [];%ɾ���ù켣ͷ
        ones_result1(j-k,:) = [];%ɾ����Ŀ��
        k=k+1;
    end
    
end
end
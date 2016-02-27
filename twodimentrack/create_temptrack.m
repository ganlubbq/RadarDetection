%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [track_temp, track_head1, ones_result] = create_temptrack(track_temp, track_head, ones_result, TT)
%���ݹ켣ͷ��ƥ����ʵ���ʱ�켣
head_num = size(track_head, 1);%�켣ͷ������
scan_num = size(ones_result,1);%����ɨ���������ۺϺ����Ŀ
time_diff = 2*TT;%�켣ͷ��Ŀ������ʱ�䲻�ܳ�����������
dis_diff = 15; %�켣ͷ��Ŀ�����ľ��벻�ܳ���dis_diff m
v_diff = 5; %�켣ͷ��Ŀ�������ٶȲ��ܳ���v_diff
fangwei_diff = 5; %�켣ͷ��Ŀ�����ķ�λ���ܳ���fangwei_diff ��
track_head1 = track_head; %����track_head����һ��ѭ���У����ϱ仯���²���i����ʧ�ܣ������������
for i=1: head_num
    head = track_head(i, :); %��ȡһ���켣ͷ    
    scan_result = 1; %�ٶ������Ҫ���Ŀ������Ϊ1
    minWeignt = 10000;%��ʼ����СȨ��ֵΪһ���ܴ��ֵ
    for j = 1:scan_num
        one = ones_result(j,:); %��ȡһ��ɨ��Ŀ��
        [isTrue, Weightmean]= headfindobject(head, one, time_diff,dis_diff,v_diff,fangwei_diff); %�õ��Ƿ������������ϣ��������Ȩ�ؼӺ�Ϊ����
        if(Weightmean < minWeignt)
            minWeignt = Weightmean;
            scan_result = j;
        end
    end
    if(minWeignt ~= 10000)%ȷ���ҵ����ʵ�Ŀ��
        temp = [head; ones_result(j,:)];
        track_temp = {track_temp temp};%������ʱ�켣�����뵽������
        track_head1(i) = [];%ɾ���ù켣ͷ
        ones_result(j) = [];%ɾ����Ŀ��
    end
    
end
end
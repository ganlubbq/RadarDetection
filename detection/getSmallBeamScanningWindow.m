%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SmallBeamTrackingWindow = getSmallBeamScanningWindow(objects_l, objects_w)
%����Ҫ���ٵ�Ŀ�꣬ȷ��С������˳��ɨ�贰
%objects_lΪ������ɨ�赽�Ķ������ĺ������
%objects_wΪ������ɨ�赽�Ķ��������������
global small_beam big_beam map_length map_width
Object_l = objects_l(1); %���ڴ������޷��ֱ�����ķ�λ�����ÿ��Ŀ������������ȣ�ȡ����������
minObejctW = min(objects_w); %����Ŀ������������С��
maxObjectW = max(objects_w);
minBeamPos_l = floor((Object_l - big_beam / 2) / small_beam) + 1;%�����ں���С��������Сλ��
maxBeamPos_l = floor((Object_l + big_beam / 2) / small_beam);%�����ں���С���������λ��
minBeamPos_w = floor(minObejctW / small_beam) + 1;
maxBeamPos_w = floor(maxObjectW / small_beam) + 1;
SmallBeamTrackingWindow = zeros((maxBeamPos_w - minBeamPos_w + 1) * (maxBeamPos_l - minBeamPos_l + 1), 2); %��������С������ɨ�贰����Ϊ���У�ÿ�зֱ�Ϊ[������λ�� ������λ��]
index = 1;
for j = 1:maxBeamPos_w - minBeamPos_w + 1
    for i = 1:maxBeamPos_l - minBeamPos_l + 1
        SmallBeamTrackingWindow(index, :) = [minBeamPos_l - 1 + i minBeamPos_w - 1 + j];
        index = index + 1;
    end
end
end
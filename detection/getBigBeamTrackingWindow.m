%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function BigBeamTrackingWindow = getBigBeamTrackingWindow(BigBeamTrackingObject)
%BigBeamTrackingObject��������Ҫɨ��Ķ��Ŀ�꣬�ö��б�ʾ��ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
%%TODO: movingTrendL��ʾ������˶����ƣ�������������ɨ�贰�ķ�Χ,Ĭ��Ϊ0��-1����1����
%BigBeamTrackingWindowΪ������������ÿ��Ŀ���ɨ�贰����Ϊ���У�ÿ�зֱ�Ϊ[������λ�� ������λ��]
global big_beam map_length map_width
objectNum = size(BigBeamTrackingObject, 1);
BigBeamTrackingWindow = [];
for i = 1:objectNum
    singleObject = BigBeamTrackingObject(i, :); %����Ŀ����Ϣ��[L W V]
    beamPos_l = floor(singleObject(1) / big_beam) + 1;
    beamPos_w = floor(singleObject(2) / big_beam) + 1;
    
    %�����ʱ����Ҫ���Ǽ��˵���������粨���������ϣ����£����ϣ����£�����λ�ڱ߽�����µ�ɨ�贰���
    if beamPos_l == 1
        if beamPos_w == floor(map_width / big_beam) %����
            BigBeamTrackingWindow = [beamPos_l beamPos_w; beamPos_l+1 beamPos_w];
        else
            BigBeamTrackingWindow = [beamPos_l beamPos_w;
                beamPos_l+1 beamPos_w;
                beamPos_l beamPos_w+1;
                beamPos_l+1 beamPos_w+1];
        end
    else
        if beamPos_l == floor(map_length / big_beam)
            if beamPos_w == floor(map_width / big_beam) %����
                BigBeamTrackingWindow = [beamPos_l beamPos_w; beamPos_l-1 beamPos_w];
            else
                BigBeamTrackingWindow = [beamPos_l beamPos_w;
                    beamPos_l-1 beamPos_w;
                    beamPos_l beamPos_w-1;
                    beamPos_l-1 beamPos_w-1];
            end
        else%�м������
            if beamPos_w == floor(map_width / big_beam)
                BigBeamTrackingWindow = [beamPos_l-1 beamPos_w; beamPos_l beamPos_w; beamPos_l+1 beamPos_w];
            else
                BigBeamTrackingWindow = [beamPos_l-1 beamPos_w; beamPos_l beamPos_w; beamPos_l+1 beamPos_w;
                    beamPos_l-1 beamPos_w+1; beamPos_l beamPos_w+1; beamPos_l+1 beamPos_w+1];
            end
        end
    end
end
end
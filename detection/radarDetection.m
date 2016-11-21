%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;
%ȫ�ֱ�������
global T f0 B Fs N M RCS c
global map VW RL RW map_l map_w map_length map_width R_pre_lmp R_pre_wmp objectNum big_beam small_beam deltaR points_num;
load('simuConfig.mat');%�����״���������ļ�
fprintf('���ز������\n');
Tb = map_length*map_width/(big_beam*big_beam)*T1; %����ɨ�������������ʱ��
t = 0:T1:time_num*Tb; %ʱ����
len = size(t,2);
VL = V_init_l*ones(1,len) + A_init_l*t;%����Ŀ���ٶ�ʱ����
VW = V_init_w*ones(1,len) + A_init_w*t;%����Ŀ���ٶ�ʱ����
RL = R_init_l*ones(1,len) + (V_init_l*t + 0.5*A_init_l*t.^2);%����Ŀ�����ʱ����
RW = R_init_w*ones(1,len) + (V_init_w*t + 0.5*A_init_w*t.^2);%����Ŀ�����ʱ����
%TODO:���ٶȿ�����һ����Χ�ڸ���


%%
%���ܲ�������
global outOfRange;
outOfRange = zeros(points_num, 1);
prePath = cell(1,points_num);
%������ز���
beamPos_w = 1;
beamPos_l = 1;%������λ��
big_has_small_num = ceil(big_beam/small_beam); %�����ڰ�����С��������
num_l = floor(map_length / big_beam); %��������ɨ�����
num_w = floor(map_width / big_beam);%��������ɨ�����
track_flag = 0; %�ж��Ƿ�������ģʽ��0Ϊ�����٣�����ɨ��ģʽ��1Ϊ�������٣�2ΪС����ɨ��
points = []; %����ɨ��ģʽ��ɨ������������ĵ㼣��һ�����ڵĵ㼣����Ϊ���У�ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
object = cell(1, time_num);%����ÿ�������ڵ�ɨ��Ŀ����Ϣ(����ɨ��ģʽ�������һ���������ж��Ŀ�꣬�ö��б�ʾ��ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
BigBeamScanningCount = 1;%ɨ��ģʽ�´���ɨ������ڴ���
trackingobject = cell(1, smallScanningNum);%��������������ڵ�ÿ��ɨ�����������Ŀ����Ϣ�����һ���������ж��Ŀ�꣬�ö��б�ʾ��ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
trackingAllObject = {};%��������ʱ��ĸ�������������ۺ���Ϣ
integraObject = [];%����ÿ������ɨ���������ں��ۺϵ���Ϣ���ö��б�ʾ��ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
isWarning = 0; %�ж��Ƿ���ҪԤ����1Ϊ���ģԤ����2ΪС��ģԤ��
smallScanningCount = 1; %����С����ɨ������������Ĵ���������smallScanningNumʱ����Ҫ����Ϊ����ɨ��
BigBeamTrackingObject = []; %�������ٴ��ڵ�Ŀ�����
SmallPoint = [];
fprintf('��ʼ����ɨ��.....................\n');
for i = 1:len
    updatemap(i); %ʵʱ����map
    figure(3)
    plot(RL(:,i),RW(:,i),'*');
    axis([0 map_length 0 map_width]);
    title('�˶�Ŀ��ԭʼ�㼣��Ϣ');
    for index = 1:points_num
        if outOfRange(index) == 0
            prePath{1,index} = [prePath{1,index} [R_pre_lmp(index)*map_l; R_pre_wmp(index)*map_w]]; %ģ��������˶�ģ�͹켣
        end
    end
    if track_flag == 0 %ɨ��ģʽ
        [hasObject, objects_l, objects_w, objects_v] = BeamFindObject(beamPos_l, beamPos_w, 1);%�жϵ�ǰ�����Ƿ���Ŀ�꣬����У���¼�µ㼣
        if hasObject
            for k = 1:size(objects_l,1)
                fprintf('����ɨ�跢��Ŀ��,����(%f,%f)���ٶ�%f\n',objects_l(k), objects_w(k), objects_v(k));
            end
            points = [points ;objects_l objects_w objects_v];
        end
        
        beamPos_l = beamPos_l + 1;%�л���һ���������Ⱥ���ɨ����ɨ����βʱ�л�����һ��
        if beamPos_l > num_l
            beamPos_w = beamPos_w + 1; %����
            beamPos_l = 1;%�л�������
        end
        
        if beamPos_w > num_w
            i
            fprintf('һ��������ɨ���������ʼ�����ķ�������\n');
            beamPos_w = 1;
            beamPos_l = 1;
            if ~isempty(points)
                if size(points,1) > maxPointsNum
                    isWarning = 1;
                    fprintf('�ۣ��ö�㼣�����϶�������ʯ����,������˵��\n');
                end
                [objectCell, clusternum] = handlePoints(points, minPts, distanceWDoor, velocityDoor, parameterWeight, 1);%�����㼣�ۺϴ���
                fprintf('�㼣�ۺ���ϣ�����%d������Ŀ��\n', clusternum);
                %����ÿ���ص�Ŀ���ųߴ磬����ƽ��ֵ��������
                for j = 1:clusternum
                    cludisl = objectCell{j}(:,1);%ȡ���еĺ������ά
                    cludisw = objectCell{j}(:,2);%ȡ���е��������ά
                    cluv = objectCell{j}(:,3);%ȥ���е��ٶ�ά
                    clustersize = max(cludisw) - min(cludisw);
                    %���������ڵķ���������Ŀ����Ϣ�ʹ�С��Ϣ����ojbect����
                    fprintf('�㼣���ˣ�����С��С�������˳������ٶ�Ϊ����Ŀ���޳�\n');
                    if clustersize > minObjectSize && mean(cluv) < 0
                        if clustersize > maxObjectSize
                            isWarning = 1;
                            fprintf('������һ���ô�����尡����Σ�գ���ҪԤ����\n');
                        end
                        if(isempty(object{BigBeamScanningCount}))
                            object{BigBeamScanningCount} = [mean(cludisl) mean(cludisw) mean(cluv) clustersize];
                        else
                            object{BigBeamScanningCount} = [object{BigBeamScanningCount};mean(cludisl) mean(cludisw) mean(cluv) clustersize];
                        end
                    end
                end
                %�õ�������������С���õ�����̽��������ۺϵ���Ϣ
                BigBeamScanningCount
                if ~isempty(object{BigBeamScanningCount})
                    effectiveNum = size(object{BigBeamScanningCount},1); %����������в�Ե�Ŀ������
                    integraDisL = mean(object{BigBeamScanningCount}(:,1));%���������ڵ�����Ŀ������ĵ�������
                    integraDisW = max(object{BigBeamScanningCount}(:,2));%���������ڵ�����Ŀ�������������ֵ
                    integraV = mean(object{BigBeamScanningCount}(:,3));%���������ڵ�����Ŀ������ĵ��ٶ�
                    fprintf('��%d����в��Ŀ����֣��ۺ�λ��Ϊ(%f,%f),�ٶ�Ϊ%f\n',effectiveNum, integraDisL, integraDisW, integraV);
                    
                    figure(2)
                    if isWarning == 1
                        plot(object{BigBeamScanningCount}(:,1),object{BigBeamScanningCount}(:,2), 'r*');
                    else
                        plot(object{BigBeamScanningCount}(:,1),object{BigBeamScanningCount}(:,2), 'b*');
                    end
                    axis([0 map_length 0 map_width]);
                    title('���������Ŀ��ʵʱ�˶���Ϣ');
                    figure(1)
                    plot(object{BigBeamScanningCount}(:,1),object{BigBeamScanningCount}(:,2), 'r*');
                    axis([0 map_length 0 map_width]);
                    hold on
                    title('����������˶��켣');
                    for k = 1:effectiveNum
                        fprintf('��%d����в��Ŀ��λ��(%f,%f),�ٶ�Ϊ%f\n����СΪ%f\n',k, object{BigBeamScanningCount}(k,1), object{BigBeamScanningCount}(k,2), object{BigBeamScanningCount}(k,3),object{BigBeamScanningCount}(k,4));
                        plotObject(object{BigBeamScanningCount}(k,1), object{BigBeamScanningCount}(k,2),object{BigBeamScanningCount}(k,4)/2);
                    end
                    pause(0.1);
                    if effectiveNum < trackObjectNum
                        fprintf('����Ŀ���������٣��л�����������ģʽ\n');
                        track_flag = 1; %�л�����������ģʽ
                        BigBeamTrackingObject = object{BigBeamScanningCount};%�趨��Ҫ���ٵ�Ŀ��
                        %TODO: movingTrendL = zeros(1, effectiveNum);%�����ƶ������ƣ�-1Ϊ����1Ϊ���ң�Ĭ��Ϊ0
                        BigBeamTrackingWindow = getBigBeamTrackingWindow(BigBeamTrackingObject);%����Ҫ���ٵ�Ŀ�꣬ȷ�������ĸ���ɨ�贰
                        %��ر���״̬�ĳ�ʼ��
                        points = [];
                        %integraObject = [];
                        % BigBeamScanningCount = 1;
                    else
                        if isempty(integraObject)
                            integraObject = [integraDisL integraDisW integraV];
                        else
                            if integraDisW < integraObject(end, 2) %����һ�ε��������Ƚϣ����С�����������ڽӽ���
                                integraObject = [integraObject;integraDisL integraDisW integraV];%�����ۺϵ���Ϣ����
                                if size(integraObject,1) >= continuousCount %��������ӽ��Ĵ����ﵽ�趨��������Ԥ��
                                    isWarning = 1;
                                    fprintf('ز���������ģ������������\n');
                                    fprintf('ز���������ģ������������\n');
                                    fprintf('ز���������ģ������������\n');
                                    %TODO:�����»�ͼ������
                                end
                            else
                                %�������Զ������ƣ���֮ǰ��������������¿�ʼ��������
                                isWarning = 0;
                                integraObject = [integraDisL integraDisW integraV];
                            end
                        end
                        points = []; %���points
                    end
                else
                    fprintf('��ɨ������δ��������в��Ŀ��\n');
                end
                BigBeamScanningCount = BigBeamScanningCount + 1;
                points = [];
            else
                fprintf('������ɨ������δ���ֿ��ɵ㼣��all clear!\n');
            end
        end
    else
        if track_flag == 1 %��������ģʽ
            %�Ӹ��ٴ�������ȷ������ɨ���λ��
            if ~isempty(BigBeamTrackingWindow)
                beamPos_l = BigBeamTrackingWindow(1, 1); %ȡ���ο���
                beamPos_w = BigBeamTrackingWindow(1, 2); %ȡ���ο���
                BigBeamTrackingWindow(1, :) = [];
                [hasObject, objects_l, objects_w, objects_v] = BeamFindObject(beamPos_l, beamPos_w, 1);%�жϵ�ǰ�����Ƿ���Ŀ�꣬����У���¼�µ㼣
                if hasObject == 1
                    fprintf('�ô����ڷ���%d���㼣\n', size(objects_l,1));
                    for k = 1:size(objects_l,1)
                        fprintf('�������ٷ���Ŀ��,����(%f,%f)���ٶ�%f\n',objects_l(k), objects_w(k), objects_v(k));
                    end
                    fprintf('�л���С����ɨ��\n')
                    track_flag = 2;
                    %points = [points ;objects_l objects_w objects_v];%��������̽�⵽�ĵ����ڸ����ж�
                    SmallBeamTrackingWindow = getSmallBeamScanningWindow(objects_l, objects_w);%����Ҫ���ٵ�Ŀ�꣬ȷ��С������˳��ɨ�贰
                end
            else
                fprintf('һ����������ɨ���꣬��ʼ��������\n');
                effectiveNum = 0;
                if ~isempty(points)
                    [objectCell, clusternum] = handlePoints(points, minPts, distanceWDoor, velocityDoor, parameterWeight, 2);%С�����㼣�ۺϴ���
                    fprintf('�㼣�ۺ���ϣ�����%d������Ŀ��\n', clusternum);
                    
                    for j = 1:clusternum
                        cludisl = objectCell{j}(:,1);%ȡ���еĺ������ά
                        cludisw = objectCell{j}(:,2);%ȡ���е��������ά
                        cluv = objectCell{j}(:,3);%ȥ���е��ٶ�ά
                        clustersize = max(cludisw) - min(cludisw);
                        %���������ڵķ���������Ŀ����Ϣ�ʹ�С��Ϣ����ojbect����
                        fprintf('�㼣���ˣ�����С��С�������˳������ٶ�Ϊ����Ŀ���޳�\n');
                        if clustersize > 1 && mean(cluv) < 0
                            if(isempty(trackingobject{smallScanningCount}))
                                trackingobject{smallScanningCount} = [mean(cludisl) mean(cludisw) mean(cluv) clustersize];
                            else
                                trackingobject{smallScanningCount} = [trackingobject{smallScanningCount};mean(cludisl) mean(cludisw) mean(cluv) clustersize];
                            end
                        end
                    end
                    trackingAllObject = [trackingAllObject trackingobject{smallScanningCount}];
                    figure(2)
                    if isWarning == 2
                        plot(trackingAllObject{end}(:,1),trackingAllObject{end}(:,2), 'g*');
                    else
                        plot(trackingAllObject{end}(:,1),trackingAllObject{end}(:,2), '*');
                    end
                    axis([0 map_length 0 map_width]);
                    title('���������Ŀ��ʵʱ�˶���Ϣ');
                    figure(1)
                    plot(trackingAllObject{end}(:,1),trackingAllObject{end}(:,2), '*');
                    axis([0 map_length 0 map_width]);
                    hold on
                    
                    %�õ�������������С���õ�����̽��������ۺϵ���Ϣ
                    if ~isempty(trackingobject{smallScanningCount})
                        effectiveNum = size(trackingobject{smallScanningCount},1); %����������в�Ե�Ŀ������
                        integraDisL = mean(trackingobject{smallScanningCount}(:,1));%���������ڵ�����Ŀ������ĵ�������
                        integraDisW = mean(trackingobject{smallScanningCount}(:,2));%���������ڵ�����Ŀ�������������ֵ
                        integraV = mean(trackingobject{smallScanningCount}(:,3));%���������ڵ�����Ŀ������ĵ��ٶ�
                        fprintf('��%d����в��Ŀ����֣��ۺ�λ��Ϊ(%f,%f),�ٶ�Ϊ%f\n',effectiveNum, integraDisL, integraDisW, integraV);
                        for k = 1:effectiveNum
                            fprintf('��%d����в��Ŀ��λ��(%f,%f),�ٶ�Ϊ%f\n����СΪ%f\n',k, trackingobject{smallScanningCount}(k,1), trackingobject{smallScanningCount}(k,2), trackingobject{smallScanningCount}(k,3),trackingobject{smallScanningCount}(k,4));
                            plotObject(trackingobject{smallScanningCount}(k,1), trackingobject{smallScanningCount}(k,2),trackingobject{smallScanningCount}(k,4)/2);
                        end
                        pause(0.1);
                        %TODO����ͼ
                        if effectiveNum > trackObjectNum
                            fprintf('Ŀ�������϶࣬��Ϊ����ɨ��ģʽ\n');
                            track_flag = 0;
                            %��ر���״̬�ĳ�ʼ��
                            points = [];
                        else
                            %��������ģʽ
                            fprintf('�������д�������ģʽ\n');
                            if isempty(integraObject)
                                integraObject = [integraDisL integraDisW integraV];
                            else
                                if integraDisW < integraObject(end, 2) %����һ�ε��������Ƚϣ����С�����������ڽӽ���
                                    integraObject = [integraObject;integraDisL integraDisW integraV];%�����ۺϵ���Ϣ����
                                    if size(integraObject,1) >= continuousCount %��������ӽ��Ĵ����ﵽ�趨��������Ԥ��
                                        isWarning = 2;
                                        fprintf('�ף�������������\n');
                                        fprintf('�ף�������������\n');
                                        fprintf('�ף�������������\n');
                                        %TODO:�����»�ͼ������
                                    end
                                else
                                    %�������Զ������ƣ���֮ǰ��������������¿�ʼ��������
                                    fprintf('�������Զ������ƣ���֮ǰ��������������¿�ʼ��������\n');
                                    integraObject = [integraDisL integraDisW integraV];
                                    isWarning = 0;
                                end
                            end
                        end
                        %��ز�����ʼ��
                        points = [];
                        BigBeamTrackingObject = trackingobject{smallScanningCount};%�趨��һ����Ҫ���ٵ�Ŀ��
                        BigBeamTrackingWindow = getBigBeamTrackingWindow(BigBeamTrackingObject);%����Ҫ���ٵ�Ŀ�꣬ȷ�������ĸ���ɨ�贰
                        
                        smallScanningCount = smallScanningCount + 1;
                        if smallScanningCount > smallScanningNum
                            fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ڹ涨��С���������������ڵĴ����������ô���ȫ��ɨ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n');
                            track_flag = 0; %���ڹ涨��С���������������ڵĴ����������ô���ȫ��ɨ��
                            beamPos_w = 1; %�������³�ʼ��
                            beamPos_l = 1;
                            points = [];
                            trackingobject = cell(1, smallScanningNum);
                            smallScanningCount = 1;
                        else
                            track_flag = 1; %������������
                        end
                    else
                        fprintf('���ٴ����δ��������в��Ŀ��,�����ô���ɨ��\n');
                        track_flag = 0;
                        isWarning = 0;
                        beamPos_w = 1; %�������³�ʼ��
                        beamPos_l = 1;
                        points = [];
                        trackingobject = cell(1, smallScanningNum);
                        smallScanningCount = 1;
                        BigBeamTrackingWindow = [];
                    end
                else
                    fprintf('��������δ����Ŀ�꣬���ٶ�ʧ�������ô���ɨ��\n');
                    track_flag = 0;
                    isWarning = 0;
                    beamPos_w = 1; %�������³�ʼ��
                    beamPos_l = 1;
                    points = [];
                    trackingobject = cell(1, smallScanningNum);
                    smallScanningCount = 1;
                    BigBeamTrackingWindow = [];
                end
            end
        else %С����ɨ��ģʽ
            if ~isempty(SmallBeamTrackingWindow)
                beamPos_l = SmallBeamTrackingWindow(1, 1); %ȡ���ο���
                beamPos_w = SmallBeamTrackingWindow(1, 2); %ȡ���ο���
                SmallBeamTrackingWindow(1, :) = [];
                [hasObject, objects_l, objects_w, objects_v] = BeamFindObject(beamPos_l, beamPos_w, 2);%�жϵ�ǰ�����Ƿ���Ŀ�꣬����У���¼�µ㼣
                if hasObject
                    fprintf('�����е�С��������%d���㼣\n', size(objects_l,1));
                    for k = 1:size(objects_l,1)
                        fprintf('С����ɨ�跢��Ŀ��,����(%f,%f)���ٶ�%f\n',objects_l(k), objects_w(k), objects_v(k));
                    end
                    points = [points ;objects_l objects_w objects_v];
                end
            else
                %�����ڵ�С����ȫ��ɨ���꣬�лص���������
                fprintf('�����ڵ�С����ȫ��ɨ���꣬�лص���������\n');
                track_flag = 1;
            end
        end
    end
end
%�����˶�ģ�͹켣·��
% figure
% for index = 1:points_num
%     plot(prePath{1,index}(1,:),prePath{1,index}(2,:),'*');
%     hold on
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;
%ȫ�ֱ�������
global map VW RL RW map_l map_w map_length map_width R_pre_lmp R_pre_wmp objectNum big_beam small_beam deltaR;
load('simuConfig.mat');%�����״���������ļ�

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
outOfRange = zeros(objectNum, 1);
prePath = cell(1,objectNum);
%������ز���
beamPos_w = 1;
beamPos_l = 1;%������λ��
big_has_small_num = ceil(big_beam/small_beam); %�����ڰ�����С��������
num_l = floor(map_length / big_beam); %��������ɨ�����
num_w = floor(map_width / big_beam);%��������ɨ�����
track_flag = 0; %�ж��Ƿ�������ģʽ��0Ϊ�����٣�����ɨ��ģʽ��1Ϊ�������٣�2ΪС����ɨ��
points = []; %����ɨ��ģʽ��ɨ������������ĵ㼣��һ�����ڵĵ㼣����Ϊ���У�ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
object = cell(1, time_num);%����ÿ�������ڵ�ɨ��Ŀ����Ϣ�����һ���������ж��Ŀ�꣬�ö��б�ʾ��ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
integraObject = [];%����ÿ������ɨ���������ں��ۺϵ���Ϣ���ö��б�ʾ��ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
isWarning = 0; %�ж��Ƿ���ҪԤ��
smallScanningCount = 0; %����С����ɨ������������Ĵ���������smallScanningNumʱ����Ҫ����Ϊ����ɨ��
BigBeamTrackingObject = []; %�������ٴ��ڵ�Ŀ�����
SmallPoint = [];

for i = 1:len
    updatemap(i); %ʵʱ����map
    for index = 1:objectNum
        if outOfRange(index) == 0
            prePath{1,index} = [prePath{1,index} [R_pre_lmp(index)*map_l; R_pre_wmp(index)*map_w]]; %ģ��������˶�ģ�͹켣
        end
    end
    if track_flag == 0 %ɨ��ģʽ
        [hasObject, objects_l, objects_w, objects_v] = BeamFindObject(beamPos_l, beamPos_w, 1);%�жϵ�ǰ�����Ƿ���Ŀ�꣬����У���¼�µ㼣
        if hasObject
            points = [points ;objects_l objects_w objects_v];
        end
        
        beamPos_l = beamPos_l + 1;%�л���һ���������Ⱥ���ɨ����ɨ����βʱ�л�����һ��
        if beamPos_l > num_l
            beamPos_w = beamPos_w + 1; %����
            beamPos_l = 1;%�л�������
        end
        
        if beamPos_w > num_w
            %һ��������ɨ���������ʼ�����ķ�������
            beamPos_w = 1;
            beamPos_l = 1;
            if ~isempty(points)
                pointsnum = size(points, 1); %���е㼣�ĸ���
                %��ʼ�㼣����
                [class, type] = dbscan(points, minPts, sqrt(distanceLDoor^2 + (2 * big_beam)^2 + velocityDoor^2));
                clusternum = max(class); %�ۺϺ�ص�����
                objectCell = cell(1, clusternum);%��Ÿ����ص�cell��Ԫ
                objectSize = zeros(1, clusternum); %��������صĴ�ųߴ磬�û������ĵ㼣����
                
                %��Ŀ�����dbscan������class�����ֱ�ֵ���Ӧ��cell�ص�Ԫ��
                for j = 1:pointsnum
                    if isempty(objectCell{class(j)})
                        objectCell{class(j)} = points(j,:);
                    else
                        objectCell{class(j)} = [objectCell{class(j)}; points(j,:)];
                    end
                end
                %����ÿ���ص�Ŀ���ųߴ磬����ƽ��ֵ��������
                for j = 1:clusternum
                    cludisl = objectCell{j}(:,1);%ȡ���еĺ������ά
                    cludisw = objectCell{j}(:,2);%ȡ���е��������ά
                    cluv = objectCell{j}(:,3);%ȥ���е��ٶ�ά
                    clustersize = max(clsdisw) - min(clsdisw);
                    %���������ڵķ���������Ŀ����Ϣ�ʹ�С��Ϣ����ojbect����
                    %�㼣���ˣ�����С��С�������˳������ٶ�Ϊ����Ŀ���޳�
                    if clustersize > 1 && cluv < 0
                        if(isempty(object{i}))
                            object{i} = [mean(cludisl) mean(cludisw) mean(cluv) clustersize];
                        else
                            object{i} = [object{i};mean(cludisl) mean(cludisw) mean(cluv) clustersize];
                        end
                    end
                end
                %�õ�������������С���õ�����̽��������ۺϵ���Ϣ
                effectiveNum = size(object{i},1); %����������в�Ե�Ŀ������
                integraDisL = mean(object{i}(:,1));%���������ڵ�����Ŀ������ĵ�������
                integraDisW = mean(object{i}(:,2));%���������ڵ�����Ŀ������ĵ��������
                integraV = mean(object{i}(:,3));%���������ڵ�����Ŀ������ĵ��ٶ�
                if effectiveNum < trackObjectNum
                    track_flag = 1; %�л�����������ģʽ
                    BigBeamTrackingObject = object{i};%�趨��Ҫ���ٵ�Ŀ��
                    %TODO: movingTrendL = zeros(1, effectiveNum);%�����ƶ������ƣ�-1Ϊ����1Ϊ���ң�Ĭ��Ϊ0
                    BigBeamTrackingWindow = getBigBeamTrackingWindow(BigBeamTrackingObject);%����Ҫ���ٵ�Ŀ�꣬ȷ�������ĸ���ɨ�贰
                else
                    if isempty(integraObject)
                        integraObject = [integraDisL integraDisW integraV];
                    else
                        if integraDisW < integraObject(end, 2) %����һ�ε��������Ƚϣ����С�����������ڽӽ���
                            integraObject = [integraObject;integraDisL integraDisW integraV];%�����ۺϵ���Ϣ����
                            if size(integraObject,1) >= continuousCount %��������ӽ��Ĵ����ﵽ�趨��������Ԥ��
                                isWarning = 1;
                                fprintf('ز������������������\n');
                                fprintf('ز������������������\n');
                                fprintf('ز������������������\n');
                                %TODO:�����»�ͼ������
                            end
                        else
                            %�������Զ������ƣ���֮ǰ��������������¿�ʼ��������
                            integraObject = [integraDisL integraDisW integraV];
                        end
                    end
                end
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
                    track_flag = 2;
                    SmallBeamTrackingWindow = getSmallBeamScanningWindow(objects_l, objects_w);%����Ҫ���ٵ�Ŀ�꣬ȷ��С������˳��ɨ�贰
                end
            else
                %һ����������ɨ���꣬��ʼ��������
                smallScanningCount = smallScanningCount + 1;
                if smallScanningCount > smallScanningNum
                    track_flag = 0; %���ڹ涨��С���������������ڵĴ����������ô���ȫ��ɨ��
                else
                    track_flag = 1; %������������
                end
            end
        else %С����ɨ��ģʽ
            if ~isempty(SmallBeamTrackingWindow)
                beamPos_l = SmallBeamTrackingWindow(1, 1); %ȡ���ο���
                beamPos_w = SmallBeamTrackingWindow(1, 2); %ȡ���ο���
                SmallBeamTrackingWindow(1, :) = [];
                [hasObject, objects_l, objects_w, objects_v] = BeamFindObject(beamPos_l, beamPos_w, 2);%�жϵ�ǰ�����Ƿ���Ŀ�꣬����У���¼�µ㼣
            else
                %�����ڵ�С����ȫ��ɨ���꣬�лص���������
                track_flag = 1;
            end
        end
    end
end
%�����˶�ģ�͹켣·��
figure
for index = 1:objectNum
    plot(prePath{1,index}(1,:),prePath{1,index}(2,:),'*');
    hold on
end


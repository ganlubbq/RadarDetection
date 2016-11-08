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
num_l = map_length / big_beam; %��������ɨ�����
num_w = map_width / big_beam;%��������ɨ�����
track_flag = 0; %�ж��Ƿ�������ģʽ��0Ϊ�����٣�ɨ��ģʽ��1Ϊ�������٣�2ΪС��������
points = []; %����ɨ��ģʽ��ɨ������������ĵ㼣��һ�����ڵĵ㼣����Ϊ���У�ÿ�зֱ�Ϊ[������� ������� �����ٶ�]
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
            %��ʼ�㼣����
            
            %�㼣����
            
            %�õ�������������С
            
            %�õ�����̽��������ۺϵ���Ϣ
            
        end
    end
end
%�����˶�ģ�͹켣·��
figure
for index = 1:objectNum
    plot(prePath{1,index}(1,:),prePath{1,index}(2,:),'*');
    hold on
end


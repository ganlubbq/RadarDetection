%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc;
%ȫ�ֱ�������
global map VW RL RW map_l map_w map_length map_width R_pre_lmp R_pre_wmp objectNum;
load('simuConfig.mat');%�����״���������ļ�

Tb = map_length*map_width/(big_beam*big_beam)*T1; %����ɨ�������������ʱ��
t = 0:T1:time_num*Tb; %ʱ����
len = size(t,2);
VL = V_init_l*ones(1,len) + A_init_l*t;%����Ŀ���ٶ�ʱ����
VW = V_init_w*ones(1,len) + A_init_w*t;%����Ŀ���ٶ�ʱ����
RL = R_init_l*ones(1,len) + (V_init_l*t + 0.5*A_init_l*t.^2);
RW = R_init_w*ones(1,len) + (V_init_w*t + 0.5*A_init_w*t.^2);
%TDODO:���ٶȿ�����һ����Χ�ڸ���


%%
%���ܲ�������
global outOfRange;
outOfRange = zeros(objectNum, 1);
prePath = cell(1,objectNum);
for i = 1:len
    updatemap(i); %ʵʱ����map
    for index = 1:objectNum
       if outOfRange(index) == 0
           prePath{1,index} = [prePath{1,index} [R_pre_lmp(index)*map_l; R_pre_wmp(index)*map_w]];
       end
    end
end
%�����˶�ģ�͹켣·��
figure
for index = 1:objectNum
    plot(prePath{1,index}(1,:),prePath{1,index}(2,:),'*');
    hold on
end

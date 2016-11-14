%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [R_init_l, R_init_w, V_init_l, V_init_w, A_init_l, A_init_w] = getRandomInitObject(objectNum, map_length, map_width, deltaR)
% R_init_l = randi([0.2*map_length 0.8*map_length], objectNum, 1); %Ŀ��ĳ�ʼ�������
% R_init_w = randi([0.2*map_width 0.8*map_width], objectNum, 1); %Ŀ��ĳ�ʼ�������
% vmin = -15;
% vmax = 15;
% V_init_l = randi([vmin vmax], objectNum, 1); %Ŀ��ĳ�ʼ�����ٶ�
% V_init_w = randi([vmin vmax], objectNum, 1); %Ŀ��ĳ�ʼ�����ٶ�
% amin = -5;
% amax = 5;
% A_init_l = randi([amin amax], objectNum, 1); %Ŀ��ĳ�ʼ������ٶ�
% A_init_w = randi([amin amax], objectNum, 1); %Ŀ��ĳ�ʼ������ٶ�
vmin = -15;
vmax = 15;
amin = -5;
amax = 5;
R_init_l = []; %Ŀ��ĳ�ʼ�������
R_init_w = []; %Ŀ��ĳ�ʼ�������
V_init_l = []; %Ŀ��ĳ�ʼ�����ٶ�
V_init_w = []; %Ŀ��ĳ�ʼ�����ٶ�
A_init_l = []; %Ŀ��ĳ�ʼ������ٶ�
A_init_w = []; %Ŀ��ĳ�ʼ������ٶ�
for i = 1:objectNum
   RL = randi([0.2*map_length 0.8*map_length]); %Ŀ��ĳ�ʼ�������
   RW = randi([0.2*map_width 0.8*map_width]); %Ŀ��ĳ�ʼ�������
   VL = randi([vmin vmax]); %Ŀ��ĳ�ʼ�����ٶ�
   VW = randi([vmin vmax]); %Ŀ��ĳ�ʼ�����ٶ�
   AL = randi([amin amax]); %Ŀ��ĳ�ʼ������ٶ�
   AW = randi([amin amax]); %Ŀ��ĳ�ʼ������ٶ�
   objectSize = randi([2 12])*deltaR; %Ŀ���С
   [R_init_ls, R_init_ws] = getCircleRandomPoints(objectSize, R_init_l, R_init_w, deltaR); %ͬһ����������о�����Ϣ����Ϊ���У�ÿ�зֱ�Ϊ[L W]
   pointNum = size(R_init_ls, 1);%��Ŀ��ĵ㼣��
   R_init_l = [R_init_l; R_init_ls];
   R_init_w = [R_init_w; R_init_ws];
   V_init_l = [V_init_l; ones(pointNum, 1)* VL];
   V_init_w = [V_init_w; ones(pointNum, 1)* VW];
   A_init_l = [A_init_l; ones(pointNum, 1)* AL];
   A_init_w = [A_init_w; ones(pointNum, 1)* AW];
end
end
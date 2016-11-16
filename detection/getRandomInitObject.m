%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%������N��Ŀ������ɸ��㼣
function [R_init_l, R_init_w, V_init_l, V_init_w, A_init_l, A_init_w, objectSizeinfo] = getRandomInitObject(objectNum, map_length, map_width, deltaR, map_l, map_w)
vmin = -6;
vmax = -1;
amin = -2;
amax = 0;
R_init_l = []; %Ŀ��ĳ�ʼ�������
R_init_w = []; %Ŀ��ĳ�ʼ�������
V_init_l = []; %Ŀ��ĳ�ʼ�����ٶ�
V_init_w = []; %Ŀ��ĳ�ʼ�����ٶ�
A_init_l = []; %Ŀ��ĳ�ʼ������ٶ�
A_init_w = []; %Ŀ��ĳ�ʼ������ٶ�
maxIndexL = 0.8*map_length / map_l; %���ȡ��Ŀ��ĺ���������Χ������ȡ���߽�ļ������
minIndexL = 0.2*map_length / map_l;
maxIndexW = 0.8*map_width / map_w;
minIndexW = 0.2*map_width / map_w;
objectSizeinfo = ones(objectNum, 1);
for i = 1:objectNum
   RL = randi([minIndexL maxIndexL])*map_l; %Ŀ��ĳ�ʼ������룬ȡ�˶�ģ�ͷֱ��ʵ���������ȷ����������
   RW = randi([minIndexW maxIndexW])*map_w; %Ŀ��ĳ�ʼ�������
   VL = randi([-6 6]); %Ŀ��ĳ�ʼ�����ٶ�
   VW = randi([vmin vmax]); %Ŀ��ĳ�ʼ�����ٶ�
   AL = randi([amin amax]); %Ŀ��ĳ�ʼ������ٶ�
   AW = randi([amin amax]); %Ŀ��ĳ�ʼ������ٶ�
   objectSize = randi([2 9])*deltaR; %Ŀ���С
   objectSizeinfo(i, 1) = 2*objectSize;
   [R_init_ls, R_init_ws] = getCircleRandomPoints(objectSize, RL, RW, deltaR); %ͬһ����������о�����Ϣ����Ϊ���У�ÿ�зֱ�Ϊ[L W]
   pointNum = size(R_init_ls, 1);%��Ŀ��ĵ㼣��
   R_init_l = [R_init_l; R_init_ls];
   R_init_w = [R_init_w; R_init_ws];
   V_init_l = [V_init_l; ones(pointNum, 1)* VL];
   V_init_w = [V_init_w; ones(pointNum, 1)* VW];
   A_init_l = [A_init_l; ones(pointNum, 1)* AL];
   A_init_w = [A_init_w; ones(pointNum, 1)* AW];
end
end
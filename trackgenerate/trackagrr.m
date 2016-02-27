%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
%������Ŀ���˶�����ģ��
deltat=0.2;
t=0:deltat:3;
%   �����˶�ģ������     %
%[ʵʱ�ٶȣ�ʵʱ���룬ʵʱ�Ƕ�] = mbpara(��ʼ���룬��ʼ�ٶȣ����ٶȣ���ʼ�Ƕȣ��Ƕȱ仯���ٶȣ��Ƕȱ仯��ʼ�ٶȣ�
[v1, R1, sita1] = mbpara(70,-4,-3,50,1,1,t); %һ���������Լ����
[v1_1, R1_1, sita1_1] = obmutipoint(R1,v1,sita1,2, deltat);
[v1_2, R1_2, sita1_2] = obmutipoint(R1,v1,sita1,-2,deltat);

[v2, R2, sita2] = mbpara(130,2,2,90,1,2,t); %һ���������Լ����
[v2_1, R2_1, sita2_1] = obmutipoint(R2,v2,sita2,1,deltat);
[v2_2, R2_2, sita2_2] = obmutipoint(R2,v2,sita2,-1,deltat);

% %      ��ֹ����         %
% R4=72;sita4=50;
% %R2=80;sita2=50;
% %                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
set(gcf,'Position',[100 100 260 220]);
set(gca,'Position',[.13 .17 .80 .74]);  %���� XLABLE��YLABLE���ᱻ�е�
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);

figure
subplot(1,2,1);
polar(sita2/180*pi, R2,'b');
hold on;
polar(sita2_1/180*pi,R2_1,'r');
hold on;
polar(sita2_2/180*pi,R2_2,'g');

hold on;

polar(sita1/180*pi, R1,'b');
hold on;
polar(sita1_1/180*pi,R1_1,'r');
hold on;
polar(sita1_2/180*pi,R1_2,'g');
distanceData = [R1;R1_1;R1_2;R2;R2_1;R2_2];
velocityData = [v1;v1_1;v1_2;v2;v2_1;v2_2];
angleData = [sita1;sita1_1;sita1_2;sita2;sita2_1;sita2_2];
%�㼣�ۺ�
distanceDoor = 4; %������
angleDoor=3; %��λ��
velocityDoor = 2; %�ٶ���
object = cell(1,length(t)); %ÿ��ɨ��ε�Ŀ�����۽��
for n = 1:length(t)
    X=[distanceData(:,n) velocityData(:,n) angleData(:,n)];
    [class, type] = dbscan(X,2,[]);
    clusternum = class(end);%�صĸ���
    objectnum = size(X,1); %����Ŀ��ĸ���
    objectcell=cell(1, clusternum); %��Ÿ����ص�cell��Ԫ
    objectsize = zeros(1, clusternum);%ÿ���ص������ųߴ�
    
    
    %��Ŀ��ֱ�ֵ���Ӧ��cell�ص�Ԫ��
    for i = 1:objectnum
        if(isempty(objectcell{class(i)}))
            objectcell{class(i)} = X(i,:);
        else
            objectcell{class(i)} = [objectcell{class(i)};X(i,:)];
        end    
    end
    %����ÿ���ص�Ŀ���ųߴ磬����k-means����Ŀ������
    for i = 1:clusternum
      dis = objectcell{i}(:,1); %ȡ���еľ���ά
      vel = objectcell{i}(:,2); %ȡ���е��ٶ�ά
      ang = objectcell{i}(:,3); %ȡ���еķ�λά
      objectsize(i) = max(dis)-min(dis);
      
      object{n} = [object{n};mean(dis) mean(vel) mean(ang)];
    end    
end
%�����㼣���ۺ��ͼ
re_dis_1 = [];
re_angle_1 = [];
re_v_1 = [];
re_dis_2 = [];
re_angle_2 = [];
re_v_2 = []
for i = 1:length(t)
    re_dis_1 = [re_dis_1 object{i}(1,1)];
    re_angle_1 = [re_angle_1 object{i}(1,3)];
    re_dis_2 = [re_dis_2 object{i}(2,1)];
    re_angle_2 = [re_angle_2 object{i}(2,3)];
end
subplot(1,2,2);
polar(re_angle_2/180*pi,re_dis_2,'r');
hold on;
polar(re_angle_1/180*pi, re_dis_1,'b');
%������ʼ

%����ά��

%��������
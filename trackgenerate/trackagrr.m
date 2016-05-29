%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
%������Ŀ���˶�����ģ��
deltat=0.2;
t=0:deltat:3;


%   �����˶�ģ������     %

%[ʵʱ�ٶȣ�ʵʱ���룬ʵʱ�Ƕ�] = mbpara(��ʼ���룬��ʼ�ٶȣ����ٶȣ���ʼ�Ƕȣ��Ƕȱ仯���ٶȣ��Ƕȱ仯��ʼ�ٶ�, ɢ����ľ��뷶Χ���ٶȷ�Χ���Ƕȷ�Χ��
objectinfo = [
    140, 0, 3, 98, 2, 2, 1, 2, 2;
    70, -4, -3, 50 ,1, 1, 1, 2, 2;
    130, 2, 2,  90, 1, 2, 2, 2, 2    
    ];

n = size(objectinfo, 1);
[distanceData, velocityData, angleData] = getmultidata(t, objectinfo);
%plot data
for i = 1:3*n
    if(mod(i,3) == 1)
        polar(angleData(i,:)/180*pi, distanceData(i,:), '*');
    elseif mod(i,3) == 2
        polar(angleData(i,:)/180*pi, distanceData(i,:), 'r');
    else
        polar(angleData(i,:)/180*pi, distanceData(i,:), 'g');
    end
    hold on
end

%�㼣�ۺ�
distanceDoor = 4; %������
angleDoor=3; %��λ��
velocityDoor = 2; %�ٶ���
object = cell(1,length(t)); %ÿ��ɨ��ε�Ŀ�����۽��
figure
for n = 1:length(t)
    X=[distanceData(:,n) [velocityData(:,n) angleData(:,n)]];
    [class, type] = dbscan(X,2,5);
    clusternum = class(end);%�صĸ���
    objectnum = size(X,1); %����Ŀ��ĸ���
    objectcell=cell(1, clusternum); %��Ÿ����ص�cell��Ԫ
    objectsize = zeros(1, clusternum);%ÿ���ص������ųߴ�
    %object = cell(1,length(t));


    %��Ŀ��ֱ�ֵ���Ӧ��cell�ص�Ԫ��
    for i = 1:objectnum
        if(isempty(objectcell{class(i)}))
            objectcell{class(i)} = X(i,:);
        else
            objectcell{class(i)} = [objectcell{class(i)};X(i,:)];
        end
    end
    %����ÿ���ص�Ŀ���ųߴ磬����k-means����Ŀ������
    for i = clusternum:-1:1
        dis = objectcell{i}(:,1); %ȡ���еľ���ά
        vel = objectcell{i}(:,2); %ȡ���е��ٶ�ά
        angle = objectcell{i}(:,3);%ȡ���з�λά
        objectsize = max(dis)-min(dis);
        if(isempty(object{n}))
            object{n} = [mean(dis) mean(vel) mean(angle) objectsize];
        else
            object{n} = [object{n};mean(dis) mean(vel) mean(angle) objectsize];
        end
        polar(mean(angle)/180*pi ,mean(dis),'*');
        hold on;
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ objectCell, clusternum ] = handlePoints(points, minPts, distanceWDoor, velocityDoor, type)
%HANDLEPOINTS Summary of this function goes here
% ����һ�������ռ����ĵ㼣���м��д������ص�ǰ���ڵ�������������С���ۺϵ���Ϣ
%pointsΪ���еĵ㼣��Ϣ��minPts��distanceLDoor,
%velocityDoorΪDBSCAN�ۺ��õĲ�����typeΪ���������ͣ�1Ϊ������2ΪС����
global big_beam small_beam
pointsnum = size(points, 1); %���е㼣�ĸ���

%��ʼ�㼣����
if type == 1
    [class, type] = dbscan(points, minPts, sqrt(distanceWDoor^2 + (big_beam/2)^2 + velocityDoor^2));
else
    [class, type] = dbscan(points, minPts, sqrt(distanceWDoor^2 + (small_beam/2)^2 + velocityDoor^2));
end
clusternum = max(class); %�ۺϺ�ص�����
objectCell = cell(1, clusternum);%��Ÿ����ص�cell��Ԫ
%objectSize = zeros(1, clusternum); %��������صĴ�ųߴ磬�û������ĵ㼣����
%��Ŀ�����dbscan������class�����ֱ�ֵ���Ӧ��cell�ص�Ԫ��
for j = 1:pointsnum
    if class(j) ~= -1
        if isempty(objectCell{class(j)})
            objectCell{class(j)} = points(j,:);
        else
            objectCell{class(j)} = [objectCell{class(j)}; points(j,:)];
        end
    end
end
end


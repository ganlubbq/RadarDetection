%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�õ�ĳ�������ڵĻز��źţ�beamPos_l,
%beamPos_w�ֱ�������ĺ���λ�ú�����λ�ã�beam_typeΪ�������ͣ�1Ϊ������2ΪС����
response = 0;
objects = [];
for j = 1:map_width/map_w
    for i = 1:map_length/map_l
        if(map(i, j) ~= 1000)%TODO:���ûز������㷨��ĿǰΪ�˲���
            %fprintf('���۵㼣(%f,%f),�ٶ�Ϊ%f\n', index_l*map_l, index_w*map_w, map(index_l, index_w));
            objects = [objects; j * map_w  map(i, j)];
        end
    end
end
RCS = 10;
if ~isempty(objects)
    allvel = objects(:,2);
    allvel = unique(allvel, 'rows');
    %objectcell = cell(1, length(allvel));
    for i = 1:length(allvel)
        L = objects(:,2) == allvel(i);
        one = objects(L,:);
        %����sweling�ֲ���rcs��ֵ
        rcs = generateRcs(RCS, size(one, 1));
        for j = 1:size(one, 1)
            response = response + getdisg(one(j,1), one(j,2), rcs(j));
        end
    end
end
save('response.mat');
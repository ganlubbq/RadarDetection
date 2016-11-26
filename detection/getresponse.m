%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function response = getresponse(beamPos_l, beamPos_w, beam_type)
%�õ�ĳ�������ڵĻز��źţ�beamPos_l,
%beamPos_w�ֱ�������ĺ���λ�ú�����λ�ã�beam_typeΪ�������ͣ�1Ϊ������2ΪС����
global map_l map_w big_beam small_beam map RL RW VW
response = 0;
if beam_type == 1
    num_l = big_beam / map_l; %�����ں����ж��ٸ��ֱ浥Ԫ
    num_w = big_beam / map_w; %�����������ж��ٸ��ֱ浥Ԫ
else
    num_l = small_beam / map_l; %С�����ں����ж��ٸ��ֱ浥Ԫ
    num_w = small_beam / map_w; %С�����������ж��ٸ��ֱ浥Ԫ
end
objects = [];
for j = 1:num_w
    for i = 1:num_l
        index_l = fix((beamPos_l - 1) * num_l + i);
        index_w = fix((beamPos_w - 1) * num_w + j);
        if(map(index_l, index_w) ~= 1000)%TODO:���ûز������㷨��ĿǰΪ�˲���
            %fprintf('���۵㼣(%f,%f),�ٶ�Ϊ%f\n', index_l*map_l, index_w*map_w, map(index_l, index_w));
            %response = response + getdisg(index_w * map_w, (map(index_l, index_w)));
            objects = [objects; index_w * map_w  map(index_l, index_w)];
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
%for test
% for j = 1:size(map,2)
%     for i = 1:size(map, 1)
%         %index_l = fix((beamPos_l - 1) * num_l + i);
%         %index_w = fix((beamPos_w - 1) * num_w + j);
%         if(map(i, j) ~= 1000)%TODO:���ûز������㷨��ĿǰΪ�˲���
%             fprintf('���۵㼣(%f,%f),�ٶ�Ϊ%f\n', i*map_l, j*map_w, map(i, j));
%             response = response + getdisg(j * map_w, (map(i, j)));
%         end
%     end
% end

end
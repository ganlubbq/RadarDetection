%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%��ָ���뾶�ڣ�����������ɸ�����ĵ�,һ���ֱ�����ֻ����һ����
function [R_init_ls, R_init_ws] = getCircleRandomPoints(objectSize, RL, RW, deltaR)
radius = objectSize; %����İ뾶
R_init_ls = [];
R_init_ws = [];
for i = RL - radius:2*deltaR: RL + radius
    for j = RW - radius:deltaR: RW + radius
        flag = randi([0 1]);
        if flag == 1
            R_init_ls = [R_init_ls; i];
            R_init_ws = [R_init_ws; j];
        end
    end
end
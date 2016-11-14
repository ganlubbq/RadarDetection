%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%
%��ָ���뾶�ڣ�����������ɸ�����ĵ�,һ���ֱ�����ֻ����һ����
function [R_init_ls, R_init_ws] = getCircleRandomPoints(objectSize, R_init_l, R_init_w, deltaR)
radius = objectSize / 2; %����İ뾶
R_init_ls = [];
R_init_ws = [];
for i = R_init_l - radius:deltaR: R_init_l + radius
    for j = R_init_w - radius:deltaR: R_init_w + radius
        flag = randi([0 1]);
        if flag == 1
            R_init_ls = [R_init_ls; i];
            R_init_ws = [R_init_ws; j];
        end
    end
end
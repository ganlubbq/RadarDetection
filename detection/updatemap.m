%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function updatemap(index)
%�ı������map��ӳ���λ��
%����ȫ�ֱ���
global map VW RL RW map_l map_w  map_length map_width outOfRange R_pre_lmp R_pre_wmp points_num;
[x,y]=size(map);
x_t=0:x;
y_t=0:y;
for objectindex = 1:points_num
    map(R_pre_lmp(objectindex),R_pre_wmp(objectindex))=0;%����һʱ�̵�λ�ò���
    if(outOfRange(objectindex) == 0)
        if(RL(objectindex,index)<=map_length && RW(objectindex,index) <= map_width && RL(objectindex,index)> 0 && RW(objectindex,index) > 0 )
            RL_nmp=find(x_t<=RL(objectindex,index)/map_l, 1, 'last' );%��һʱ������ĺ��������map�е�����
            RW_nmp=find(y_t<=RW(objectindex,index)/map_w, 1, 'last' );%��һʱ����������������map�е�����
            map(RL_nmp,RW_nmp) = VW(objectindex,index);%д����λ��
            R_pre_lmp(objectindex) = RL_nmp;%����pre����
            R_pre_wmp(objectindex) = RW_nmp;
        else
            outOfRange(objectindex) = 1;
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function response = getresponse( map,map_x,map_y,angle,M,T,fs,B,f0)
%���ݶ�άmap����õ����лز�֮��,map_x������ֱ浥Ԫ��map_y�Ƕ���ֱ浥Ԫ,map�����б������������ٶȣ��������),angleΪ��ǰɨ��Ƕ�
distance=size(map,1);
response=0; %�ز�����
%ƥ��Ƕȵ�һ��С����
if(mod(angle,map_y))
   start=angle-mod(angle,map_y)+1;
else
    start=angle-map_y;
end
for i=1:distance
    for j=start:start+map_y-1
        if(map(i,j)>=0)
            response=response + getdisg(i*map_x, map(i,j),B,f0,T,fs,M);            
        end
    end
end

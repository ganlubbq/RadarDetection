%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [map,R_pre,sita_pre] = updatemap(map,R,R_pre,sita,sita_pre,v)
%�ı������map��ӳ���λ��,R_pre,sita_preΪǰһʱ�������λ�úͽǶȣ�p,sitaΪ�˿������Ӧ��λ�úͽǶ�
[x,y]=size(map);
x_t=1:x;
y_t=1:y;
map(R_pre,sita_pre)=-1;
R=find(x_t<=R, 1, 'last' );
sita=find(y_t<=sita, 1, 'last' );
map(R,sita)=v;
R_pre=R;
sita_pre=sita;
end
function [map,p_pre,sita_pre] = movemap(map,p,p_pre,sita,sita_pre,map_x,v)
%�ı������map��ӳ���λ��,p_pre,sita_preΪǰһʱ�������λ�ã�p,sitaΪ�˿������Ӧ��λ��
[x,y]=size(map);
x_t=1:x;
y_t=1:y;
map(p_pre,sita_pre)=-1;
p=max(find(x_t<=p));
sita=max(find(y_t<=sita));
map(p,sita)=v;
p_pre=p;
sita_pre=sita;
end
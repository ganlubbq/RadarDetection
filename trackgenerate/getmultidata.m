%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function [ R, V,  SITA] = getmultidata(t, objectinfo)
%objectinfoΪ��������������Ϣ�ľ���һ��Ϊһ�����壬�ֱ��г�ʼ���룬��ʼ�ٶȣ����ٶȣ���ʼ�Ƕȣ��Ƕȱ仯���ٶȣ��Ƕȱ仯��ʼ�ٶȵ���Ϣ��
%֮��Ϊÿ��������Χ����N��ɢ����Ŀ�꣬ģ����ɢ��㣬����������е��ʵʱ���롢�ٶȡ���λ��Ϣ
originobnum = size(objectinfo, 1); %ԭʼĿ����Ŀ
n = length(t);
V = zeros(3*originobnum, n);
R = zeros(3*originobnum, n);
SITA = zeros(3*originobnum, n);
obcount = 1;
for i=1:originobnum
    Ri = objectinfo(i,1);
    Vi = objectinfo(i,2);
    ai = objectinfo(i,3);
    Sitai = objectinfo(i,4);
    Sita_ai = objectinfo(i,5);
    Sita_v0i = objectinfo(i,6);
    deltaRi = objectinfo(i,7);
    deltaVi = objectinfo(i,8);
    deltaSitai = objectinfo(i,9);
    [V(obcount:obcount+2, :), R(obcount:obcount+2, :), SITA(obcount:obcount+2, :)] = mbpara(Ri, Vi, ai, Sitai, Sita_ai, Sita_v0i, t, deltaRi, deltaVi, deltaSitai);
    obcount = obcount + 3;
end 
end  


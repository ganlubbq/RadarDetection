%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function getsepretetrack(track_normal)
%������ʽ�켣��cell���ϻ������������켣
tracknum = length(track_normal);%�����켣��
for i = 1:tracknum
   figure;
   track = track_normal{i};%��ȡһ���켣 
   distance = track(:,1);%��ȡ�ù켣�ľ���ά
   fangwei = track(:,3);%��ȡ��λά
   polar(fangwei/180*pi, distance, 'r');
end
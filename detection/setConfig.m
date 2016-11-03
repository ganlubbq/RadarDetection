%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

%%
clear
clc
if exist('simuConfig.mat')
delete simuConfig.mat
end
c=3e8;
%�������״�ϵͳ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=80e-6; %������ɨƵ����
f0=20e9; %��Ƶ��ʼƵ��
B=500e6; %�������Ƶ����
deltaR=c/(2*B); %��ά�任��ľ���ֱ���
deltaV=2; %��ά�任���ٶ�ά�ֱ���
%%%%%%%%%ȷ���ֱ���%%%%%%%%%%%%%%
Rmax=300; %��������
Fs=4*B*Rmax/(T*c); %��Ƶ�źŲ�����
N=round(Fs*T); %����ά��������
M=fix(c/(deltaV*2*T*f0)); %�ٶ�ά��������
Vmax=M*deltaV;  %���ģ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%����������ز���
T1 = M*T; %������פ��ʱ�䣬�����л�ʱ�䲻����
big_beam = 8; %�����������α߳�
small_beam = 1; %С���������α߳�
allow_T = 1.5; %����ɨ��ʱȫ�����̿հ�ʱ��(s)
time_num = 30;%����ʱɨ������̽������Ĵ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%����ģ�����
map_l = 0.1;%�˶�ģ�͵ķֱ���
map_w = 0.1;
map_length = 160;%̽�����򳤶�
map_width = 80;%̽��������
map=zeros(map_length/map_l, map_width/map_w); %��ʼmap���飬��ʼ��Ϊ0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%�˶������趨
objectNum = 2;
%R_init_l = []; %Ŀ��ĳ�ʼ�������
%R_init_w = []; %Ŀ��ĳ�ʼ�������
%V_init_l = []; %Ŀ��ĳ�ʼ�����ٶ�
%V_init_w = []; %Ŀ��ĳ�ʼ�����ٶ�
%A_init_l = []; %Ŀ��ĳ�ʼ������ٶ�
%A_init_w = []; %Ŀ��ĳ�ʼ������ٶ�
[R_init_l, R_init_w, V_init_l, V_init_w, A_init_l, A_init_w] = getRandomInitObject(objectNum, map_length, map_width); %��ȡ����ķ�ʽȷ�����ϲ���
%%%%%��ʼĿ����map�еı�ʾ%%%%%
for index = 1:objectNum    
      map(fix(R_init_l(index)/map_l), fix(R_init_w(index)/map_w)) = abs(V_init_w(index));   
end
R_pre_lmp = R_init_l/map_l; %��Ӧǰһʱ�̵ĺ�������map����
R_pre_wmp = R_init_w/map_w; %��Ӧǰһʱ�̵���������map����

save simuConfig.mat
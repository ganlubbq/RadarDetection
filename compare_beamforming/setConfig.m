%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

%%
clear
close all
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
Rmax=90; %���������
Fs=4*B*Rmax/(T*c); %��Ƶ�źŲ�����
N=round(Fs*T); %����ά��������
M=fix(c/(deltaV*2*T*f0)); %�ٶ�ά��������
Vmax=M*deltaV;  %���ģ������
RCS = 10; %Ŀ��rcsֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%����������ز���
T1 = M*T; %������פ��ʱ�䣬�����л�ʱ�䲻����
big_beam = 9; %�����������α߳�
small_beam = 3; %С���������α߳�
allow_T = 1.5; %����ɨ��ʱȫ�����̿հ�ʱ��(s)
time_num = 40;%����ʱɨ������̽������Ĵ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%����ģ�����
map_l = 0.3;%�˶�ģ�͵ķֱ���
map_w = 0.3;
map_length = 90;%̽�����򳤶�
map_width = 60;%̽���������
map=ones(map_length/map_l, map_width/map_w)*1000; %��ʼmap���飬��ʼ��Ϊ1000,һ�������ܴﵽ���ٶȣ����map��λ�ó���Ϊ1000����ʾ�õط�û��Ŀ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%�˶������趨
objectNum = 1;
%R_init_l = []; %Ŀ��ĳ�ʼ�������
%R_init_w = []; %Ŀ��ĳ�ʼ�������
%V_init_l = []; %Ŀ��ĳ�ʼ�����ٶ�
%V_init_w = []; %Ŀ��ĳ�ʼ�����ٶ�
%A_init_l = []; %Ŀ��ĳ�ʼ������ٶ�
%A_init_w = []; %Ŀ��ĳ�ʼ������ٶ�
[R_init_l, R_init_w, V_init_l, V_init_w, A_init_l, A_init_w, objectSizeinfo] = getRandomInitObject(objectNum, map_length, map_width, deltaR, map_l, map_w); %��ȡ����ķ�ʽȷ�����ϲ���
figure
plot(R_init_l, R_init_w, '*');
axis([0 map_length 0 map_width]);
%%%%%��ʼĿ����map�еı�ʾ%%%%%
points_num = size(R_init_l, 1); %���е㼣������
for index = 1:points_num    
      map(fix(R_init_l(index)/map_l), fix(R_init_w(index)/map_w)) = V_init_w(index);   
end
R_pre_lmp = fix(R_init_l/map_l); %��Ӧǰһʱ�̵ĺ�������map����
R_pre_wmp = fix(R_init_w/map_w); %��Ӧǰһʱ�̵���������map����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%�㼣�ۺ��������ز���
distanceWDoor = deltaR; %�������������Ϊ�����ľ���ֱ���
%distanceLDoor=2*small_beam; %���������Ĭ��ΪС�����ֱ��ʵ���������ʹ�ô���ɨ��ʱӦ���ĳɴ����߳�������
velocityDoor = 1; %�ٶ���
minPts = 4; %number of objects in a neighborhood of an object
parameterWeight = [0.2 0.4 0.4];%����ŷ�����ʱ��Ȩ�أ��ֱ��Ӧ[������� ������� �����ٶ�]
%Ŀ�������ز���
trackObjectNum = 3; %����ģʽ�¿��Ը��ٵ����Ŀ������
%Ŀ��Ԥ����ز���
continuousCount = 3; %Ŀ�������������ڿ����״��Ԥ��
%С��������ɨ���������ڵ����������������������Ҫ�����ô���ɨ���������ȷ���������򲻻����©��
smallScanningNum = fix(allow_T/(objectNum*(6+big_beam/small_beam*7)*T1));
maxPointsNum = 1000; %һ�������趨�ĵ㼣�������ޣ�̽�⵽�ĵ㼣�����������ֱ��Ԥ�������п���ֱ�ӷ�������ʯ��
maxObjectSize = 10;%����ۺϺ�����������������������ޣ���ֱ��Ԥ��
minObjectSize = 1;%С��������޵��������Ϊû����в��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%���龯��ز���
alpha = 0.5;%s-cfar����
beta = 22.5;%s-cfar����
scfar_r = 3;%����Ŀ��ĸ���
KVI = 4.56; %svi-cfar�����жϾ����Բ���
KMR = 2.9; %svi-cfar�����жϾ����Բ���
CFAR_N_l = 16;%����ο�������
CFAR_N_w = 8;%����ο�������
window_r = 1;%ѡ��ο���ʱ�����Ŀ����
pfa_d = 1e-6;
pfa_v = 1e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save simuConfig.mat
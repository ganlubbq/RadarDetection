%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

%̽��ϵͳ��Ҫ�����·�������޳�������Ϊ3���࣬��һ���ǹ������ţ��ڶ����ǹ������жΣ���������������������߿ڱ�����ʯ
%ϵͳ����ֻ��Ϊ����һ��
clear all;
close all; 
clc;
warning off;
c=3e8;
type=3;
%%%%%%%%%%%%%�������״�ϵͳ����%%%%%%%%%%%%%%%%%%%
T=80e-6; %������ɨƵ����
f0=20e9; %��Ƶ��ʼƵ��
B=500e6; %�������Ƶ����
deltaR=c/(2*B); %��ά�任��ľ���ֱ���
deltaV=2; %��ά�任���ٶ�ά�ֱ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ų���
if type == 1
   % roadrailcross(T,N,f0,B,deltaR);
end
%�������жγ���
if type == 2
   % roadrailparal(T,N,f0,B,deltaR);
end
 
%������������߿ڱ�����ʯ����
if type == 3
    [search_result,track_head,track_temp,track_normal] =fallstone(T,f0,B,deltaR,deltaV);    
end
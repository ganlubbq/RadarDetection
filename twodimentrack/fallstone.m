%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%铁道隧道或沿线口崩塌落石场景%%%%%%%%%%
function [search_result,track_head,track_temp,track_normal] = fallstone(T,f0,B,deltaR, deltaV)
c=3e8;
%%%%%%%%%确定分辨率%%%%%%%%%%%%%%
Rmax=300; %最大处理距离
Fs=4*B*Rmax/(T*c); %差频信号采样率
N=round(Fs*T); %距离维采样点数
M=fix(c/(deltaV*2*T*f0)); %速度维采样点数
Vmax=M*deltaV;  %最大不模糊速度
%%%%%%%%%%设置参数%%%%%%%%%%%%%%%%%%%%%%%
angle=3; %方位向波束角度
T1=M*T; %单波束驻留时间
scan_angle=30:angle:150; %波束扫描角度范围
TT=T1*length(scan_angle); %扫描覆盖区域一周期时间
t=0:T1 :25*TT; %设置扫描时间为10周期

%%%%%%%%%%%%%%%初始化map图%%%%%%%%%%%%%%%%%
map=ones(fix(Rmax/0.1), 180)*(-1); %map图距离维最小单元为0.1m，角度维最小距离为1度
%%%%%%%%%%%%%%%%%%%%%%%%%%
%   物体1运动模型设置     %
R0=70; %初始距离
v0=-4; %初始速度,接近雷达方向为正
a=-2; %加速度

sita0=50;%初始角度
sita_a=0;%角度变化加速度
sita_v0=8;%角度变化初始速度

v=v0+a.*t;
R=R0-(v0.*t + 0.5*a.*t.^2);
sita=sita0 + sita_v0.*t + 0.5*sita_a.*t.^2;

%   物体2运动模型设置     %
RR0=64; %初始距离
vv0=-10; %初始速度,接近雷达方向为正
aa=-2; %加速度

ssita0=60;%初始角度
ssita_a=0;%角度变化加速度
ssita_v=-2;%角度变化初始速度

vv=vv0+aa.*t;
RR=RR0-(vv0.*t + 0.5*aa.*t.^2);
ssita=ssita0 + ssita_v.*t + 0.5*ssita_a.*t.^2;

%      静止物体         %
R1=72;sita1=50;
%R2=80;sita2=50;
%                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%
map(fix(R0/0.1), sita0)=abs(v0);
map(fix(RR0/0.1), ssita0)=abs(vv0);

map(fix(R1/0.1), sita1)=0;
%map(fix(R2/0.1), sita2)=0;

R_pre=fix(R0/0.1); %map更新时对应的上一时刻的值
sita_pre=sita0;

RR_pre=fix(RR0/0.1);
ssita_pre=ssita0;
%%%%%%%%%%%%%%轨迹相关设置%%%%%%%%%%%%%%%%%
track_head = []; %运动轨迹头，分为3列，分别是距离，速度，方位，初始为空
track_temp = {}; %临时运动轨迹cell集合，每个临时轨迹为一个矩阵，包含小于5个点的轨迹，每个点的结构同轨迹头
track_normal = {};%正式轨迹集合，每个轨迹为一个矩阵，包含多于5个点的轨迹
%%%%%%%%%%%%%扫描map得到回波并处理%%%%%%%%%%%%%
search_sita=30;
search_result = {}; %所有波束扫描的动目标集合，每个波束的结果为一个cell单元
%添加杂波信号
za=zeros(M,N);
for k=1:M
    za(k,:)=wbfb(1.5,2.2);
end
tolerance = 2;%容忍目标跟丢的周期数
tolerance_count=0;
for i=1:length(t)
    %实时更新map
    [map, R_pre, sita_pre] = updatemap(map, R(i)/0.1, R_pre, sita(i), sita_pre, abs(v(i)));%更新第一个物体
    [map, RR_pre, ssita_pre] = updatemap(map, RR(i)/0.1, RR_pre, ssita(i), ssita_pre, abs(vv(i)));%更新第二个物体
    %获得回波差频信号
    response=getresponse(map,0.1,angle,search_sita,M,T,Fs,B,f0);
    
    if response
        %添加噪声与杂波
        SNR=1; %热噪声信噪比
        response = awgn(response, SNR);
        
        response = response + (za);
        
        %%%%%%%%%%对差频信号进行二维fft变换%%%%%%%%%
        data = after2fft(response, N, Fs, T, B, f0); %二维变换后的矩阵
        data=abs(data);
        %去除低频率的杂波与静止物体
        %         for i=1:N
        %             data(1,i)=data(2,i);
        %         end
        data = data(2:M, :);
        
        %%%%%%%%%%%%%CFAR处理%%%%%%%%%%%%%%%
        ones_result = cfarhandled(data,search_sita,deltaR, deltaV);
        %扫描结果第四列加上时间戳
        
        ones_result = [ones_result ones(size(ones_result,1),1)*t(i)];
        
        %单波束结果聚合操作
        %todo
        search_result = [search_result ones_result];
        %         x_distance=(linspace(0,Fs*(N-1)/N,N));
        %         y_velocity=linspace(0, 1/T*(M-1)/M, M);
        %         meshx=x_distance(1:N/2)*c/(2*B/T);
        %         figure;
        %         mesh(meshx,c*y_velocity/(2*f0),hasObject);
        %         title('恒虚警检测结果');
        %         xlabel('distance/m');
        %         ylabel('velocity/(m/s)');
        
        %%%%%%%%%%轨迹处理%%%%%%%%%%%
        %当一屏目标数据来临后，轨迹处理的优先顺序：1.轨迹维持 2.创建轨迹 3.创建临时轨迹 4.创建轨迹头
        
        if (~isempty(track_normal))
            if(~isempty(ones_result))
                %轨迹维持，取正式轨迹的后三个点进行预测与误差限定
                [track_normal, ones_result] = maintain_formaltrack(track_normal, ones_result, TT, t(i));
            end
            %如果点迹经过轨迹维持后没有了，则清空临时轨迹和轨迹头
            if(isempty(ones_result))
                track_temp = {};
                track_head = [];
            end
        end
        
        if(~isempty(track_temp))
            if(~isempty(ones_result))
                %创建正式轨迹
                [track_temp, track_normal, ones_result] = create_formaltrack(track_temp, track_normal, ones_result, TT,t(i));
            end
            %如果点迹经过创建轨迹后没有了，则清空轨迹头
            if(isempty(ones_result))
                track_head = [];
            end
        end
        
        if(~isempty(track_head))
            if(~isempty(ones_result))
                %创建临时轨迹
                [track_temp, track_head, ones_result] = create_temptrack(track_temp, track_head, ones_result, TT);
            end
        end
        
        if(~isempty(ones_result))
            %创建轨迹头
            track_head = [track_head; ones_result];
        end
    end
    %%%%%%%%波束方位角%%%%%%%%%%
    disp('当前波束扫描角度为：');
    search_sita = search_sita + angle %波束指向下一个方位
    if(search_sita > 150)
        search_sita = 30;
    end
    
end
getsepretetrack(track_normal);
end
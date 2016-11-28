%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hasObject, objects_l, objects_w, objects_v] = BeamFindObject(beamPos_l, beamPos_w, beam_type)
%�жϲ������ڷ�λ����Ŀ�꣬beamPos_l���������λ�ã�beamPos_w���������λ�ã�beam_type���������ͣ�1Ϊ������2ΪС����
global M N big_beam small_beam map_l map_w map Fs T c B f0
hasObject = 0;
if beam_type == 1
    num_l = big_beam / map_l; %�����ں����ж��ٸ��ֱ浥Ԫ
    num_w = big_beam / map_w; %�����������ж��ٸ��ֱ浥Ԫ
else
    num_l = small_beam / map_l; %С�����ں����ж��ٸ��ֱ浥Ԫ
    num_w = small_beam / map_w; %С�����������ж��ٸ��ֱ浥Ԫ
end
objects_l = []; %����������������ĺ����꣬ÿ�д���һ������
objects_w = []; %����������������������꣬ÿ�д���һ������
objects_v = []; %������������������ٶȣ�ÿ�д���һ������
% for j = 1:num_w
%     for i = 1:num_l
%         index_l = fix((beamPos_l - 1) * num_l + i);
%         index_w = fix((beamPos_w - 1) * num_w + j);
%         if(map(index_l, index_w) ~= 1000)%TODO:���ûز������㷨��ĿǰΪ�˲���
%             hasObject = 1;
%             if beam_type == 1
%                 objects_l = [objects_l;(beamPos_l - 1) *  big_beam + 0.5 * big_beam];
%             else
%                 objects_l = [objects_l;(beamPos_l - 1) *  small_beam + 0.5 * small_beam];
%             end
%             objects_w = [objects_w; index_w * map_w];
%             objects_v = [objects_v; map(index_l, index_w)];
%         end
%     end
% end
response = getresponse(beamPos_l, beamPos_w, beam_type);
if response
    %�����������Ӳ�
    SNR=1; %�����������
    response = awgn(response, SNR);
    %�����Ӳ��ź�
    za=zeros(M,N);
    for k=1:M
        za(k,:)=wbfb(1.5,2.2);
    end
    response = response + (za);
    %%%%%%%%%%�Բ�Ƶ�źŽ��ж�άfft�任%%%%%%%%%
    data = after2fft(response); %��ά�任��ľ���
    data=abs(data);
    %ȥ����Ƶ�ʵ��Ӳ��뾲ֹ����
    for p=1:N
        data(1,p)=data(2,p);
    end
    % save('mapdata.mat','data');
    % test plot
%     x_distance=(linspace(0,Fs,N));
%     y_velocity=linspace(0, 1/T, M);
%     meshx=x_distance(1:N/2)*c/(2*B/T);
%     figure(4);
%     mesh(meshx,c*y_velocity/(2*f0),data(:,1:N/2));
%     title('��Ƶ�źŶ�άƵ�׷���ͼ');
%     xlabel('distance/m');
%     ylabel('velocity/(m/s)');
    
    %%%%%%%%%%%%%CFAR����%%%%%%%%%%%%%%%
    [hasObject, objects] = cfarhandled(data,beamPos_l, beamPos_w, beam_type);
    if ~isempty(objects)
        objects_l = objects(:, 1);
        objects_w = objects(:, 2);
        objects_v = objects(:, 3);
    end
end
end
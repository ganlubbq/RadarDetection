%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li %%%
%%%%%%%%%%%%%%%%%%%%%%%

function point = threePredict(point1, point2, point3, t)
%���������״̬��Ϣ���е��������Ԥ��,ÿ����Ϊһ�����������ֱ�Ϊ���룬�ٶȣ���λ��ʱ��,ʹ�ð���-����-٤���˲�������Ԥ��
%�˲�������
alpha = 0.271;
beta=0.0285;
gamma=0.0005;

Rs2 = point2(1); %�Եڶ���ľ������
Fs2 = point2(3); %�Եڶ���ķ�λ����
T1=point2(4)-point1(4); %����֮���ʱ���
Fvs2 = (point2(3) - point1(3))/T1; %�Եڶ���ķ�λ�仯�ٶȹ���
Vs2 = (point2(1) - point1(1))/T1; %�Եڶ�����ٶȹ���
As2 = (point2(2) - point1(2))/T1;%�Եڶ���ļ��ٶȹ���
%��ʱ�̶Ա�ʱ��Ԥ�������
T2=point3(4)-point2(4);
Rp3 = Rs2 + T2 * Vs2 + T2*T2/2*As2; %�Ե���������Ԥ��
Vp3 = Vs2+As2*T2; %�Ե������ٶȵ�Ԥ��
Ap3= As2;%�Ե�������ٶȵ�Ԥ��
Fp3 = Fs2 + T2*Fvs2;

%�˲�
Rs3 = Rp3 + alpha*(point3(1) - Rp3);
Vs3 = Vp3 + beta/T2*(point3(1) - Rp3);
As3 = Ap3 + 2*r/(T2*T2)*(point3(1) - Rp3);
Fs3 = Fp3 + alpha*(point3(3) - Fp3);
Fvs3 = (point3(3)-point2(3))/T2;

%�Ե��ĵ��Ԥ��
T3 = t - point3(4);
Rp4 = Rs3 + Vs3*T3 + As3*(T3*T3/2);
Vp4 = Vs3 + As3*T3;
Ap4 = As3;
Fp4 = Fs3 + Fvs3*T3;

point = [Rp4 Vp4 Fp4 t];
end
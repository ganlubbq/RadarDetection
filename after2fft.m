function fft2 =after2fft(response,N,fs,T,B,f0)
%���ض�άfft�任��ľ���
c=3e8;
M=size(response,1); %��������
fft1=zeros(M,N);
fft2=zeros(M,N);


%һάfft�任
for k=1:M
  fft1(k,:)=fft(response(k,:),N);
end

%��άfff�任
for i=1:N
    fft2(:,i) = fft(fft1(:,i),M);
end
% x_distance=(linspace(0,fs*(N-1)/N,N));
% y_velocity=linspace(0, 1/T*(M-1)/M, M);
% meshx=x_distance(1:N/2)*c/(2*B/T);
% mesh(meshx,c*y_velocity/(2*f0),(abs(fft2(:,1:N/2))));
% title('��Ƶ�źŶ�άƵ�׷���ͼ');
% xlabel('distance/m');
% ylabel('velocity/(m/s)');
end

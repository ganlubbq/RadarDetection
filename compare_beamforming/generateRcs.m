%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Author: Chao Li                 %%%
%%% Email: jonathan.swjtu@gmail.com %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͨ�����任������Serliing I�ͽ����RCS
function rcs = generateRcs(RCS, len)
x = rand(1, len);
rcs = -RCS*log(x)/log(exp(1));
end
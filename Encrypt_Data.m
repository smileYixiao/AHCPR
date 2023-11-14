function [Encrypt_D] = Encrypt_Data(D,Data_key)
% 函数说明：对原始秘密信息D进行bit级异或加密
% 输入：D（原始秘密信息）,Data_key（数据加密密钥）
% 输出：Encrypt_D（加密的秘密信息）
num_D = length(D);
Encrypt_D = D;

rand('seed',Data_key);
E = round(rand(1,num_D)*1);
for i=1:num_D  
    Encrypt_D(i) = bitxor(D(i),E(i));
end
end
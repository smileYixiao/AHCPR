function [Encrypt_D] = Encrypt_Data(D,Data_key)
% ����˵������ԭʼ������ϢD����bit��������
% ���룺D��ԭʼ������Ϣ��,Data_key�����ݼ�����Կ��
% �����Encrypt_D�����ܵ�������Ϣ��
num_D = length(D);
Encrypt_D = D;

rand('seed',Data_key);
E = round(rand(1,num_D)*1);
for i=1:num_D  
    Encrypt_D(i) = bitxor(D(i),E(i));
end
end
function [encrypt_I] = Encrypt_Image(origin_I,Image_key)
% ����˵������ͼ��origin_I����bit��������
% ���룺origin_I��ԭʼͼ��,Image_key��ͼ�������Կ��
% �����encrypt_I������ͼ��
[row,col] = size(origin_I);
encrypt_I = origin_I;

rand('seed',Image_key);
E = round(rand(row,col)*255); 
for i=1:row
    for j=1:col
        encrypt_I(i,j) = bitxor(origin_I(i,j),E(i,j));
    end
end
end
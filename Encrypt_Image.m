function [encrypt_I] = Encrypt_Image(origin_I,Image_key)
% 函数说明：对图像origin_I进行bit级异或加密
% 输入：origin_I（原始图像）,Image_key（图像加密密钥）
% 输出：encrypt_I（加密图像）
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
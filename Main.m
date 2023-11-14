clear
clc
I = imread('test_image\Lena.tiff');
origin_I = double(I); 
%% Secret data
num = 10000000;
rand('seed',0);
D = round(rand(1,num)*1);
%% Secret key
Image_key = 1; 
Data_key = 2;
%% Parameter
ref_x = 1;
ref_y = 1;
%% Image encryption
[encrypt_I] = owner(origin_I,Image_key,ref_x,ref_y);
%% Data embedding
[stego_I]=hider(encrypt_I,D,Data_key);
%% Data Extraction
[exD]=receiver1(stego_I,Data_key);
%% Image recovery
[recover_I]=receiver2(stego_I,Image_key);
%---------------Judgment of results----------------%
if  length(exD)>length(D)
    check1 = isequal(D,exD(1:length(D)));
    num_emD=length(D);
else
    check1 = isequal(D(1:length(exD)),exD);
    num_emD=length(exD);
end
[m,n] = size(origin_I);
check2 = isequal(origin_I,recover_I);
if check1 == 1
    disp('提取数据与嵌入数据完全相同！')
else
    disp('Warning！数据提取错误！')
end
if check2 == 1
    disp('重构图像与原始图像完全相同！')
else
    disp('Warning！图像重构错误！')
end
%---------------Result output----------------%
if check1 == 1 && check2 == 1
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    fprintf(['该测试图像------------ OK','\n\n']);
else
    fprintf(['该测试图像------------ ERROR','\n\n']);
end

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
    disp('��ȡ������Ƕ��������ȫ��ͬ��')
else
    disp('Warning��������ȡ����')
end
if check2 == 1
    disp('�ع�ͼ����ԭʼͼ����ȫ��ͬ��')
else
    disp('Warning��ͼ���ع�����')
end
%---------------Result output----------------%
if check1 == 1 && check2 == 1
    disp(['Embedding capacity equal to : ' num2str(num_emD)])
    fprintf(['�ò���ͼ��------------ OK','\n\n']);
else
    fprintf(['�ò���ͼ��------------ ERROR','\n\n']);
end

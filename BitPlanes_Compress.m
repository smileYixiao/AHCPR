function [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix)
% ����˵����ѹ��λƽ�����Plane
% ���룺Plane��λƽ�����,Block_size���ֿ��С��,L_fix���������������
% �����CBS��λƽ��ѹ����������,type��λƽ�������з�ʽ��

%% ��λƽ�������в�����ѹ��������4�������з�ʽ��
BS_comp = cell(0);
for t=0:3 
    %----------------����BMPR�㷨������λƽ��----------------%
    [origin_bits] = BitPlanes_Rearrange(Plane,Block_size,t);
    %----------------ѹ��������λƽ��ı�����----------------%
%     origin_bits=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    [compress_bits] = BitStream_Compress(origin_bits,L_fix);
    BS_comp{t+1} = compress_bits;
end

len = Inf;
for t=0:3 
    bit_stream = BS_comp{t+1};
    num = length(bit_stream);
    if num < len
        CBS = bit_stream; 
        type = t;
        len = num;    
    end 
end
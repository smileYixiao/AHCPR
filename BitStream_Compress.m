function [compress_bits] = BitStream_Compress(origin_bits,L_fix)
% ����˵����ѹ��������
% ���룺origin_bits��ԭʼ��������,L_fix���������������
% �����compress_bits��ѹ����������

len_bits = length(origin_bits);
ori_t = 0; 
compress_bits = zeros(); 
comp_t = 0;
while ori_t<len_bits 
    bit = origin_bits(ori_t+1);
    L = 0; 
    comp_L = zeros(); 
    %---------------------------ͳ����ͬ���صĸ���--------------------------%
    for i=ori_t+1:len_bits 
        if origin_bits(i) == bit
            L = L+1;
        else
            break;
        end
    end
    %--------------------------��ͬ����������С��4--------------------------%
    if L<4
        comp_L(1) = 0; 
        if ori_t+L_fix<=len_bits
            comp_L(2:L_fix+1) = origin_bits(ori_t+1:ori_t+L_fix);
            L = L_fix;
        else
            re = len_bits - ori_t;
            comp_L(2:re+1) = origin_bits(ori_t+1:ori_t+re);
            L = re;
        end
    %------------------------��ͬ���������ȴ��ڵ���4------------------------%
    else %L>=4
        L_pre = floor(log2(L));
        for i=1:L_pre-1
            comp_L(i) = 1;
        end
        comp_L(L_pre) = 0;
        l = L-2^(L_pre);
        bin_l = dec2bin(l)-'0'; 
        len_l = length(bin_l);
        comp_L(2*L_pre-len_l+1:2*L_pre) = bin_l; 
        comp_L(2*L_pre+1) = bit;
    end
    %-------------------------��¼ѹ������ͬ������--------------------------%
    len_L = length(comp_L);
    compress_bits(comp_t+1:comp_t+len_L) = comp_L;
    comp_t = comp_t + len_L;
    ori_t = ori_t + L;
end


function [origin_bits] = BitStream_DeCompress(compress_bits,L_fix)
% 函数说明：解压缩比特流
% 输入：compress_bits（压缩比特流）,L_fix（定长编码参数）
% 输出：origin_bits（原始比特流）

len_bits = length(compress_bits);
comp_t = 0;
origin_bits = zeros();
ori_t = 0;
while comp_t<len_bits 
    label = compress_bits(comp_t+1);
    %-------------------表示接下来的一段比特流是压缩比特流-------------------%
    if label==1 
        L_pre = 0;
        for i=comp_t+1:len_bits
            if compress_bits(i) == 1
                L_pre = L_pre+1;
            else
                L_pre = L_pre+1;
                break;
            end
        end
        comp_t = comp_t + L_pre;
        l_bits = compress_bits(comp_t+1:comp_t+L_pre);
        comp_t = comp_t + L_pre; 
        [l] = Binary_Decimalism(l_bits);
        L = 2^L_pre + l;
        bit = compress_bits(comp_t+1); 
        comp_t = comp_t + 1;
        for i=1:L
            ori_t = ori_t+1;
            origin_bits(ori_t) = bit;
        end
    %----------------表示接下来的一段比特流是直接截取的比特流----------------%
    elseif label==0
        if comp_t+L_fix+1<=len_bits
            comp_t = comp_t + 1; 
            origin_bits(ori_t+1:ori_t+L_fix) = compress_bits(comp_t+1:comp_t+L_fix);
            ori_t = ori_t + L_fix;
            comp_t = comp_t + L_fix;
        else
            comp_t = comp_t + 1;
            re = len_bits - comp_t;
            origin_bits(ori_t+1:ori_t+re) = compress_bits(comp_t+1:comp_t+re);
            ori_t = ori_t + re;
            comp_t = comp_t + re;
        end
    end
end

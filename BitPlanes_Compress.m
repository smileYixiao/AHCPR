function [CBS,type] = BitPlanes_Compress(Plane,Block_size,L_fix)
% 函数说明：压缩位平面矩阵Plane
% 输入：Plane（位平面矩阵）,Block_size（分块大小）,L_fix（定长编码参数）
% 输出：CBS（位平面压缩比特流）,type（位平面重排列方式）

%% 将位平面重排列并进行压缩（共有4种重排列方式）
BS_comp = cell(0);
for t=0:3 
    %----------------根据BMPR算法重排列位平面----------------%
    [origin_bits] = BitPlanes_Rearrange(Plane,Block_size,t);
    %----------------压缩重排列位平面的比特流----------------%
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
function [value,this_end] = Huffman_DeCode(Binary,last_end,Code_Bin,seq,len)
m = last_end+1;
for i=1:length(len)
    if len(i) ~= 0
        len_I(1,i) = len(1,i);
    end
end
t = length(Code_Bin);
l = length(len_I);
for i=1:l
    code = Code_Bin(t-len_I(1,l-i+1)+1:t);
    if isequal(code,Binary(m:m+len_I(1,l-i+1)-1))
        value = seq(1,l-i+1);
        this_end = last_end + len_I(1,l-i+1);
        break
    end
    t = t-len_I(1,l-i+1);
end
end


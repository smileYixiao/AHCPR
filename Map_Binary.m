function [Map_Bin] = Map_Binary(Map_origin_I,seq,Code,len)
[row,col] = size(Map_origin_I);
Map_Bin = zeros();
t = 0; 
for i=1:row 
    for j=1:col
        if Map_origin_I(i,j) == -1
            continue;
        end
        for k=1:length(seq)
            if Map_origin_I(i,j) == seq(1,k)
                sum = 0;
                for n=1:k-1
                    sum = sum+len(1,n);
                end
                Map_Bin(t+1:t+len(k)) = Code(1,sum+1:sum+len(k));
                t = t + len(k);
                break;
            end
        end
    end
end
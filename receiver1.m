function [exD]=receiver1(stego_I,Data_key)
[row,col] = size(stego_I);
ptr6=1;
for j=2:col
    if ptr6>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = stego_I(2,j);
    [bin2_8] = Decimalism_Binary(value);
    if ptr6+7>ceil(log2(row))+ceil(log2(col))
        total_length(ptr6:ceil(log2(row))+ceil(log2(col)))=bin2_8(1:ceil(log2(row))+ceil(log2(col))-ptr6+1);
        ptr6=ceil(log2(row))+ceil(log2(col))+1;
    else
        total_length(ptr6:ptr6+7)=bin2_8(1:8);
        ptr6=ptr6+8;
    end
end
%% Extract auxiliary data
init_i=total_length(1:ceil(log2(row)));
init_j=total_length(ceil(log2(row))+1:length(total_length));
init_i=Binary_Decimalism(init_i);
init_j=Binary_Decimalism(init_j);
%% Extract secret data(Receiver 1)
ptr7=1;
for i=init_i+1:row
    if i==init_i+1
        jj=init_j+1;
    else
        jj=2;
    end
    for j=jj:col
        value = stego_I(i,j);
        [bin2_8] = Decimalism_Binary(value);
        exD(ptr7:ptr7+7)=bin2_8(1:8);
        ptr7=ptr7+8;
    end
end

%---------------Data decryption----------------%
[exD] = Encrypt_Data(exD,Data_key);
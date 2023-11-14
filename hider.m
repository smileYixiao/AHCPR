function [stego_I]=hider(encrypt_I,D,Data_key)
[row,col] = size(encrypt_I);
ptr4=1;
for j=2:col
    if ptr4>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = encrypt_I(2,j);
    [bin2_8] = Decimalism_Binary(value);
    if ptr4+7>ceil(log2(row))+ceil(log2(col))
        total_length(ptr4:ceil(log2(row))+ceil(log2(col)))=bin2_8(1:ceil(log2(row))+ceil(log2(col))-ptr4+1);
        ptr4=ceil(log2(row))+ceil(log2(col))+1;
    else
        total_length(ptr4:ptr4+7)=bin2_8(1:8);
        ptr4=ptr4+8;
    end
end
%% Extract auxiliary information
init_i=total_length(1:ceil(log2(row)));
init_j=total_length(ceil(log2(row))+1:length(total_length));
init_i=Binary_Decimalism(init_i);
init_j=Binary_Decimalism(init_j);
%% Secret Data D encryption
[Encrypt_D] = Encrypt_Data(D,Data_key);
%% Embed encrypted secret data
ptr5=1;
stego_I = encrypt_I;
for i=init_i+1:row
    if i==init_i+1
        jj=init_j+1;
    else
        jj=2;
    end
    if ptr5>length(Encrypt_D)
        break;
    end
    for j=jj:col
        if ptr5>length(Encrypt_D)
            break;
        end
        value = encrypt_I(i,j);
        [bin2_8] = Decimalism_Binary(value);
        if ptr5+7>length(Encrypt_D)
            bin2_8(1:length(Encrypt_D)-ptr5+1) = Encrypt_D(ptr5:length(Encrypt_D));
            ptr5=length(Encrypt_D)+1;
        else
            bin2_8(1:8) = Encrypt_D(ptr5:ptr5+7);
            ptr5=ptr5+8;
        end
        [value] = Binary_Decimalism(bin2_8);
        stego_I(i,j) = value;
    end
end

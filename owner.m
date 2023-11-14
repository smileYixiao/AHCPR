function [encrypt_I]=owner(origin_I,Image_key,ref_x,ref_y)
[row,col] = size(origin_I); 
max_length=ceil(log2(row))+ceil(log2(col))+3;
%% Preprocessing
[origin_PV_I] = Predictor_Value(origin_I,ref_x,ref_y);
[Map_origin_I] = abs(origin_I-origin_PV_I);
%% Calculate threshold
T=threshold(origin_I,origin_PV_I);
%% Huffman code of NL labels
if T==0 || T==1
    code1=[];
else
    [Map_origin_I] = abs(origin_I-origin_PV_I);
    Map_origin_I=Map_origin_I(2:row,2:col);
    Map_origin_I=Map_origin_I+1;
    hist_Map_origin_I = tabulate([Map_origin_I(:)' T+1]);
    hist_Map_origin_I = hist_Map_origin_I(1:T,:,:); 
    bbb=sortrows(hist_Map_origin_I,3);
    p_NL(1,:) = bbb(:,3)/100;
    seq1=zeros(1,T);
    for i=1:T
        seq1(bbb(T-i+1,1))=i;
    end
    [code1,len_Code1] = Huffman_Code(p_NL);
end

Map_origin_I = origin_I-origin_PV_I;
Map=zeros(row,col);
for i=1:row
    for j=1:col
        if i==1 || j==1
            Map(i,j)=-1;
        elseif abs(Map_origin_I(i,j))>=T 
            Map(i,j)=0;
        else
            Map(i,j)=1;
        end
    end
end

for i=1:row
    for j=1:col
        if Map(i,j)~=0  
            Map_origin_I(i,j) = -1;   
        else
            x = origin_I(i,j); 
            pv = origin_PV_I(i,j); 
            for t=7:-1:0  
                if floor(x/(2^t)) ~= floor(pv/(2^t))
                    ca = 8-t-1; 
                    break;
                else
                    ca = 8; 
                end
            end
            Map_origin_I(i,j) = ca;
        end        
    end
end
%% Huffman code of SL labels
m=1;
for i=1:row
    for j=1:col
        if(Map_origin_I(i,j)~=-1)
            Mp(m) = Map_origin_I(i,j);
            m=m+1;  
        end
    end
end
hist_Map_origin_I1 = tabulate(Mp(:));
ccc=sortrows(hist_Map_origin_I1,3);
p_SL(1,:) = ccc(:,3)/100;
seq2=zeros(1,length(p_SL));
for i=1:length(p_SL)
    seq2(ccc(length(p_SL)-i+1,1)+1)=i;
end
[code2,len_Code2] = Huffman_Code(p_SL);

%% ----------------------Compress bit plane----------------------%
[compress_bits,type] = BitPlanes_Compress(Map(2:row,2:col),4,3);
if type==0    
    type=[0 0];
elseif type==1
    type=[0 1];
elseif type==2
    type=[1 0];
elseif type==3
    type=[1 1];
end


[Map_origin_I2] = origin_I-origin_PV_I;
ptr=1;ptr1=1;aux=[0,0];code_Bin=[0,0];
for i=2:row
    for j=2:col
        [bin2_8] = Decimalism_Binary(origin_I(i,j)); 
        if Map_origin_I(i,j) ~= -1  
            k=Map_origin_I(i,j);
            a = seq2(k+1); 
            len = 0;
            for m=1:a
                len = len+len_Code2(m);
            end
            code_Bin(ptr1:ptr1+len_Code2(a)-1) = code2(len-len_Code2(a)+1:len);
            ptr1 = ptr1+len_Code2(a);
            if k<7
                aux(ptr:ptr+6-k)=bin2_8(k+2:8);
                ptr=ptr+7-k;
            end
        else
            if T==1
                continue;
            else
            a = seq1(abs(Map_origin_I2(i,j))+1); 
            len = 0;
            for m=1:a
                len = len+len_Code1(m);
            end
            code_Bin(ptr1:ptr1+len_Code1(a)-1) = code1(len-len_Code1(a)+1:len);
            ptr1 = ptr1+len_Code1(a);
            if Map_origin_I2(i,j)>0
                aux(ptr)=1; ptr=ptr+1;
            elseif Map_origin_I2(i,j)<0
                aux(ptr)=0; ptr=ptr+1;
            end
            end
        end
    end
end


len_bin=Decimalism_Binary(length(code_Bin));
len_bin1=Decimalism_Binary(length(aux));
len_bin2=Decimalism_Binary(length(compress_bits));

if length(len_bin) < max_length
    len = length(len_bin);
    B = len_bin;
    len_bin = zeros(1,max_length);
    for i=1:len
        len_bin(max_length-len+i) = B(i); 
    end
end

if length(len_bin1) < max_length
    len = length(len_bin1);
    B = len_bin1;
    len_bin1 = zeros(1,max_length);
    for i=1:len
        len_bin1(max_length-len+i) = B(i); 
    end
end

if length(compress_bits) >= (row-1)*(col-1)
    len_bin2 = Decimalism_Binary((row-1)*(col-1));
    Maptemp=Map(2:row,2:col);
    compress_bits=Maptemp(:)';
end
if length(len_bin2) < max_length
    len = length(len_bin2);
    B = len_bin2;
    len_bin2 = zeros(1,max_length);
    for i=1:len
        len_bin2(max_length-len+i) = B(i); 
    end
end
TT=Decimalism_Binary(T);
lim = T*4;
lim1 = T*5;

t = 0;
for i=1:length(len_Code1)
    len1 = dec2bin(len_Code1(1,i))-'0';   
    if length(len1) < 4   
        len_Code1_Bin(t+1:t+(4-length(len1))) = 0;     
        len_Code1_Bin(t+5-length(len1):t+4) =len1(1,1:length(len1));
        t = t+4;
    else 
        len_Code1_Bin(t+1:t+4) = len1(1,1:4);
        t = t+4;
    end
end
if length(len_Code1_Bin) < lim  
    len_Code1_Bin(length(len_Code1_Bin)+1:lim) = 0;
end

t = 0;
for i=1:length(len_Code2)
    len2 = dec2bin(len_Code2(1,i))-'0';  
    if length(len2) < 4  
        len_Code2_Bin(t+1:t+(4-length(len2))) = 0;     
        len_Code2_Bin(t+5-length(len2):t+4) =len2(1,1:length(len2));
        t = t+4;
    else 
        len_Code2_Bin(t+1:t+4) = len2(1,1:4);
        t = t+4;
    end
end
if length(len_Code2_Bin) < lim     
    len_Code2_Bin(length(len_Code2_Bin)+1:lim) = 0;
end

t = 0;
for i=1:length(seq1)
    seq1_I = dec2bin(seq1(1,i))-'0';    
    if length(seq1_I) < 5    
        seq1_Bin(t+1:t+(5-length(seq1_I))) = 0;
        seq1_Bin(t+6-length(seq1_I):t+5) =seq1_I(1,1:length(seq1_I));
        t = t+5;
    else 
        seq1_Bin(t+1:t+5) = seq1_I(1,1:5);
        t = t+5;
    end
end
if length(seq1_Bin) < lim1   
    seq1_Bin(length(seq1_Bin)+1:lim1) = 0;
end

t = 0;
for i=1:length(seq2)
    seq2_I = dec2bin(seq2(1,i))-'0';     
    if length(seq2_I) < 4    
        seq2_Bin(t+1:t+(4-length(seq2_I))) = 0;
        seq2_Bin(t+5-length(seq2_I):t+4) =seq2_I(1,1:length(seq2_I));
        t = t+4;
    else 
        seq2_Bin(t+1:t+4) = seq2_I(1,1:4);
        t = t+4;
    end
end
if length(seq2_Bin) < lim    
    seq2_Bin(length(seq2_Bin)+1:lim) = 0;
end

C=length(code1);
Code1_len = dec2bin(C,8)-'0'; 

C=length(code2);
Code2_len = dec2bin(C,8)-'0';   

Side_Information = [len_bin1,len_bin2,Code1_len,code1,seq1_Bin,len_Code1_Bin,Code2_len,code2,seq2_Bin,len_Code2_Bin,type,aux,compress_bits];
init=zeros(1,ceil(log2(row))+ceil(log2(col)));
bitstream=[init,TT,len_bin,code_Bin,Side_Information];


%% Pixel rearrangement
ptr2=1;
vacate_I = origin_I;
for i=2:row
    for j=2:col
        value = origin_I(i,j); 
        [bin2_8] = Decimalism_Binary(value); 
        if ptr2+7>length(bitstream)
            bin2_8(1:length(bitstream)-ptr2+1) = bitstream(ptr2:length(bitstream));
            ptr2=length(bitstream)+1;
        else
            bin2_8(1:8) = bitstream(ptr2:ptr2+7); 
            ptr2=ptr2+8;
        end
        [value] = Binary_Decimalism(bin2_8); 
        vacate_I(i,j) = value;
        if ptr2>length(bitstream)
            break;
        end
    end
    if ptr2>length(bitstream)
        break;
    end
end
if j==col
    init_j=Decimalism_Binary(1);
    init_i=Decimalism_Binary(i);
else  
    init_j=Decimalism_Binary(j);
    init_i=Decimalism_Binary(i-1);
end
if length(init_i) < ceil(log2(row))
    len = length(init_i);
    B = init_i;
    init_i = zeros(1,ceil(log2(row)));
    for i=1:len
        init_i(ceil(log2(row))-len+i) = B(i); 
    end
end
if length(init_j) < ceil(log2(col))
    len = length(init_j);
    B = init_j;
    init_j = zeros(1,ceil(log2(col)));
    for i=1:len
        init_j(ceil(log2(col))-len+i) = B(i); 
    end
end
init=[init_i init_j];
%% Image Encryption
[encrypt_I] = Encrypt_Image(vacate_I,Image_key);

ptr3=1;
for j=2:col
    if ptr3>length(init)
        break;
    end
    value = encrypt_I(2,j); 
    [bin2_8] = Decimalism_Binary(value);
    if ptr3+7>length(init)
        bin2_8(1:length(init)-ptr3+1) = init(ptr3:length(init));
        ptr3=length(init)+1;
    else
        bin2_8(1:8) = init(ptr3:ptr3+7);
        ptr3=ptr3+8;
    end
    [value] = Binary_Decimalism(bin2_8);
    encrypt_I(2,j) = value;
end

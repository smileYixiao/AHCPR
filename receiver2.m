function [recover_I]=receiver2(stego_I,Image_key)
[row,col] = size(stego_I);
max_length=ceil(log2(row))+ceil(log2(col))+3;

ptr8=1;
for j=2:col
    if ptr8>ceil(log2(row))+ceil(log2(col))
        break;
    end
    value = stego_I(2,j);
    [bin2_8] = Decimalism_Binary(value);
    if ptr8+7>ceil(log2(row))+ceil(log2(col))
        total_length(ptr8:ceil(log2(row))+ceil(log2(col)))=bin2_8(1:ceil(log2(row))+ceil(log2(col))-ptr8+1);
        ptr8=ceil(log2(row))+ceil(log2(col))+1;
    else
        total_length(ptr8:ptr8+7)=bin2_8(1:8);
        ptr8=ptr8+8;
    end
end
%% Extract auxiliary data
init_i=total_length(1:ceil(log2(row)));
init_j=total_length(ceil(log2(row))+1:length(total_length));
init_i=Binary_Decimalism(init_i);
init_j=Binary_Decimalism(init_j);
%% Image decryption
[stego_I1]= Encrypt_Image(stego_I,Image_key);

ptr9=1;
for i=2:row
    for j=2:col
        value = stego_I1(i,j);
        [bin2_8] = Decimalism_Binary(value);
        exaux(ptr9:ptr9+7)=bin2_8(1:8);
        ptr9=ptr9+8;
        if i==init_i+1 && j==init_j+1
            break;
        end
    end
    if i==init_i+1 && j==init_j+1
        break;
    end
end

node0=ceil(log2(row))+ceil(log2(col));

node1=node0+8;
T=exaux(node0+1:node1); 
T=Binary_Decimalism(T);
lim=4*T;lim1=5*T;

node2=node1+max_length;
exlen_bin=exaux(node1+1:node2); 
exlen_bin=Binary_Decimalism(exlen_bin);

node3=node2+exlen_bin;
excode_Bin=exaux(node2+1:node3);
excode_Bin=[excode_Bin,zeros(1,100)];

node4=node3+max_length;
exlen_bin1=exaux(node3+1:node4); 

node5=node4+max_length;
exlen_bin2=exaux(node4+1:node5);

node6=node5+8;
excode1_len=exaux(node5+1:node6);
excode1_len=Binary_Decimalism(excode1_len);

node7=node6+excode1_len;
excode1=exaux(node6+1:node7);

node8=node7+lim1;
exseq1_Bin=exaux(node7+1:node8);

node9=node8+lim;
exlen_Code1_Bin=exaux(node8+1:node9);

node10=node9+8;
excode2_len=exaux(node9+1:node10);
excode2_len=Binary_Decimalism(excode2_len);

node11=node10+excode2_len;
excode2=exaux(node10+1:node11);

node12=node11+lim;
exseq2_Bin=exaux(node11+1:node12);

node13=node12+lim;
exlen_Code2_Bin=exaux(node12+1:node13); 

node14=node13+2;
extype=exaux(node13+1:node14);
extype=Binary_Decimalism(extype);

exlen_bin1=Binary_Decimalism(exlen_bin1);
exlen_bin2=Binary_Decimalism(exlen_bin2);
node15=node14+exlen_bin1;
node16=node15+exlen_bin2;
exaux2=exaux(node14+1:node15);
excompress_bits=exaux(node15+1:node16);

t = 0;
for i=1:T
    m = 1; 
    num1 = 0;
    for j=t+1:t+5
        num1 = num1 + exseq1_Bin(j)*(2^(5-m));
        m = m+1;
    end
    t = t+5;
    if num1==0
        break;
    else
        seq1_I(1,i) = num1; 
    end
end

t=0;
for i=1:T
    m = 1; 
    num1 = 0;
    for j=t+1:t+4
        num1 = num1 + exlen_Code1_Bin(j)*(2^(4-m));
        m = m+1;
    end
    t = t+4;
    if num1==0
        break;
    else
        len_Code1(1,i) = num1;
    end
end

t = 0;
for i=1:T
    m = 1; 
    num1 = 0;
    for j=t+1:t+4
        num1 = num1 + exseq2_Bin(j)*(2^(4-m));
        m = m+1;
    end
    t = t+4;
    if num1==0
        break;
    else
        seq2_I(1,i) = num1; 
    end
end

t=0;
for i=1:T
    m = 1; 
    num1 = 0;
    for j=t+1:t+4
        num1 = num1 + exlen_Code2_Bin(j)*(2^(4-m));
        m = m+1;
    end
    t = t+4;
    if num1==0
        break;
    else
        len_Code2(1,i) = num1; 
    end
end

Plane_Matrix=zeros(row-1,col-1);
if exlen_bin2==Binary_Decimalism((row-1)*(col-1))
    nn=1;
    for i=1:col-1
        for j=1:row-1
            Plane_Matrix(j,i)=excompress_bits(nn);
            nn=nn+1;
        end
    end
else
    [Plane_bits] = BitStream_DeCompress(excompress_bits,3);
    [Plane_Matrix] = BitPlanes_Recover(Plane_bits,4,extype,row-1,col-1);
end

B=[];
if T==1
else
    for i=1:T
        num=0;
        for j=1:seq1_I(1,i)
            num = num+len_Code1(1,j);
        end
        B{1,i}=excode1(num-len_Code1(1,j)+1:num);
    end
end
E=[];
for i=1:length(seq2_I)
    num=0;
    for j=1:seq2_I(1,i)
        num = num+len_Code2(1,j);
    end
    E{1,i}=excode2(num-len_Code2(1,j)+1:num);
end
length_C2 = length(E);

recover_I=stego_I1;
ptr12=1; ptr13=1;
for i=2:row
    for j=2:col
        a = recover_I(i-1,j);
        b = recover_I(i-1,j-1);
        c = recover_I(i,j-1);
        if b <= min(a,c)
            PV = max(a,c);
        elseif b >= max(a,c)
            PV = min(a,c);
        else
            PV = a + c - b;
        end
        if Plane_Matrix(i-1,j-1)==1
            if T ==1
                recover_I(i,j)=PV;
            else
                for k=1:T
                    if excode_Bin(ptr12:ptr12+length(B{1,k})-1)==B{1,k} 
                        if k==1
                            ptr12=length(B{1,k})+ptr12;
                            recover_I(i,j)=PV;
                        else
                            if exaux2(ptr13)==1
                                e=k-1;
                            else
                                e=-(k-1);
                            end
                            ptr12=length(B{1,k})+ptr12;
                            ptr13=ptr13+1;
                            recover_I(i,j)=PV+e;
                        end
                        break;
                    end
                end
            end
        else
            [bin2_8] = [0 0 0 0 0 0 0 0];
            for k=1:length_C2
                if excode_Bin(ptr12:ptr12+length(E{1,k})-1)==E{1,k} 
                    L=k-1;
                    PV=Decimalism_Binary(PV);
                    if L==8
                        bin2_8(1:8)=PV(1:8);
                    elseif L==7
                        bin2_8(1:7)=PV(1:7);
                        bin2_8(8)=~PV(8);
                    elseif L==0
                        bin2_8(1)=~PV(1);
                        bin2_8(2:8)=exaux2(ptr13:ptr13+6);
                        ptr13=ptr13+7;
                    else
                        bin2_8(1:L)=PV(1:L);
                        bin2_8(L+1)=~PV(L+1);
                        bin2_8(L+2:8)=exaux2(ptr13:ptr13+6-L);
                        ptr13=ptr13+7-L;
                    end
                    recover_I(i,j)=Binary_Decimalism(bin2_8);
                    ptr12=length(E{1,k})+ptr12;
                    break;
                end
            end
        end
    end
end
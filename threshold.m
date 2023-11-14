function [T]=threshold(origin_I,origin_PV_I)
[row,col] = size(origin_I);
T=zeros(1,33);
for z=0:1:16
    if z==0 || z==1
    else
        [Map_origin_I] = abs(origin_I-origin_PV_I);
        Map_origin_I=Map_origin_I(2:row,2:col);
        Map_origin_I=Map_origin_I+1;
        hist_Map_origin_I = tabulate([Map_origin_I(:)' z+1]);
        hist_Map_origin_I = hist_Map_origin_I(1:z,:,:);
        bbb=sortrows(hist_Map_origin_I,-2);
  
        code=zeros(1,z);
        for i=1:z
            code(bbb(i,1))=i;
        end
    end
    [A,len1]=query(z);
    if z<=15 && z>=8
        C={[0 1],[1 0],[0 0],[1 1 0],[1 1 1]};len2=12;
    elseif z==0
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1 0],[1 1 1 1 1]};len2=32;
    elseif z<=32 && z>=16
        C={[0 1],[1 0],[0 0],[1 1]};len2=8;
    elseif z<=7 && z>=4
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1]};len2=16;
    elseif z==1
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0 1],[1 1 1 0],[0 0 0 0],[1 1 1 1]};len2=26;
    elseif z<=3 && z>=2
        C={[0 1],[1 0],[0 0 1],[1 1 0],[0 0 0],[1 1 1 0],[1 1 1 1]};len2=21;
    end
    length_C=length(C);
    Map_origin_I=origin_I-origin_PV_I;
    Map=zeros(row,col);
    for i=1:row
        for j=1:col
            if i==1 || j==1
                Map(i,j)=-1;
            elseif abs(Map_origin_I(i,j))>=z
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
    Map_origin_I=Map_origin_I+2;
    hist_Map_origin_I1 = tabulate([Map_origin_I(:)' length_C+2]);
    hist_Map_origin_I1 = hist_Map_origin_I1(2:length_C+1,:,:);
    ccc=sortrows(hist_Map_origin_I1,-2);
    Map_origin_I=Map_origin_I-2;
    edoc=zeros(1,length_C);
    for i=1:length_C
        edoc(ccc(i,1)-1)=i;
    end
    rtp=1;v=0;
    for i=2:row
        for j=2:col
            if Map_origin_I(i,j) ~= -1
                k=Map_origin_I(i,j);
                if k>=7
                    v=v+8-length(C{1,edoc(k+1)});
                else
                    rtp=rtp+7-k;
                    v=v+8-length(C{1,edoc(k+1)});
                end
            end
        end
    end
    sign=v-rtp+1;
    count=0;
    Map_origin_I=origin_I-origin_PV_I;
    for i=2:row
        for j=2:col
            if Map(i,j)==1
                if z==1
                    count=count+8;
                else
                    if Map_origin_I(i,j)==0
                        count=count+8-length(A{1,code(1)});
                    elseif Map_origin_I(i,j)>0
                        count=count+7-length(A{1,code(Map_origin_I(i,j)+1)});
                    else
                        count=count+7-length(A{1,code(abs(Map_origin_I(i,j))+1)});
                    end
                end
            end
        end
    end

    [compress_bits,~] = BitPlanes_Compress(Map(2:row,2:col),4,3);
    LC=length(compress_bits);
    if LC >= (row-1)*(col-1)
        LC = (row-1)*(col-1);
    end
    T(z+1)=sign+count-LC-len1-len2;
end
[~,T]=max(T);
T=T-1;
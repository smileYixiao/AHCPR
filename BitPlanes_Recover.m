function [Plane_Matrix] = BitPlanes_Recover(Plane_bits,Block_size,type,row,col)
% 函数说明：根据BMPR算法逆过程将比特流恢复成位平面矩阵
% 输入：Plane_bits（位平面比特流）,Block_size（分块大小）,type（重排列方式）,row,col（矩阵的行列数）
% 输出：Plane_Matrix（位平面矩阵）

Plane_Matrix = zeros(row,col);
m = floor(row/Block_size); 
n = floor(col/Block_size);
num = 0;
%-------------------分块内按行遍历，分块间按行遍历（行-行）------------------%
if type==0
    for i=1:m 
        for j=1:n
            begin_x = (i-1)*Block_size+1;
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size;
            end_y = j*Block_size;
            for x=begin_x:end_x 
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end
        if col-n*Block_size>=1 
            begin_y = n*Block_size+1;
            end_y = col;
            for x=begin_x:end_x 
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end
        end  
    end
    if row-m*Block_size>=1
        begin_x = m*Block_size+1; 
        end_x = row;
        for j=1:n
            begin_y = (j-1)*Block_size+1;
            end_y = j*Block_size;
            for x=begin_x:end_x 
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for x=begin_x:end_x 
            for y=begin_y:end_y
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end  
    end
%-------------------分块内按行遍历，分块间按列遍历（行-列）------------------%
elseif type==1
    for j=1:n 
        for i=1:m
            begin_x = (i-1)*Block_size+1;
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size;
            end_y = j*Block_size;
            for x=begin_x:end_x
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end
        if row-m*Block_size>=1 
            begin_x = m*Block_size+1;
            end_x = row;
            for x=begin_x:end_x 
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end
        end  
    end
    if col-n*Block_size>=1
        begin_y = n*Block_size+1; 
        end_y = col;
        for i=1:m
            begin_x = (i-1)*Block_size+1;
            end_x = i*Block_size;
            for x=begin_x:end_x 
                for y=begin_y:end_y
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for x=begin_x:end_x 
            for y=begin_y:end_y
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end  
    end
%-------------------分块内按列遍历，分块间按行遍历（列-行）------------------%
elseif type==2 
    for i=1:m  
        for j=1:n
            begin_x = (i-1)*Block_size+1; 
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size; 
            end_y = j*Block_size; 
            for y=begin_y:end_y  
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end
        if col-n*Block_size>=1 
            begin_y = n*Block_size+1;
            end_y = col;
            for y=begin_y:end_y  
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end 
        end  
    end
    if row-m*Block_size>=1 
        begin_x = m*Block_size+1; 
        end_x = row;
        for j=1:n
            begin_y = (j-1)*Block_size+1;
            end_y = j*Block_size;
            for y=begin_y:end_y 
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end   
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1 
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for y=begin_y:end_y  
            for x=begin_x:end_x  
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end   
    end
%-------------------分块内按列遍历，分块间按列遍历（列-列）------------------%
else 
    for j=1:n  
        for i=1:m
            begin_x = (i-1)*Block_size+1; 
            begin_y = (j-1)*Block_size+1;
            end_x = i*Block_size; 
            end_y = j*Block_size;
            for y=begin_y:end_y 
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end
        if row-m*Block_size>=1 
            begin_x = m*Block_size+1;
            end_x = row;
            for y=begin_y:end_y  
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end
        end  
    end
    if col-n*Block_size>=1 
        begin_y = n*Block_size+1; 
        end_y = col;
        for i=1:m
            begin_x = (i-1)*Block_size+1;
            end_x = i*Block_size;
            for y=begin_y:end_y 
                for x=begin_x:end_x  
                    num = num+1;
                    Plane_Matrix(x,y) = Plane_bits(num);
                end
            end  
        end  
    end
    if row-m*Block_size>=1 && col-n*Block_size>=1
        begin_x = m*Block_size+1;
        begin_y = n*Block_size+1;
        end_x = row;
        end_y = col;
        for y=begin_y:end_y  
            for x=begin_x:end_x  
                num = num+1;
                Plane_Matrix(x,y) = Plane_bits(num);
            end
        end  
    end 
end
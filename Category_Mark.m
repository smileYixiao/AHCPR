function [Map_origin_I] = Category_Mark(origin_PV_I,origin_I,ref_x,ref_y)
% ����˵������ÿ������ֵ���б�ǣ�������ԭʼͼ���λ��ͼ
% ���룺origin_PV_I��Ԥ��ֵ����origin_I��ԭʼֵ��,ref_x,ref_y���ο����ص���������
% �����Map_origin_I������ֵ�ı�Ƿ���,��λ��ͼ��
[row,col] = size(origin_I);
Map_origin_I = origin_I; 
for i=1:row
    for j=1:col
        if i<=ref_x || j<=ref_y
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
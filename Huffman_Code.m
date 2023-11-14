function [g,len] = Huffman_Code(p)
n=length(p);
q=p;
m=zeros(n-1,n);
for i=1:n-1
    [q,e]=sort(q); 
    m(i,:)=[e(1:n-i+1),zeros(1,i-1)]; 
    q=[q(1)+q(2),q(3:n),1]; 
end
 
for i=1:n-1
    c(i,1:n*n)=blanks(n*n); 
end
c(n-1,n)='1'; 
c(n-1,2*n)='0'; 
for i=2:n-1
    c(n-i,1:n-1)=c(n-i+1,n*(find(m(n-i+1,:)==1))-(n-2):n*(find(m(n-i+1,:)==1))); 
    c(n-i,n)='0'; 
    c(n-i,n+1:2*n-1)=c(n-i,1:n-1);
    c(n-i,2*n)='1'; 
    for j=1:i-1
         c(n-i,(j+1)*n+1:(j+2)*n)=c(n-i+1,n*(find(m(n-i+1,:)==j+1)-1)+1:n*find(m(n-i+1,:)==j+1));
    end
end 
t = 0;
for i=1:n
    h(i,1:n)=c(1,n*(find(m(1,:)==i)-1)+1:find(m(1,:)==i)*n); 
end
for i=n:-1:1
    len(1,n-i+1)=length(find(abs(h(i,:))~=32));
    g(t+1:t+len(n-i+1)) = double(h(i,n-len(n-i+1)+1:n))-'0';
    t = t+len(n-i+1);
end
function d = spider_web_nodes_norma5(n,a) %n is the number of the edge 
                                   %a is the number of level;circle

r = 1.2143;
d.x_pos = [];
d.y_pos = [];
d.num = 1 + a*n;
d.from = [];
d.to = [];
d.x_pos = [d.x_pos; 0];
d.y_pos = [d.y_pos; 0];
for a = 1:a;
    for t=(0:n-1)*2*pi/n;%+rand_in_range([0.1 0.2],1);    %theta=(n-2)*pi/2/n;r=c/2/cos(theta);
        %r1 = r + rand_in_range([-0.5 0.5],1);
        d.x_pos = [d.x_pos; r*cos(t)];
        d.y_pos = [d.y_pos; r*sin(t)];
    end
    r=r+r*rand_in_range([0.1 1],1);
end
d.w_idx=0;
%connect centre node to the nodes around it
for i=1:n
    d.w_idx = d.w_idx + 1;
    d.from(d.w_idx,1) = 1; 
    d.to(d.w_idx,1)   = i+1;  
end
%connect the node from n to n+1
for j=1:a-1
    for k=2:n
        d.w_idx = d.w_idx + 1;
        d.from(d.w_idx,1) = k+(j-1)*n; 
        d.to(d.w_idx,1)   = k+1+(j-1)*n;
    end
end
%connect the last one of the circle to the first one
for i=1:a-1
        d.w_idx = d.w_idx + 1;
        d.from(d.w_idx,1) = n+1+(i-1)*n; 
        d.to(d.w_idx,1)   = 2+(i-1)*n;
end
%connect the circle with the circle
for i=1:a-1
    for j=2:n+1
        d.w_idx = d.w_idx + 1;
        d.from(d.w_idx,1) = j+(i-1)*n; 
        d.to(d.w_idx,1)   = j+i*n;
    end
end


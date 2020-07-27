function d = spider_web_nodes_sprial(n,a,delta) %n is the number of the edge 
                                   %a is the number of level;circle

b = 1;
r=0.5;
d.x_pos = [];
d.y_pos = [];
d.num = 1 + (a+1)*n;
d.x_pos = [d.x_pos; 0];
d.y_pos = [d.y_pos; 0];
for i = 1:a+1;
    for t=(0:n-1)*360/n;
    theta=(n-2)*pi/2/n;
   % r=b/2/cos(theta);
    d.x_pos = [d.x_pos; normrnd(r*cosd(t),delta)];
    d.y_pos = [d.y_pos; normrnd(r*sind(t),delta)];
    r=r+0.1*i;
    end
   % r=r+i*0.5;
end

d.w_idx=0;
for i=1:n
    d.w_idx = d.w_idx + 1;
    d.from(d.w_idx,1) = 1; 
    d.to(d.w_idx,1)   = i+1;  
end
%for j=1:a
%connect the node from n to n+1
for k=2:a*n  %2:n
        d.w_idx = d.w_idx + 1;
        d.from(d.w_idx,1) = k%+(j-1)*n; 
        d.to(d.w_idx,1)   = k+1%+(j-1)*n;
end
%end
% for i=1:a
%         d.w_idx = d.w_idx + 1;
%         d.from(d.w_idx,1) = n+1+(i-1)*n; 
%         d.to(d.w_idx,1)   = 2+(i-1)*n;
% end
%connect the circle with the circle
for i=1:a
    for j=2:n+1
        d.w_idx = d.w_idx + 1;
        d.from(d.w_idx,1) = j+(i-1)*n; 
        d.to(d.w_idx,1)   = j+i*n;
    end
end
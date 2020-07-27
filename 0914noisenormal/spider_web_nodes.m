function [x_pos,y_pos] = spider_web_nodes(n,a) %n is the number of the edge 
                                   %a is the number of level;circle

d = 1;
x_pos = [];
y_pos = [];
x_pos = [x_pos; 0];
y_pos = [y_pos; 0];
for a = 1:a;
    for t=(0:n-1)*2*pi/n;
    theta=(n-2)*pi/2/n;
    r=d/2/cos(theta);
    x_pos = [x_pos; r*cos(t)];
    y_pos = [y_pos; r*sin(t)];
    end
    d=d+1;
end

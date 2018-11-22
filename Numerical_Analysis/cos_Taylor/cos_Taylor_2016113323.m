function cos_Taylor_2016113323(x, a, n)
cosx = 0;
k = x - a;
for i = 0:n
    cosx = cosx + f_d_n(i,a)*(k.^i)/factorial(i);
end
plot(x,cosx,'r:o','LineWidth',4)
end

function p = f_d_n(i,a)
switch mod(i,4)
    case 0
        p = cos(a);
    case 1
        p = -sin(a);
    case 2
        p = -cos(a);
    case 3
        p = sin(a);
end
end

        
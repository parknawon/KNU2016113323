function [eig_val, eig_vec] = power_2016113323(A,es,maxit)

[m,n] = size(A);
if (m==n)&&(min(min(A==A')')) %#ok<*UDIM>
    choice = input('\n1) 가장 큰 eigenvalue/eigenvector\n2) 가장 작은 eigenvalue/eigenvector\n\n선택 : ');
    switch choice
        case 1
            [eig_val, eig_vec] = eig_f (m, A, es, maxit);
        case 2
            [lambda, eig_vec] = eig_f (m, inv(A), es, maxit); eig_val = 1/lambda;
    end
else
    fprintf ('\n대칭행렬이 아닙니다. \n\n')
end
end


function [val, vec] = eig_f (m, B, es, maxit)

vec = ones(m,1);
i=1;
while (es >  0.05 || i <= maxit)
    L = B*vec;
    if max(abs(L)) == max(L)
        val = max(abs(L));
    else 
        val = -max(abs(L));        
    end
    saveval = val;    
    vec = L/val;
    if i~=1, es = abs((val-saveval)/val); end
    i = i+1;
end
end   
function k = kurtosis(x,flag,dim)


if nargin < 2 || isempty(flag)
    flag = 1;
end

if ~(isequal(flag,0) || isequal(flag,1) || isempty(flag))
    error(message('stats:trimmean:BadFlagReduction'));
end

if nargin < 3 || isempty(dim)

    if isequal(x,[]), k = NaN('like',x); return; end


    dim = find(size(x) ~= 1, 1);
    if isempty(dim), dim = 1; end
end


x0 = x - nanmean(x,dim);
s2 = nanmean(x0.^2,dim); 
m4 = nanmean(x0.^4,dim);
k = m4 ./ s2.^2;


if flag == 0
    n = sum(~isnan(x),dim);
    n(n<4) = NaN; 
    k = ((n+1).*k - 3.*(n-1)) .* (n-1)./((n-2).*(n-3)) + 3;
end
end

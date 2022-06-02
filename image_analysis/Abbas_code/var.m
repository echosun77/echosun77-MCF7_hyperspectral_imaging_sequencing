function y = var(x,w,dim,flag)


if isinteger(x) 
    error(message('MATLAB:var:integerClass'));
end

hasFlag = false;
hasW = false;
hasDim = false;
if nargin == 2
    if ischar(w) || (isstring(w) && isscalar(w))
        flag = w;
        hasFlag = true;
    else
        hasW = true;
    end
elseif nargin == 3
    hasW = true;
    if (~ischar(dim) && ~(isstring(dim) && isscalar(dim))) || ...
        (isValidText(dim) && strncmpi(dim,'all',max(strlength(dim), 1)))
        hasDim = true;
    else
        flag = dim;
        hasFlag = true;
    end
elseif nargin == 4
    hasW = true;
    hasDim = true;
    hasFlag = true;    
end

if ~hasW || isempty(w)
    w = 0;
end

if isequal(x, []) && ~hasDim
    y = NaN(class(x));
    return;
end

if hasDim
    if isempty(dim) || (nargin == 4 && isValidText(dim) && ~strncmpi(dim,'all',max(strlength(dim), 1)))
        error(message('MATLAB:getdimarg:invalidDim'));
    end
else
    dim = find(size(x) ~= 1, 1);
    if isempty(dim)
        dim = 1;
    end
end

omitnan = false;
if hasFlag
    if ~isValidText(flag)
        if nargin == 3
            error(message('MATLAB:var:unknownOption'));
        else
            error(message('MATLAB:var:unknownFlag'));
        end
    end
    
    len = max(strlength(flag), 1);
    s = strncmpi(flag, {'omitnan', 'includenan'}, len);
    
    if ~any(s)
        if nargin == 3
            error(message('MATLAB:var:unknownOption'));
        else
            error(message('MATLAB:var:unknownFlag'));
        end
    end
    
    omitnan = s(1);
end

% Unweighted variance
if isequal(w,0) || isequal(w,1)
    n = mysize(x,dim);
    if ~omitnan
        if w == 0
            % The unbiased estimator: divide by (n-1).  Can't do this
            % when n == 0 or 1.
            if n > 1
                denom = n - 1;
            else
                denom = n;
            end
        else
            % The biased estimator: divide by n.
            denom = n; % n==0 => return NaNs, n==1 => return zeros
        end
        
        % abs guarantees a real result
        y = sum(abs(x - sum(x,dim)./n).^2, dim) ./ denom; 
        
    else
        n = sum(~isnan(x), dim);
        if w == 0
            % The unbiased estimator: divide by (n-1).  Can't do this when
            % n == 0 or 1
            denom = n-1;
            denom(n == 1) = 1;
            denom(n == 0) = 0;  
        else
            % The biased estimator: divide by n.
            denom = n; % n==1 => we'll return zeros
        end
        
        xs = abs(x - (sum(x, dim, 'omitnan')./n)).^2;
        y = sum(xs, dim, 'omitnan') ./ denom; % abs guarantees a real result
        ind = sum(~isnan(xs), dim) < n; % did computation of xs add NaNs
        y(ind) = NaN;
    end
    
    % Weighted variance
else
    if hasDim && ((isnumeric(dim) && ~isscalar(dim)) || ischar(dim) || isstring(dim))
        error(message('MATLAB:var:vecWgtWithVecDIM'));
    end
    if ~isvector(w) || ~isreal(w) || ~isfloat(w) || ...
       (omitnan && ~all(w(~isnan(w)) >= 0)) || (~omitnan && ~all(w >= 0))
        error(message('MATLAB:var:invalidWgts'));
    end
    n = size(x,dim);
    if numel(w) ~= n
        if isscalar(w)
            error(message('MATLAB:var:invalidWgts'));
        else
            error(message('MATLAB:var:invalidSizeWgts'));
        end
    end
    
    if ~omitnan
          
        % Normalize W, and embed it in the right number of dims.  Then
        % replicate it out along the non-working dims to match X's size.
        wresize = ones(1,max(ndims(x),dim)); wresize(dim) = n;
        w = reshape(w ./ sum(w), wresize);
        y = sum(w .* abs(x  - sum(w .* x, dim)).^2, dim); % abs guarantees a real result
        
    else
        % Repeat vector W, such that new W has the same size as X
        sz = size(x); sz(end+1:dim) = 1;
        wresize = ones(size(sz)); wresize(dim) = sz(dim);
        wtile = sz; wtile(dim) = 1;
        w = repmat(reshape(w, wresize), wtile);
        
        % Count up non-NaN weights at non-NaN elements
        w(isnan(x)) = NaN;
        denom = sum(w, dim, 'omitnan'); % contains no NaN, since w >= 0
          
        x = x - (sum(w .* x, dim, 'omitnan') ./ denom);
        wx2 = w .* abs(x).^2;
        y = sum(wx2, dim, 'omitnan') ./ denom; % abs guarantees a real result
        
        % Don't omit NaNs caused by computation (not missing data)
        ind = any(isnan(wx2) & ~isnan(w), dim);
        y(ind) = NaN;

    end

end

end

function tf = isValidText(str)
tf = (ischar(str) && isrow(str)) || ...
     (isstring(str) && isscalar(str) && (strlength(str) > 0));
end

function s = mysize(x, dim)
if isnumeric(dim) || islogical(dim)
    if isscalar(dim)
        s = size(x,dim);
    else
        s = size(x,dim(1));
        for i = 2:length(dim)
            s = s * size(x,dim(i));
        end
    end
else
    s = numel(x);
end

end

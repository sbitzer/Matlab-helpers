% K = dist2(a, b, Q)
%
% compute the squared Mahalanobis distance (a-b)'*Q*(a-b)
%
% inputs: 
% a,b:    row vectors (mandatory)
% Q:      matrix (optional), if Q is not provided, Q = eye(D) is assumed
%
% Copyright (C) 2008-2009 by Marc Deisenroth and Carl Edward Rasmussen,
% 2009-01-29
%
% Sebastian Bitzer: I renamed this to dist2 as a faster substitute for
% netlab's dist2 function (former name: maha.m)
function K = dist2(a, b, Q)                         

if nargin == 2 % assume Q = 1
  K = bsxfun(@plus,sum(a.*a,2),sum(b.*b,2)')-2*a*b';
else
  aQ = a*Q; K = bsxfun(@plus,sum(aQ.*a,2),sum(b*Q.*b,2)')-2*aQ*b';
end
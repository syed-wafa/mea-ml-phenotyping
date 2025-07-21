function [burstctr, burstind, burstSurprise, surprise] = burstNE(t, varargin)

N = length(t);
surprise = zeros(size(t));

if length(varargin)>0
    surpriseThresh = varargin{1};
    maxNotSurprising = varargin{2};
else
    surpriseThresh = 5;
    maxNotSurprising = 1;
end

if length(t)>1;
    
    
    mfr = length(t)/(t(end)-t(1));
    misi = 1/mfr;
    
    b1 = 1;
    ind = 1;
    up = [];
    down = [];
    
    while (b1 <= N-3),
        
        if ((t(b1+1)-t(b1) <= misi/2) && ...
                ((t(b1+2)-t(b1+1) <= misi/2)))
            
            surprise(b1+2) = estSurprise(3,mfr*(t(b1+2)-t(b1)));
            b2 = b1+3;
            while ((b2 < N) && (t(b2)-t(b2-1) <= misi)),
                
                surprise(b2) = estSurprise(b2-b1+1,mfr*(t(b2)-t(b1)));
                b2 = b2+1;
                
            end;
            
            [val, j] = max(surprise(b1+2:b2-1));
            j = b1+1+j;
            
            for kk = b1:j-2
                surprise(kk) = estSurprise(j-kk+1,mfr*(t(j)-t(kk)));
            end
            
            [val, i] = max(surprise(b1:j-1));
            i = b1+i-1;
            
            val = estSurprise2(j-i+1,mfr*(t(j)-t(i)));
            if ((val >= surpriseThresh) && (j-i >= 3)),
                up(ind) = i;
                down(ind) = j;
                burstSurprise(ind) = val;
                ind = ind+1;
            end;
            
            b1 = b2;
        else
            b1 = b1+1;
        end;
    end;
    
    if isempty(up)
        burstctr = [];
        burstind = [];
        burstSurprise = [];
        surprise = [];
    else
        %get the burst center positions
        burstctr = zeros(size(up));
        for i = 1:length(up),
            burstctr(i) = mean(t(up(i):down(i)));
        end;
        
        burstctr = burstctr';
        burstind = [up; down]';
        burstSurprise = burstSurprise';
        
    end;
    
else
    burstctr = [];
    burstind = [];
    burstSurprise = [];
    surprise = [];
end

    function S = estSurprise(k,lambda)
        P = exp(-lambda)*(lambda^k)/factorial(k);
        S = -log10(P);
    end

    function S = estSurprise2(k,lambda)
        P = 0;
        for ii = 0:k-1
            P = P + exp(-lambda)*(lambda^ii)/(factorial(ii));
        end
        S = -log10(1-P);
    end

end
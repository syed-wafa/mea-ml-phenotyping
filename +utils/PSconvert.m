function [newbts bns burst] = PSconvert(ts,burstind)

[m n] = size(burstind);
bns = zeros(m,1);

newbts = [];
if ~isempty(burstind)
    for ii = 1:m;
        newbts = [newbts ts(burstind(ii,1):burstind(ii,2))];
        bns(ii) = burstind(ii,2)-burstind(ii,1)+1;
        burst(ii).strt = ts(burstind(ii,1));
        burst(ii).stp = ts(burstind(ii,2));
        burst(ii).duration = burst(ii).stp-burst(ii).strt;
        burst(ii).numSpikes = bns(ii);
        burst(ii).intraFreq = burst(ii).numSpikes/burst(ii).duration;
        
        isi = utils.calcISI(ts(burstind(ii,1):burstind(ii,2)));
        burst(ii).meanISI = mean(isi);
        burst(ii).medianISI = median(isi);
        
    end
else
    burst = [];
end

end
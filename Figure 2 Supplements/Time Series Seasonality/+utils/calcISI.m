function isi = calcISI(ts)

isi = zeros(length(ts)-1,1);

for ii = 2:length(ts)
    isi(ii-1) = ts(ii) - ts(ii-1);
end

end
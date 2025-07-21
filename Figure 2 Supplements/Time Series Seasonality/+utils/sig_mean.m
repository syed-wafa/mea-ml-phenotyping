function fdf = sig_mean(control_ns, disease_ns,...
    control_genotypes, disease_genotypes, line_id)

nfeatures = size(control_ns, 2);
ntime = size(control_ns, 3);

fdf = NaN(nfeatures, ntime);

for t = 1:ntime
    for f = 1:nfeatures
        
        c = control_ns(control_genotypes==line_id, f, t);
        d = disease_ns(disease_genotypes==line_id, f, t);

        % if kstest(zscore(c)) == 1 || kstest(zscore(d)) == 1
        %     [~, h] = ranksum(c, d);
        % else
        %     h = ttest2(c, d);
        % end
        % 
        % if h == 0
        %     d(:, 1) = 0;
        % end

        fdf(f, t) = mean(d, 'omitnan');
         
    end
end
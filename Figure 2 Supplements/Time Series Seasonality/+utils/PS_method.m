function result = PS_method(spike_train, si_thresh)
    if nargin < 2 || isempty(si_thresh)
        si_thresh = 3;
    end
    
    burst = si_find_bursts_thresh(spike_train);
    
    if isempty(burst) | isnan(burst)
        result = NaN(1, 7);
    else
        burst_rem = find(burst(:,3) < si_thresh);
        if ~isempty(burst_rem)
            burst(burst_rem, :) = [];
        end
        
        if isempty(burst) | isnan(burst)
            result = NaN(1, 7);
        else
            beg = burst(:,1);
            len = burst(:,2);
            N_burst = length(beg);
            end_vals = beg + len - 1;
            IBI = [NaN; (spike_train(beg(2:end)) - spike_train(end_vals(1:end-1)))'];
            result = [beg, end_vals, IBI, len, burst(:,4), burst(:,5), burst(:,3)];
        end
    end
end

function res = si_find_bursts_thresh(spikes)
    nspikes = length(spikes);
    mean_isi = mean(diff(spikes));
    threshold = mean_isi / 2;
    n = 1;
    max_bursts = floor(nspikes / 3);
    bursts = NaN(max_bursts, 5);
    burst = 0;

    while n < nspikes - 2
        if ((spikes(n + 1) - spikes(n)) < threshold && ...
            (spikes(n + 2) - spikes(n + 1)) < threshold)
        
            res_temp = si_find_burst_thresh2(n, spikes, nspikes, mean_isi);
            
            if isnan(res_temp(1))
                n = n + 1;
            else
                burst = burst + 1;
                if burst > max_bursts
                    error('Too many bursts');
                end
                bursts(burst, :) = res_temp;
                n = res_temp(1) + res_temp(2);
            end
        else
            n = n + 1;
        end
    end
    
    if burst > 0
        res = bursts(1:burst, :);
    else
        res = NaN;
    end
end

function res = si_find_burst_thresh2(n, spikes, nspikes, mean_isi)
    isi_thresh = 2 * mean_isi;
    i = 3;
    s = surprise(n, i, spikes, nspikes, mean_isi);
    
    phase1 = true;
    while phase1
        i_cur = i;
        check = min(10, nspikes - (i + n - 1));
        looking = true;
        okay = false;

        while looking
            if check == 0
                looking = false;
                break;
            end
            check = check - 1;
            i = i + 1;
            s_new = surprise(n, i, spikes, nspikes, mean_isi);

            if s_new > s
                okay = true;
                looking = false;
            elseif (spikes(i) - spikes(i - 1)) > isi_thresh
                looking = false;
            end
        end

        if okay
            s = s_new;
        else
            phase1 = false;
            i = i_cur;
        end
    end
    
    phase2 = true;
    while phase2
        if i == 3
            phase2 = false;
        else
            s_new = surprise(n + 1, i - 1, spikes, nspikes, mean_isi);
            if s_new > s
                n = n + 1;
                i = i - 1;
                s = s_new;
            else
                phase2 = false;
            end
        end
    end

    isis = diff(spikes(n + (0:(i - 1))));
    mean_isi = mean(isis);
    durn = spikes(n + i - 1) - spikes(n);
    res = [n, i, s, durn, mean_isi];
end

function s = surprise(n, i, spikes, ~, mean_isi)
    dur = spikes(n + i - 1) - spikes(n);
    lambda = dur / mean_isi;
    p = poisscdf(i - 2, lambda, 'upper');
    s = -log(p);
end
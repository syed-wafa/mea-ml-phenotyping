function array_out = calculate_p_value(control_df, disease_df, time)

nfeatures = size(control_df, 2);
array_out = zeros(nfeatures, 2);

rmtnames = strcat('t', string(time));
rmtime = table(time', 'variablenames', {'Time'});

ptbl = [control_df; disease_df];
ptbl(isnan(ptbl)) = 0;

ptargets = [repmat({'Control'}, size(control_df, 1), 1);...
    repmat({'KCNQ2'}, size(disease_df, 1), 1)];
ptargets = table(ptargets, 'variablenames', {'Class'});

for feature = 1:nfeatures

    tbl = array2table(permute(ptbl(:, feature, :), [1, 3, 2]));
    tbl.Properties.VariableNames = rmtnames';
    ftbl = [ptargets, tbl];
    rm = fitrm(ftbl, 't9-t35 ~ Class', 'withindesign', rmtime);
    ranovatbl = ranova(rm);
    anovatbl = anova(rm);
    m = mauchly(rm);

    if table2array(m(1, 4)) < 0.05
        array_out(feature, 2) = table2array(ranovatbl(2, 8));
    else
        array_out(feature, 2) = table2array(ranovatbl(2, 5));
    end
    array_out(feature, 1) = table2array(anovatbl(2, 7));

end

end
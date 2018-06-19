function papr = papr(signal)
    peak=max(abs(signal));
    disp(peak);
    average=sum(abs(signal))/length(signal);
    papr=average/peak;
endfunction
function papr = papr(signal)
    peak=max(abs(signal));
    average=sum(abs(signal))/length(signal);
    papr=average/peak;
endfunction

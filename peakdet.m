function [Maxtab, Mintab] = peakdet(v,delta,thresh,x)

  Maxtab=[];
  Mintab=[];
  maxtab=[];
  mintab=[];
  mn=[];
  mx=[];
  mnpos=[];
  mxpos=[];
  mn,mx=v(1),v(1);
  mnpos, mxpos= NaN, NaN;
  
  lookformax = 1;
    
    for i = 2:length(v)
        this = v(i);
        if (this>thresh && v(i-1)<thresh)
            maxwidth = x(i-1);
        end
        if (this <-thresh && v(i-1) > -thresh)
            minwidth = x(i-1);
        end
        if this > mx
            mx = this;
            mxpos = x(i);
        end
        if this < mn
            mn = this;
            mnpos = x(i);
        end
        if lookformax
            if (this < mx-delta)
                if ~((mx<abs(thresh)) | isnan(mxpos))
                    maxtab=[mxpos, mx,2*(mxpos-maxwidth)];
                    Maxtab=[Maxtab;maxtab];
                end
                mn = this;
                mnpos = x(i);
                lookformax = 0;
            end
        else
            if (this > mn+delta)
                if ~((mn>-abs(thresh)) | isnan(mnpos))
                    mintab=[mnpos, mn, 2*(mnpos-minwidth)];
                    Mintab=[Mintab;mintab];
                end
                mx = this;
                mxpos = x(i);
                lookformax = 1;
            end
        end
    if (size(Mintab)(1)==0)
        Mintab=zeros([1,3]);
    end
    if size(Maxtab)(1)==0
        Maxtab= zeros(1,3);     
    end
end
disp(Maxtab)
endfunction
x=linspace(0,999,1000);
series=file();
orig=series;

#Defining the parameters
t=linspace(0,length(series)-1,length(series));

t_papr=8;
thresh=(10**(t_papr/10))*sum(abs(series))/length(series); #Threshold value

delta=0.0; #
clip_stages=1;  #No. of blocks
len=length(t);
slength=511;
PCU=2;

n=length(t)/len;

out=[];
out=[out,papr(orig)];
k=0; #

#------PC-CFR block starts----------
for it = 0:(clip_stages)-1
    cancellation=zeros(length(t),1);
    pos=[];
    amp=[];
    for w = 0:(n)-1

        if w==n-1
            tprime=t(w*(len)+1:(w+1)*(len));
            wseries=series(w*(len)+1:(w+1)*(len));

        else
            tprime=t(w*(len)+1:(w+1)*(len)+6);
            wseries=series(w*(len)+1:(w+1)*(len)+6);
        end
        [maxtab, mintab] = peakdet(wseries,delta,thresh,tprime);
        
        maxtab(:,2)=maxtab(:,2)-thresh;
        mintab(:,2)=mintab(:,2)+thresh;
        maxtab=maxtab(2:end,:)
        mintab=mintab(2:end,:)
   ###  ii=(maxtab(:,1)<0);
   ###  maxtab = delete(maxtab, ii, axis=0)
   ###  ii=(mintab(:,1)>0)
   ###  mintab = delete(mintab, ii, axis=0)
        peaks=[(maxtab);(mintab)]
        # print (peaks)
        # print (('Sorted'),peaks)
        wcancel=zeros(length(t),1);
        mm=[];
        nn=[];
        mm=size(peaks)(1)

        for i = 1:(mm)
            if mm>PCU
                if i<=PCU
                    neg_len=slength;
                    disp(i)
                    if (peaks(i+PCU,1)-peaks(i,1)) < PCU*slength
                        pos_len=(peaks(i+PCU,1)-peaks(i,1))/PCU;
                    else
                        pos_len=slength;
                    end
                
                elseif i>=mm-PCU+1
                    pos_len=slength;
                    if (peaks(i,1)-peaks(i-PCU,1))<PCU*slength
                        neg_len=(peaks(i,1)-peaks(i-PCU,1))/PCU;
                    else
                        neg_length=slength;
                    end
                else
                    if (peaks(i+PCU,1)-peaks(i,1)) < PCU*slength
                        pos_len=(peaks(i+PCU,1)-peaks(i,1))/PCU;
                    else
                        pos_len=slength;
                    end
                    if (peaks(i,1)-peaks(i-PCU,1)) < PCU*slength
                        neg_len=(peaks(i,1)-peaks(i-PCU,1))/PCU;
                    else
                        neg_length=slength;
                    end
                 end
            else
                neg_len=slength;
                pos_len=slength;
            end
            pos=peaks(i,1);
            amp=peaks(i,2);
            width=peaks(i,3);
            # print (neg_len,pos_len)
            # print(pos,amp,int(neg_len),int(pos_len))
            can=f_can(t,pos,amp,(neg_len),(pos_len),width);
            wcancel=wcancel+(can);
        end
        cancellation+=wcancel;
    end

    low_papr=series-cancellation;
    series=(low_papr);
    # Printing Results
    #print (('Original Papr'), 10*log10(papr(orig(5:-5))))
    #print (('Obtained Papr'), 10*log10(papr(low_papr(5:-5))))
    #out.append(papr(low_papr(5:-5)))
    #-----------------
#--------PC-CFR Block Ends Here-----------
end

# #Plotting the final result
plot(t,orig)
hold on
# plot(t,cancellation+thresh)
plot(t,abs(low_papr),'r')
line([t(1),t(end)], [thresh,thresh])
hold on
#xlim([117800 118800])
# plot(t,-a,color='green',linestyle='--',dashes=(5,3))
title('Crest Factor Reduction')
#plot(linspace(t(0),t(-1),n+1),zeros(int(n)+1),'r+')

pause(waitforbuttonpress)
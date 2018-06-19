function oout = f_can(t,pos,amp,nlen,plen,wid)
    nlen=abs(nlen);
    plen=abs(plen);
    oout=zeros(length(t),1);

    if pos-nlen<0
      nlen=pos-1;
    end
    if plen+pos>length(oout)
      plen=length(oout)-pos;
    end
    tslice=t((pos)-nlen+1:(pos)+plen-1);
    oout((pos)-nlen+1:(pos)+plen-1)=amp*(sinc((pi)*(tslice-pos)/(3*wid)));
%将单个脉冲x组成脉冲序列，脉冲循环频率fc
%Murphy 20180911
function w=mypulse(x,fs,fc)
%x是单个脉冲，fs为采样频率，tc为截止时间，fc为脉冲循环频率,若为0，则随机脉冲分布,若为负，则表示随机脉冲的个数
tc=(length(x)-1)/fs;
k=1;w=x;iw=0;
deta=0;
if fc>0
    deta=round(1/fc*fs);
    while (k/fc)<tc
        w=w+circshift(x,k*deta);
        k=k+1;
    end
else
    if fc==0
        fc=round(rand(1)*4+1);
    end
    for i=1:abs(fc)
        deta=round(length(x)/abs(fc)*rand(1)*2)+deta;
        iw=iw+circshift(x,deta);
    end
 w=iw;
end
end
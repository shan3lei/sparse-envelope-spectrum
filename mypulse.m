%����������x����������У�����ѭ��Ƶ��fc
%Murphy 20180911
function w=mypulse(x,fs,fc)
%x�ǵ������壬fsΪ����Ƶ�ʣ�tcΪ��ֹʱ�䣬fcΪ����ѭ��Ƶ��,��Ϊ0�����������ֲ�,��Ϊ�������ʾ�������ĸ���
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
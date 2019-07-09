function A=myfft(y0,fs,t,f,toge,str)
%函数返回傅里叶变换后的Amplitude
%y0为输入信号或者Wave，fs为采样Frequency，t,f分别为是否显示波形，0不显示，1显示;
%toge是否将时域及频谱显示在一张图内
%y0 fs必须输入，其余不输入默认为0
%2017/11/16 山磊
if nargin<2
   disp('Input numbers should be bigger than 2,original signal and fs are necessary');
elseif nargin==2
    t=0;f=0;toge=0;str='';
elseif nargin==3
    f=0;toge=0; str='';
elseif nargin==4
    toge=0; str='';
elseif nargin==5
    str='';
end
if t*f==0
    toge=0;
end
[a,b]=size(y0);
 if (a==1)||(b==1)
     y=y0;
 else
     if(a>b)
         y=y0(:,2);
     else
         y=y0(2,:);
     end
 end
 
 
N=length(y);
ti=0:1/fs:(N-1)/fs;
temp=fft(y,N);
A=abs(temp)/(N/2);
A(1)=A(1)/2;A(1)=0;
ff=(0:N-1)/N*fs;


if toge==0
   if t==1
      figure;
      plot(ti,y); 
      xlabel('Time');
      ylabel('Amplitude');
      title([str,'Wave']);
%       axis off
   end
  if f==1
      figure;
      plot(ff(1:floor(N/2)),A(1:floor(N/2)));
      xlabel('Frequency');
      ylabel('Amplitude');
      title([str,'Spectrum']);
      axis([0,fs/2,0,inf]);
%       axis off
  end
else
    figure;
    subplot(2,1,1);
      plot(ti,y); 
      xlabel('Time');
      ylabel('Amplitude');
      subplot(2,1,2);
      plot(ff(1:floor(N/2)),A(1:floor(N/2)));
      xlabel('Frequency');
      ylabel('Amplitude');
      title([str,'Spectrum']);
      axis([0,fs/2,0,inf]);
end
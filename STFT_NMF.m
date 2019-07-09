% this code is programmed for sparse envelope spectrum. if you use it
% ,please cite 
% "L. Liang, L. Shan, F. Liu, B. Niu, G. Xu, Sparse Envelope  Spectra
% for Feature Extraction of Bearing Faults Based on NMF[J]. Applied
% Science-basel. 2019, 9(4): 755."
% Just for testing, do not contact with me if any questions.
% 此程序用于验证论文stft和NMF进行信号提取
% ShanLei(Murphy,仝智) 20180911 
clear;clc
close all


n=3;%NMF分解维数

% 下面是一些具体的字体设置，没有实际意义，可以删除
set(0,'DefaultTextFontName','Palatino Linotype'); 
set(0,'DefaultTextFontSize',10); 
set(0,'DefaultAxesFontName','Palatino Linotype'); 
set(0,'DefaultAxesFontSize',10);

% 这部分是选择数据的，是为了我选择数据方便，可以自己修改
string='仿真数据 or 真实数据';
cbutton = questdlg(string,'数据选择','仿真数据','真实数据','真实数据');
switch cbutton
    case '真实数据'
        %CYM PAPER 数据
        data=slgetfile();xmax=900;
        y=data(1:4096)';
        y=y-mean(y);
        N=length(y);
        L=N;fs=5120;
        yfft=myfft(y,fs,1,1,0,'West');
        time=[0:L-1]*(1/fs);
        frequency=[0:L/2-1]*fs/L;
        [~,temp_ord]=max(abs(yfft));
        fh=142.9;fc=frequency(temp_ord);
        
        % %梁sir给的数据(太明显)
        % data=slgetfile();
        %         y=data(1:4096,1)';
        %         y=y-mean(y);
        %         N=length(y);
        %         L=N;fs=4e4;
        %         yfft=myfft(y,fs,1,1,0,'Liang ');
        %         time=[0:L-1]*(1/fs);
        %         frequency=[0:L/2-1]*fs/L;
        %         [~,temp_ord]=max(abs(yfft));
        %         n=3;fh=236.4;fc=frequency(temp_ord);
        %
        
        
        %西储大学数据  (太明显)
        %         filename='313.mat';
        %         tempdata=load(filename);
        %         let1=['tempdata.X',filename(1:3),'_DE_time'];
        %         let2=['tempdata.X',filename(1:3),'RPM'];
        %         tempsignal=eval(let1);
        %         y=tempsignal(1:4096)';
        %         fs=12000;
        %         yfft=myfft(y,fs,1,1,0,'Experiment ');
        %         N=length(y);
        %         L=N;
        %         time=[0:L-1]*(1/fs);
        %         frequency=[0:L/2-1]*fs/L;
        %         [~,temp_ord]=max(abs(yfft));
        %         n=3;fc=frequency(temp_ord);
        %         if filename(1)=='1';
        %             fh=eval(let2)/60*3.5848;
        %         else
        %             fh=eval(let2)/60*3.053;
        %         end
    otherwise
        
        fs=10240;fh=80;N=4096;%原始信号参数
        fc=2200;xmax=600;
        snr=0;%信噪比
        
        t = 0 :1/fs : (N-1)/fs;
        c2button=questdlg('数据选择','DLG2','导入','重生','导入');
        switch c2button
            case '导入'
                ytemp=load('./仿真信号/simlated_signal snr0 end');
                y0=ytemp.y0;
                y=awgn(y0,snr);
            otherwise
                
                w0 = gauspuls(t,fc,0.25);
                % w0=0.8*exp(-500*t).*sin(2*pi*2200*t)
                yc=mypulse(w0,fs,fh);
                myfft(yc,fs,1,1,1,'Feature Signal ');
%                 w1=2*rand(1)*gauspuls(t,3000,0.3);
                w1=2*gauspuls(t,2600,0.3);
                w2=5*gauspuls(t,1000,0.1);
                w3=5*gauspuls(t,3000,0.1);
                yc1=mypulse(w1,fs,-2);
                yc2=mypulse(w2,fs,-1);
                yc3=mypulse(w3,fs,-2);
                y0=yc+yc2+yc1+yc3;
                
                y=awgn(y0,snr);
%                 y=y+0.2*sin(40*pi*t);
                y=y-mean(y);
                
        end

        N=length(y);
        L=N;
        time=[0:L-1]*(1/fs);
        frequency=[0:L/2-1]*fs/L;
        
        ff=myfft(y,fs,1,1,1,'Original Signal ');
        BF=fir1(10,0.7,'low'); % for noise low pass filtering
end


% 下面是用的tftb生成时频谱
% y=y';
set(figure(2),'position', [0,550   560   420]);
hh=tftb_window(123,'hanning');%63,123
% hh=tftb_window(33,'Gauss',0.005);%63为窗宽
S=tfrstft(y',1:N,L,hh);
tfr=abs(S);
figure;
imagesc(time,frequency,tfr(1:L/2,:));
set(gca,'YDir','normal');
set(gca,'yaxislocation','right');
title('Original Signal STFT');
xlabel('Time/ s');
ylabel('Frequency/ Hz');


% 这里是对时频谱进行nmf分解，可以更改这里的算法
[w,h]=nmf(tfr(1:L/2,:),n);%台湾KIM的函数,fast,负数置零。
% [w,h] = nmfsc( tfr(1:L/2,:), n, [0], [0.5], 'teat', 1 );
% [w,h,Ww,TEMP]=KNMfcU_CYM(tfr,n,'Linear',[0.5],fc);%陈师兄的函数
% [w,h]=seminmfnnls(S(1:L/2,:),n);
% w=abs(w);h=abs(h);

figure('Name','NMF分解的时域信号');
for i=1:n
    subplot(n,1,i);
    plot(time,h(i,:))
    xlabel('Time/ s');
end

M=zeros(n,1);
figure('Name','NMF分解的频域信号');
for i=1:n
    sub=subplot(1,n,i);
    plot(w(:,i),frequency);
    ylabel('Frequency/ Hz');
    set(sub, 'ButtonDownFcn',{@myBtnDwnCallback,i});
    [~,M(i)]=max(w(:,i));
end
set(figure(5),'position', [0,50   560   420]);

ff=frequency(M);


while true
    [~,fig_ord]=min(abs(ff-fc));
    qstring=['将自动选择第',num2str(fig_ord),'个作为分析对象'];
    button = questdlg(qstring,'维度选择','手动输入','重算','确认','确认');
    switch button
        case '手动输入'
            disp('自动读取失败，请手动输入');
            fig_ord=input('which one is the cyclic pulse signal ?\n');
            break;
        case '重算'
            close 'NMF分解的频域信号'
            close 'NMF分解的时域信号'
            [w,h]=  nmf(tfr(1:L/2,:),n);%台湾KIM的函数,fast,负数置零。
            % [w,h,Ww,TEMP]=KNMfcU_CYM(tfr,n,'Linear',[0.5],fc);%陈师兄的函数
            % [w,h]=seminmfnnls(S(1:L/2,:),n);
            w=abs(w);h=abs(h);
            
            figure('Name','NMF分解的时域信号');
            for i=1:n
                subplot(n,1,i);
                plot(time,h(i,:))
                xlabel('Time/ s');
            end
            
            M=zeros(n,1);
            figure('Name','NMF分解的频域信号');
            for i=1:n
                sub=subplot(1,n,i);
                plot(w(:,i),frequency);
                ylabel('Frequency/ Hz');
                set(sub, 'ButtonDownFcn',{@myBtnDwnCallback,i});
                [~,M(i)]=max(w(:,i));
            end
        otherwise
            break;
    end
end
disp(['***********已选择第',num2str(fig_ord),'个作为分析对象***********']);



% 下面是主体的分析过程，不在这里详述
f_direct=myfft(h(fig_ord,:),fs);
figure;plot(frequency*1,f_direct(1:end/2));title('Direct Spectrum');xlabel('Frequency/ Hz');ylabel('Amplitude');axis([0,xmax,0,inf])
% title('直接对循环信号进行FFT');

% [acf,lags]=autocorr(h(fig_ord,:),L-1);
% myfft(acf,fs,1,1,0,'AutoCorr');
% figure(8);axis([0,xmax,0,inf]);

f_orginal=fft(y)*2/N;
w_filter=abs([w(:,fig_ord);flipud(w(:,fig_ord))]);
w_filter=mapminmax(w_filter',0,1);
fx=f_orginal'.*w_filter';
x_filter=ifft(fx)*N/2;

figure;plot(frequency,abs(fx(1:end/2)));title('Spectrum after filtering');xlabel('Frequency/ Hz');ylabel('Amplitude')
figure;plot(time,x_filter);title('Wave after filtering');xlabel('Time/ s');ylabel('Amplitude')


hx=abs(hilbert(x_filter));
hxfft=myfft(hx,fs,1,0,0,'Envelop ');
figure;plot(frequency*1,hxfft(1:end/2));title('Envelop spectrum');xlabel('Frequency/ Hz');axis([0,xmax,0,inf])

%w,h联合起来
comb_f=(f_direct).^2.*(hxfft').^2;
figure;plot(frequency*1,abs(comb_f(1:end/2)));title('combine filter and direct');axis([0,xmax,0,inf]);xlabel('Frequency/ Hz');
drawnow;

% figure;plot(frequency,hxfft(1:end/2).^2);title('filter band');axis([0,150,0,inf])
% figure;plot(frequency,f_direct(1:end/2).^2);title('DIrect fft h');axis([0,150,0,inf])
% hold on;plot([fh,fh],[0,1.2*max(abs(comb_f(1:end/2)))],'r');
% text(fh,0,num2str(fh));
% set(figure(6),'Position',[0,580,560,420]);
% set(figure(8),'Position',[580,580,560,420]);
% set(figure(12),'Position',[0,100,560,420]);
% set(figure(13),'Position',[580,100,560,420]);.


% save('stftnmfdata.mat');

function analyse(fig_ord_t)
% load stftnmfdata

n=evalin('base','n');
fs=evalin('base','fs');
y=evalin('base','y');
h=evalin('base','h');
N=evalin('base','N');
w=evalin('base','w');
time=evalin('base','time');
xmax=evalin('base','xmax');
frequency=evalin('base','frequency');
fig_ord=fig_ord_t;

disp(['***********已选择第',num2str(fig_ord),'个作为分析对象***********']);
f_direct=myfft(h(fig_ord,:),fs);
figure;plot(frequency*1,f_direct(1:end/2));title('Direct Spectrum');xlabel('Frequency/ Hz');ylabel('Amplitude');axis([0,xmax,0,inf])
% title('直接对循环信号进行FFT');
f_orginal=fft(y)*2/N;
w_filter=w(:,fig_ord);%[w(:,fig_ord);flipud(w(:,fig_ord))];
w_filter=mapminmax(w_filter',0,1);
fx=f_orginal(1:end/2)'.*w_filter';%利用NMF滤波以后的频谱信号
x_filter=ifft([fx;flipud(fx)]);
figure;plot(frequency,fx);title('Spectrum after filtering');xlabel('Frequency/ Hz');ylabel('Amplitude')
figure;plot(time,x_filter);title('Wave after filtering');xlabel('Time/ s');ylabel('Amplitude')
hx=abs(hilbert(x_filter));
hxfft=myfft(hx,fs,1,0,0,'Envelop ');
figure;plot(frequency*1,hxfft(1:end/2));title('Envelop spectrum');xlabel('Frequency/ Hz');axis([0,xmax,0,inf])
%w,h联合起来
comb_f=(f_direct).^2.*(hxfft').^2;
figure;plot(frequency*1,abs(comb_f(1:end/2)));title('combine filter and direct');axis([0,xmax,0,inf]);xlabel('Frequency/ Hz');
% figure;plot(frequency,hxfft(1:end/2).^2);title('filter band');axis([0,150,0,inf])
% figure;plot(frequency,f_direct(1:end/2).^2);title('DIrect fft h');axis([0,150,0,inf])
% hold on;plot([fh,fh],[0,1.2*max(abs(comb_f(1:end/2)))],'r');
% text(fh,0,num2str(fh));
clear fig_ord_t
save('stftnmfdata.mat');
end


function myBtnDwnCallback(hObject,~,i)
h=gca;f=gcf;cc=[0.00,0.45,0.74];
set(f.Children(1).Children,'Color',cc);
set(f.Children(2).Children,'Color',cc);
set(f.Children(3).Children,'Color',cc);
set(h.Children,'Color','r')

global zt

if zt==i
    warndlg('已是当前分析对象');
else
    zt=i;
    for j=6:11
        close(figure(j));
        
    end
    analyse(i);
    
    
end

end

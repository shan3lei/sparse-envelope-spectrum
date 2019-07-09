% this code is programmed for sparse envelope spectrum. if you use it
% ,please cite 
% "L. Liang, L. Shan, F. Liu, B. Niu, G. Xu, Sparse Envelope  Spectra
% for Feature Extraction of Bearing Faults Based on NMF[J]. Applied
% Science-basel. 2019, 9(4): 755."
% Just for testing, do not contact with me if any questions.
% �˳���������֤����stft��NMF�����ź���ȡ
% ShanLei(Murphy,����) 20180911 
clear;clc
close all


n=3;%NMF�ֽ�ά��

% ������һЩ������������ã�û��ʵ�����壬����ɾ��
set(0,'DefaultTextFontName','Palatino Linotype'); 
set(0,'DefaultTextFontSize',10); 
set(0,'DefaultAxesFontName','Palatino Linotype'); 
set(0,'DefaultAxesFontSize',10);

% �ⲿ����ѡ�����ݵģ���Ϊ����ѡ�����ݷ��㣬�����Լ��޸�
string='�������� or ��ʵ����';
cbutton = questdlg(string,'����ѡ��','��������','��ʵ����','��ʵ����');
switch cbutton
    case '��ʵ����'
        %CYM PAPER ����
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
        
        % %��sir��������(̫����)
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
        
        
        %������ѧ����  (̫����)
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
        
        fs=10240;fh=80;N=4096;%ԭʼ�źŲ���
        fc=2200;xmax=600;
        snr=0;%�����
        
        t = 0 :1/fs : (N-1)/fs;
        c2button=questdlg('����ѡ��','DLG2','����','����','����');
        switch c2button
            case '����'
                ytemp=load('./�����ź�/simlated_signal snr0 end');
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


% �������õ�tftb����ʱƵ��
% y=y';
set(figure(2),'position', [0,550   560   420]);
hh=tftb_window(123,'hanning');%63,123
% hh=tftb_window(33,'Gauss',0.005);%63Ϊ����
S=tfrstft(y',1:N,L,hh);
tfr=abs(S);
figure;
imagesc(time,frequency,tfr(1:L/2,:));
set(gca,'YDir','normal');
set(gca,'yaxislocation','right');
title('Original Signal STFT');
xlabel('Time/ s');
ylabel('Frequency/ Hz');


% �����Ƕ�ʱƵ�׽���nmf�ֽ⣬���Ը���������㷨
[w,h]=nmf(tfr(1:L/2,:),n);%̨��KIM�ĺ���,fast,�������㡣
% [w,h] = nmfsc( tfr(1:L/2,:), n, [0], [0.5], 'teat', 1 );
% [w,h,Ww,TEMP]=KNMfcU_CYM(tfr,n,'Linear',[0.5],fc);%��ʦ�ֵĺ���
% [w,h]=seminmfnnls(S(1:L/2,:),n);
% w=abs(w);h=abs(h);

figure('Name','NMF�ֽ��ʱ���ź�');
for i=1:n
    subplot(n,1,i);
    plot(time,h(i,:))
    xlabel('Time/ s');
end

M=zeros(n,1);
figure('Name','NMF�ֽ��Ƶ���ź�');
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
    qstring=['���Զ�ѡ���',num2str(fig_ord),'����Ϊ��������'];
    button = questdlg(qstring,'ά��ѡ��','�ֶ�����','����','ȷ��','ȷ��');
    switch button
        case '�ֶ�����'
            disp('�Զ���ȡʧ�ܣ����ֶ�����');
            fig_ord=input('which one is the cyclic pulse signal ?\n');
            break;
        case '����'
            close 'NMF�ֽ��Ƶ���ź�'
            close 'NMF�ֽ��ʱ���ź�'
            [w,h]=  nmf(tfr(1:L/2,:),n);%̨��KIM�ĺ���,fast,�������㡣
            % [w,h,Ww,TEMP]=KNMfcU_CYM(tfr,n,'Linear',[0.5],fc);%��ʦ�ֵĺ���
            % [w,h]=seminmfnnls(S(1:L/2,:),n);
            w=abs(w);h=abs(h);
            
            figure('Name','NMF�ֽ��ʱ���ź�');
            for i=1:n
                subplot(n,1,i);
                plot(time,h(i,:))
                xlabel('Time/ s');
            end
            
            M=zeros(n,1);
            figure('Name','NMF�ֽ��Ƶ���ź�');
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
disp(['***********��ѡ���',num2str(fig_ord),'����Ϊ��������***********']);



% ����������ķ������̣�������������
f_direct=myfft(h(fig_ord,:),fs);
figure;plot(frequency*1,f_direct(1:end/2));title('Direct Spectrum');xlabel('Frequency/ Hz');ylabel('Amplitude');axis([0,xmax,0,inf])
% title('ֱ�Ӷ�ѭ���źŽ���FFT');

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

%w,h��������
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

disp(['***********��ѡ���',num2str(fig_ord),'����Ϊ��������***********']);
f_direct=myfft(h(fig_ord,:),fs);
figure;plot(frequency*1,f_direct(1:end/2));title('Direct Spectrum');xlabel('Frequency/ Hz');ylabel('Amplitude');axis([0,xmax,0,inf])
% title('ֱ�Ӷ�ѭ���źŽ���FFT');
f_orginal=fft(y)*2/N;
w_filter=w(:,fig_ord);%[w(:,fig_ord);flipud(w(:,fig_ord))];
w_filter=mapminmax(w_filter',0,1);
fx=f_orginal(1:end/2)'.*w_filter';%����NMF�˲��Ժ��Ƶ���ź�
x_filter=ifft([fx;flipud(fx)]);
figure;plot(frequency,fx);title('Spectrum after filtering');xlabel('Frequency/ Hz');ylabel('Amplitude')
figure;plot(time,x_filter);title('Wave after filtering');xlabel('Time/ s');ylabel('Amplitude')
hx=abs(hilbert(x_filter));
hxfft=myfft(hx,fs,1,0,0,'Envelop ');
figure;plot(frequency*1,hxfft(1:end/2));title('Envelop spectrum');xlabel('Frequency/ Hz');axis([0,xmax,0,inf])
%w,h��������
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
    warndlg('���ǵ�ǰ��������');
else
    zt=i;
    for j=6:11
        close(figure(j));
        
    end
    analyse(i);
    
    
end

end

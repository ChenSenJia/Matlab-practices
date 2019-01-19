[s,fs]=audioread('春夏秋冬.wav');                    %读取音频信号
%sound(s,fs);                                        %试听原音频信号
Ts=1/fs;                                             %采样周期
M=length(s);                                         %音频信号长度
m=0:M-1;
f=[0:M/2]*fs/M;
S=fft(s);
magS=abs(S);                                        %计算原始信号的频谱
%绘制滤波后信号的时域和频域图
figure;
subplot(2,1,1);plot(m,s);
xlabel('Number of samples');ylabel('Sample value s(n)');grid;
subplot(2,1,2);semilogx(f,magS(1:M/2+1));
xlabel('Frequency(Hz)');ylabel('Amplitude|S(f)|');grid;

%对信号加入高频噪声
k=0.9*sin(5000*m)+0.2*sin(4500*m)+0.5*sin(3000*m);  
v=[k',k'];                                           %产生高频噪声(双声道)
x=s+v;                                               %加入高频噪声
%sound(x,fs)                                         %试听加入噪声的音频信号
audiowrite('春夏秋冬(加高频噪声).wav',x,fs)           %保存音频
X=fft(x);
magX=abs(X);                                         %计算受噪声污染的信号的频谱
%绘制受到污染信号的时域和频域图
figure;
subplot(2,1,1);plot(m,x);
xlabel('Number of samples');ylabel('Sample value x(n)');grid;
subplot(2,1,2);semilogx(f,magX(1:M/2+1));
xlabel('Frequency(Hz)');ylabel('Amplitude|X(f)|');grid;

%基于Kaiser窗设计低通滤波器
As=54                                            %阻带衰减
wc=2*pi*2000/fs;                                 %截止频率
wp=2*pi*1500/fs;                                 %通带截止频率
wst=2*pi*2500/fs;                                %阻带截止频率
N=ceil((As-7.95)/(2.258*(wst-wp))+1);            %滤波器长度
beta=0.1102*(As-8.7)                             %计算kaiser的beta参数
kaiserwin=kaiser(N,beta);                        
kwin=fir1(N-1,wc/pi,kaiserwin);                  %计算低通滤波器系数
[Kwin f1]=freqz(kwin,1,44100,fs);                %计算低通滤波器频率响应
magKwin=abs(Kwin);                               %计算幅频响应
phaKwin=angle(Kwin);                             %计算相频响应
phaKwin=180*unwrap(phaKwin)/pi;
nwin=0:N-1

figure;%绘制低通滤波器特性
title('滤波器特性')
subplot(3,1,1);stem(nwin,kwin);grid;
xlabel('n');ylabel('冲激响应');
subplot(3,1,2);semilogx(f1,20*log10(magKwin));grid;
xlabel('Frequency(Hz)');ylabel('幅度响应(dB)');
subplot(3,1,3);plot(f1,phaKwin);grid;
xlabel('Frequency(Hz)');ylabel('相位响应(degree)');


%信号经过滤波器
y=fftfilt(kwin,x);
Y=fft(y);
magY=abs(Y);                                    %计算滤波后信号的频谱
%sound(y,fs);                                   %试听滤波后的音频信号
audiowrite('春夏秋冬(滤波后).wav',y,fs)          %保存音频

%绘制滤波后信号的时域和频域图
figure;
subplot(2,1,1);plot(m,y);
xlabel('Number of samples');ylabel('Sample value y(n)');grid;
subplot(2,1,2);semilogx(f,magY(1:M/2+1));
xlabel('Frequency(Hz)');ylabel('Amplitude|Y(f)|');grid;
clc;



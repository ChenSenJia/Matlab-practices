[s,fs]=audioread('�����ﶬ.wav');                    %��ȡ��Ƶ�ź�
%sound(s,fs);                                        %����ԭ��Ƶ�ź�
Ts=1/fs;                                             %��������
M=length(s);                                         %��Ƶ�źų���
m=0:M-1;
f=[0:M/2]*fs/M;
S=fft(s);
magS=abs(S);                                        %����ԭʼ�źŵ�Ƶ��
%�����˲����źŵ�ʱ���Ƶ��ͼ
figure;
subplot(2,1,1);plot(m,s);
xlabel('Number of samples');ylabel('Sample value s(n)');grid;
subplot(2,1,2);semilogx(f,magS(1:M/2+1));
xlabel('Frequency(Hz)');ylabel('Amplitude|S(f)|');grid;

%���źż����Ƶ����
k=0.9*sin(5000*m)+0.2*sin(4500*m)+0.5*sin(3000*m);  
v=[k',k'];                                           %������Ƶ����(˫����)
x=s+v;                                               %�����Ƶ����
%sound(x,fs)                                         %����������������Ƶ�ź�
audiowrite('�����ﶬ(�Ӹ�Ƶ����).wav',x,fs)           %������Ƶ
X=fft(x);
magX=abs(X);                                         %������������Ⱦ���źŵ�Ƶ��
%�����ܵ���Ⱦ�źŵ�ʱ���Ƶ��ͼ
figure;
subplot(2,1,1);plot(m,x);
xlabel('Number of samples');ylabel('Sample value x(n)');grid;
subplot(2,1,2);semilogx(f,magX(1:M/2+1));
xlabel('Frequency(Hz)');ylabel('Amplitude|X(f)|');grid;

%����Kaiser����Ƶ�ͨ�˲���
As=54                                            %���˥��
wc=2*pi*2000/fs;                                 %��ֹƵ��
wp=2*pi*1500/fs;                                 %ͨ����ֹƵ��
wst=2*pi*2500/fs;                                %�����ֹƵ��
N=ceil((As-7.95)/(2.258*(wst-wp))+1);            %�˲�������
beta=0.1102*(As-8.7)                             %����kaiser��beta����
kaiserwin=kaiser(N,beta);                        
kwin=fir1(N-1,wc/pi,kaiserwin);                  %�����ͨ�˲���ϵ��
[Kwin f1]=freqz(kwin,1,44100,fs);                %�����ͨ�˲���Ƶ����Ӧ
magKwin=abs(Kwin);                               %�����Ƶ��Ӧ
phaKwin=angle(Kwin);                             %������Ƶ��Ӧ
phaKwin=180*unwrap(phaKwin)/pi;
nwin=0:N-1

figure;%���Ƶ�ͨ�˲�������
title('�˲�������')
subplot(3,1,1);stem(nwin,kwin);grid;
xlabel('n');ylabel('�弤��Ӧ');
subplot(3,1,2);semilogx(f1,20*log10(magKwin));grid;
xlabel('Frequency(Hz)');ylabel('������Ӧ(dB)');
subplot(3,1,3);plot(f1,phaKwin);grid;
xlabel('Frequency(Hz)');ylabel('��λ��Ӧ(degree)');


%�źž����˲���
y=fftfilt(kwin,x);
Y=fft(y);
magY=abs(Y);                                    %�����˲����źŵ�Ƶ��
%sound(y,fs);                                   %�����˲������Ƶ�ź�
audiowrite('�����ﶬ(�˲���).wav',y,fs)          %������Ƶ

%�����˲����źŵ�ʱ���Ƶ��ͼ
figure;
subplot(2,1,1);plot(m,y);
xlabel('Number of samples');ylabel('Sample value y(n)');grid;
subplot(2,1,2);semilogx(f,magY(1:M/2+1));
xlabel('Frequency(Hz)');ylabel('Amplitude|Y(f)|');grid;
clc;



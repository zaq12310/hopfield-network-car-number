%%
clear;
close all;
clc;

%% �Զ�������ʾ���ȡͼ��
[filename,filepath] = uigetfile('.jpg', '����һ����Ҫʶ���ͼ��');
file = strcat(filepath, filename);
img = imread(file);
figure;
imshow(img);
title('����ͼ��');

%% ͼ��Ԥ����
import_1(img)

%% �����ַ�ʶ��
load('net.mat')
liccode=char(['0':'9' 'A':'Z' '��������³��']);%�����Զ�ʶ���ַ������'������۰ļ���³ԥ������������ո���������̨�¸��ƴ���ڲ��ɹ�����'
% ��ţ�0-9�ֱ�Ϊ 1-10;A-Z�ֱ�Ϊ 11-36;
% ��  ��  ��  ��  ��  ��  ��  ��  ³  ԥ  ��  ��  ��  ��  ��  ��  ��
% ��  ��  ��  ��  ��  ̨  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��  ��
% 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
% 60 61 62 63 64 65 66 67 68 69 70
subBw2 = zeros(800, 1);
num = 1;   % ����λ��
for i = 1:7
    ii = int2str(i);    % ����������ת��Ϊ�ַ���������
    word = imread([ii,'.jpg']); % ��ȡ֮ǰ�ָ�����ַ���ͼƬ
    segBw2 = imresize(word, [40,20], 'nearest');    % ����ͼƬ�Ĵ�С
    segBw2 = im2bw(segBw2, 0.5);    % ͼ���ֵ��
    %40x20�ľ���
    T=reshape(segBw2,800,1);
    %%**********�������
    y=sim(net,1,[],T);
    if i == 1   % �ַ���һλΪ���֣���λ���������ֶ�
        kMin = 37;
        kMax = 42;
    elseif i>1&&i<=4   % �ڶ�λΪӢ����ĸ����λ��ĸ�����ֶ�
        kMin = 11;
        kMax = 36;
    elseif i >= 5   % ����λ��ʼ���������ˣ���λ���������ֶ�
        kMin = 1;
        kMax = 10;
    end

    l=1;
    for k = kMin : kMax
        fname = strcat('�ַ�ģ��\',liccode(k),'.jpg');  % �����ַ����ҵ�ͼƬģ��
        samBw2 = imread(fname); % ��ȡģ����е�ͼƬ
        samBw2 = im2bw(samBw2, 0.5);    % ͼ���ֵ��
        samBw2=reshape(samBw2,800,1);
        % ������ʶ���ͼƬ��ģ��ͼƬ����
        for i1 = 1:800
            subBw2(i1) = y(i1) - samBw2(i1);
        end


       Dmax=sum(abs(subBw2));
        error(l) = Dmax;
        l=l+1;
    end

    % �ҵ�������ٵ�ͼ��
    errorMin = min(error);
    findc = find(error == errorMin);
    %     error
    %     findc

    % �����ֿ⣬��Ӧ��ʶ����ַ�
    Code(num*2 - 1) = liccode(findc(1) + kMin - 1);
    Code(num*2) = ' ';
    num = num + 1;


end

% ��ʾʶ����
disp(Code);
msgbox(Code,'ʶ����ĳ��ƺ�');
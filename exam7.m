%%
clear;
close all;
clc;

%% 自动弹出提示框读取图像
[filename,filepath] = uigetfile('.jpg', '输入一个需要识别的图像');
file = strcat(filepath, filename);
img = imread(file);
figure;
imshow(img);
title('车牌图像');

%% 图像预处理
import_1(img)

%% 进行字符识别
load('net.mat')
liccode=char(['0':'9' 'A':'Z' '京辽陕苏鲁浙']);%建立自动识别字符代码表；'京津沪渝港澳吉辽鲁豫冀鄂湘晋青皖苏赣浙闽粤琼台陕甘云川贵黑藏蒙桂新宁'
% 编号：0-9分别为 1-10;A-Z分别为 11-36;
% 京  津  沪  渝  港  澳  吉  辽  鲁  豫  冀  鄂  湘  晋  青  皖  苏
% 赣  浙  闽  粤  琼  台  陕  甘  云  川  贵  黑  藏  蒙  桂  新  宁
% 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
% 60 61 62 63 64 65 66 67 68 69 70
subBw2 = zeros(800, 1);
num = 1;   % 车牌位数
for i = 1:7
    ii = int2str(i);    % 将整型数据转换为字符串型数据
    word = imread([ii,'.jpg']); % 读取之前分割出的字符的图片
    segBw2 = imresize(word, [40,20], 'nearest');    % 调整图片的大小
    segBw2 = im2bw(segBw2, 0.5);    % 图像二值化
    %40x20的矩阵
    T=reshape(segBw2,800,1);
    %%**********网络仿真
    y=sim(net,1,[],T);
    if i == 1   % 字符第一位为汉字，定位汉字所在字段
        kMin = 37;
        kMax = 42;
    elseif i>1&&i<=4   % 第二位为英文字母，定位字母所在字段
        kMin = 11;
        kMax = 36;
    elseif i >= 5   % 第三位开始就是数字了，定位数字所在字段
        kMin = 1;
        kMax = 10;
    end

    l=1;
    for k = kMin : kMax
        fname = strcat('字符模板\',liccode(k),'.jpg');  % 根据字符库找到图片模板
        samBw2 = imread(fname); % 读取模板库中的图片
        samBw2 = im2bw(samBw2, 0.5);    % 图像二值化
        samBw2=reshape(samBw2,800,1);
        % 神经网络识别后图片与模板图片做差
        for i1 = 1:800
            subBw2(i1) = y(i1) - samBw2(i1);
        end


       Dmax=sum(abs(subBw2));
        error(l) = Dmax;
        l=l+1;
    end

    % 找到误差最少的图像
    errorMin = min(error);
    findc = find(error == errorMin);
    %     error
    %     findc

    % 根据字库，对应到识别的字符
    Code(num*2 - 1) = liccode(findc(1) + kMin - 1);
    Code(num*2) = ' ';
    num = num + 1;


end

% 显示识别结果
disp(Code);
msgbox(Code,'识别出的车牌号');
liccode=char(['0':'9' 'A':'Z' '京辽陕苏鲁浙']);%建立自动识别字符代码表；'京津沪渝港澳吉辽鲁豫冀鄂湘晋青皖苏赣浙闽粤琼台陕甘云川贵黑藏蒙桂新宁'
 % 编号：0-9分别为 1-10;A-Z分别为 11-36;
 % 京  津  沪  渝  港  澳  吉  辽  鲁  豫  冀  鄂  湘  晋  青  皖  苏
 % 赣  浙  闽  粤  琼  台  陕  甘  云  川  贵  黑  藏  蒙  桂  新  宁
 % 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 
 % 60 61 62 63 64 65 66 67 68 69 70
 T=zeros(800,42);
%hopfield网络
 for k = 1 : 42
        fname = strcat('字符模板\',liccode(k),'.jpg');  % 根据字符库找到图片模板
        samBw2 = imread(fname); % 读取模板库中的图片
        samBw2 = im2bw(samBw2, 0.5);    % 图像二值化
        samBw2=reshape(samBw2,800,1);
        T(:,k)=samBw2;
 end
net=newhop(T);

% T7=[0 0 0 0 0 1]';
% T5=[0 0 0 0 1 0]';
% T4=[0 0 0 1 0 0]';
% T9=[0 0 1 0 0 0]';
% 
% %每一列代表一个模板
% %形成总的目标向量
% T=[T7 T5 T4 T9];
% %设计hopfield网络
% net=newhop(T);
% %用加噪并且产生畸变的7作为测试对象
% T7=[0 1 0 0 0 1]';
% subplot(121);
% 
% %网络仿真
% y=sim(net,1,[],T7);
% %二值化

save 'net.mat' net

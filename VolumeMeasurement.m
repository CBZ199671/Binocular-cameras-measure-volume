%%
% ����ռ�
clc;
clear;
close all;
format rat;

%% ��������궨����
load stereoParams1.mat


% ��������Ŀ��ӻ�
% figure;
% showExtrinsics(stereoParams);

%% ��������
frameLeft = imread('left/left1.2.bmp'); 
frameRight = imread('right/right1.2.bmp');

[frameLeftRect, frameRightRect] = rectifyStereoImages(frameLeft, frameRight, stereoParams);

figure;
imshow(stereoAnaglyph(frameLeftRect, frameRightRect));
title('Rectified Frames');

%% �Ӳ����
frameLeftGray  = rgb2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);

% L = adapthisteq(frameLeftGray,'clipLimit',0.02,'Distribution','rayleigh');
% imshow(L);
% R = adapthisteq(frameRightGray,'clipLimit',0.02,'Distribution','rayleigh');
% imshow(R)
% Lb = medfilt2(L,[3,3]);
% imshow(Lb)
% Rb = medfilt2(R,[3,3]);
% imshow(Rb)

DisparityRange = [0, 16*20];
disparityMap = disparity(frameLeftGray, frameRightGray, 'Method','SemiGlobal','DisparityRange',DisparityRange,'BlockSize',19,'ContrastThreshold', 0.5,'UniquenessThreshold',1);

figure;
imshow(disparityMap, DisparityRange);
title('Disparity Map');
% colormap jet
% colorbar

%% ��ά�ؽ�
points3D = reconstructScene(disparityMap, stereoParams);
% ��λΪmm
points3D = points3D(:,400:1000, :);
ptCloud = pointCloud(points3D);
figure;
pcshow(ptCloud);
% title('Original Data');

%% �ռ�λ�ñ任
% ��������Ʊ仯Ϊ�������
ptCloudA= removeInvalidPoints(ptCloud);

% ����ת��
Temp(:, 1) = ptCloudA.Location(:, 1);
Temp(:, 2) = ptCloudA.Location(:, 2);
Temp(:, 3) = -ptCloudA.Location(:, 3) + 389;

% ȥ��λ�ò�����ĵ�
[i, j]=find(Temp(:, 3) < -5 | Temp(:, 3) > 180);
Temp(i, :) = [];

ptCloudB = pointCloud(Temp);

figure;
pcshow(ptCloudB);
title('Transform Data');

%% ȥ��
% ThresholdΪ��Ⱥֵ��ֵ����ֵΪ��ѡ���㵽�ھӵ�ľ���ֵ��һ����׼�����ָ������ֵ������Ϊ�õ����쳣ֵ��
ptCloudC = pcdenoise(ptCloudB, 'NumNeighbors', 200, 'Threshold', 1);   %1~6��ʵ��Threshold=1����7��Threshold=10

figure;
pcshow(ptCloudC);
% title('Denoised Data');

%% ���Ʒָ�
% maxDistance����һ���ڵ㵽ƽ�����ֵ��������
maxDistance = 10;
referenceVector = [0, 0, 1];
% ���ƽ��ķ��������Ͳο�����֮��������ԽǾ��룬�Զ�Ϊ��λָ��Ϊ����ֵ��
maxAngularDistance = 5;
[model, inlierIndices, outlierIndices] = pcfitplane(ptCloudC, maxDistance, referenceVector, maxAngularDistance);
ptCloudPlane = select(ptCloudC, inlierIndices);
ptCloudD = select(ptCloudC, outlierIndices);


figure;
pcshow(ptCloudC);
% title('Splitting1 Data');

hold on
plot(model);

figure;
pcshow(ptCloudD);
% title('Part1 Data');

figure;
pcshow(ptCloudPlane);
title('Part2 Data');

%% �ռ�λ��У��
ptCloudE = pcTransform(ptCloudD, model);

figure;
pcshow(ptCloudE);
title('Transform');

%% ��ֵ
x = ptCloudE.Location(:, 1);
y = ptCloudE.Location(:, 2);
z = ptCloudE.Location(:, 3);
x = double(x);
y = double(y);
z = double(z);

N = 500; %��ֵ����,�Լ�ȷ��,��д100
x_MAX = max(x);
x_MIN = min(x);
y_MAX = max(y);
y_MIN = min(y);
x0 = linspace(x_MAX, x_MIN, N);
y0 = linspace(y_MAX, y_MIN, N);
[X,Y,Z]=griddata(x, y, z, x0', y0, 'linear');   % ��ֵ�������.��Ȼ,������û��˵��xyƽ���ϵ�����,����������ϵ�����Z=f(X,Y)������x0,��y0�ľ��������ڣ�
Z(isnan(Z) == 1) = 0;

figure;
mesh(X, Y, Z);

%% �������
Heights = sum(sum(abs(Z)));
S = abs((y0(2) - y0(1)) * (x0(2) - x0(1)));
V = Heights * S     % ���


clc;
clear;
close all;

% Load image
I = imread('image.tif');
figure; imshow(I);
title('Original image');

% Encoding
file = fopen('cameraman.txt', 'w');
[r,c]=size(I);
pixels = r * c;
fwrite(file, c, 'uint16');
fwrite(file, r, 'uint16');
ptr = 1;
count = 0;
val = I(1, 1);
imgRow = reshape(I, 1, pixels);
data = uint8(zeros(1, 2*pixels));
for i = 1 : pixels
    if(imgRow(1,i) == val)
        count = count + 1;
    else
        data(1,ptr) = uint8(val);
        data(1,ptr+1) = uint8(count);
        ptr = ptr + 2;
        val = imgRow(1,i);
        count = 1;
    end
end
data(1,ptr) = uint8(val);
data(1,ptr+1) = uint8(count);
data = data(1,1:(ptr+1));
fwrite(file, data, 'uint8');
fclose(file);


% Decoding
file = fopen('cameraman.txt', 'r');
c1=fread(file, 1, 'uint16');
r1=fread(file, 1, 'uint16');
pixels1 = r1 * c1;
ptr1 = 1;
imgRow1 = uint8(zeros(1, pixels));
data = fread(file, [1 inf], 'uint8');
for i = 1 : 2 : length(data)
    val1 = data(1,i);
    count1 = data(1,i+1);
    imgRow1(1,ptr1:(ptr1+count1-1)) = val1 * ones(1,count1);
    ptr1 = ptr1 + count1;
end
img1 = reshape(imgRow1, c1, r1);
fclose(file);


figure; imshow(img1);
title('RLE image');
p= dir('cameraman.txt');






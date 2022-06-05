clc;
clear;
close all;

% Load image
I = imread('image8.tif');
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
s=p.bytes;
disp(s);
S=8*prod(size(I));
disp(S);
% S1=8*prod(size(img1));
% in = imfinfo('image8.tif');
% Compression_Ratio_1 =  (in.FileSize/length())*100;
% disp(Compression_Ratio_1);
% disp(in.FileSize);
% disp(length('cameraman.txt'));
% Compression_Ratio_1=(in.Width*in.Height*in.BitDepth/8)/length('cameraman.txt');
% info = whos('I');
% b = info.bytes;
% info1 = whos('img1');
% b1 = info1.bytes;
% disp(b);
% disp(b1);
% F=imsubtract(I,img1);
% figure; imshow(F);
% M1=immse(I,img1);
% 
% disp(M1);




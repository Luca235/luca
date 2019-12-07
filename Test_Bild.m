clear;
close all;
clc;


%% Statisches Bild 
% nur Radius betrachten
I = imread('test.png');
imageSize = size(I);
[centers,radii] = imfindcircles(I,[450 550],'ObjectPolarity','dark','Sensitivity',0.99,'Method','twostage');
viscircles(centers,radii);
ci = [centers(1,2), centers(1,1), radii];     % center and radius of circle ([c_row, c_col, r])
[xx,yy] = ndgrid((1:imageSize(1))-ci(1),(1:imageSize(2))-ci(2));
mask = uint8((xx.^2 + yy.^2)<ci(3)^2);
croppedImage = uint8(zeros(size(I)));
croppedImage(:,:,1) = I(:,:,1).*mask;
croppedImage(:,:,2) = I(:,:,2).*mask;
croppedImage(:,:,3) = I(:,:,3).*mask;
imshow(croppedImage);

% Bild zu grau und edgen
I_g = rgb2gray(croppedImage);
I_bin = getContours(I_g);
[H,T,R] = hough(I_bin);
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','white');
lines = houghlines(I_bin,T,R,P,'FillGap',2,'MinLength',300);
figure, imshow(I_bin), hold on
[centers,radii] = imfindcircles(I,[450 550],'ObjectPolarity','dark','Sensitivity',0.99,'Method','twostage');
viscircles(centers,radii);
max_len = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
   
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end
hold off
figure
imshow(croppedImage);



% Berechnung Schnittpunkt
m = (xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));    %Steigung m
n = (xy(1,2)*xy(2,1)-xy(2,2)*xy(1,1))/(xy(2,1)-xy(1,1)); %Schnittpunkt mit y-Achse n
pq_p = (-2*centers(1,1)+2*m*n-centers(1,2)*m)/(1+m^2)   %p
pq_q = (centers(1,1)^2+centers(1,2)^2+n^2-centers(1,2)*n-(radii)^2)/(1+m^2);
x_1 = -1/2 * pq_p + sqrt((1/2 * pq_p)^2 - pq_q)


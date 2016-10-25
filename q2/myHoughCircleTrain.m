function yourcellvar = myHoughCircleTrain(imBW,c,ptlist)
	imBW = im2double(imBW);
	gauss = fspecial('gaussian', 5 ,10);
	imBW = conv2(gauss,imBW);
	imBW = imBW(3:end-2,3:end-2);
	imshow(imBW);
	dx = [1 2 0  -2 -1; 2 4  0 -4 -2; 1 2 0 -2 -1];
	dy = dx'; 
	gradx = conv2(imBW,dx);
	grady = conv2(imBW,dy);
	grady = grady(3:end-2,2:end-1);
	gradx = gradx(2:end-1,3:end-2);
	mag = sqrt(gradx.^2 + grady.^2);
	gradx(gradx~=0) = gradx(gradx~=0)./mag(gradx~=0);
	grady(grady~=0) = grady(grady~=0)./mag(grady~=0);
	[a,b] = size(ptlist);
	yourcellvar = cell(1,b);
	for i = 1:b
		pt = ptlist{i};
		x = pt(1);
		y = pt(2);
		yourcellvar{i} = [gradx(x,y) grady(x,y);c(1)-x c(2)-y];
	end
end

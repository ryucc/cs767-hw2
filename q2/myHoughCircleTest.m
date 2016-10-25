function centers = myHoughCircleTrain(imBW,yourcellvar)
	imshow(imBW);
	centers = [];
	figure;
	% calculate gradient direction
	dims = size(size(imBW));
	if dims(2) > 2
		imBW = rgb2gray(imBW);
	end
	if strcmp(class(imBW),'double') == 0
		imBW = im2double(imBW);
	end
	
	gauss = fspecial('gaussian', 5 ,10);
	imBW = conv2(gauss,imBW);
	imBW = imBW(3:end-2,3:end-2);
	%dx = [1 2 0  -2 -1; 2 4  0 -4 -2; 1 2 0 -2 -1];
	dx = [1 0 -1;2 0 -2; 1 0 -1];
	dy = dx'; 
	gradx = conv2(imBW,dx);
	grady = conv2(imBW,dy);
	%grady = grady(3:end-2,2:end-1);
	%gradx = gradx(2:end-1,3:end-2);
	grady = grady(2:end-1,2:end-1);
	gradx = gradx(2:end-1,2:end-1);
	mag = sqrt(gradx.^2 + grady.^2);
	gradx(gradx~=0) = gradx(gradx~=0)./mag(gradx~=0);
	grady(grady~=0) = grady(grady~=0)./mag(grady~=0);

	[a,b] = size(yourcellvar);
	[n,m] = size(imBW);
	maxinner = -2*ones(size(imBW));
	votex = zeros(size(imBW));
	votey = zeros(size(imBW));
	for i = 1:b
		a = yourcellvar{i};
		grad = a(1,:);
		vote = a(2,:);
		curinner = gradx*grad(1) + grady*grad(2);
		ll = curinner > maxinner;
		maxinner(ll) = curinner(ll);
		votex(ll) = vote(1);
		votey(ll) = vote(2);
	end
	accum = zeros(size(imBW));
	for i = 1:n
		for j = 1:m
			for k = -1:1
				x = votex(i,j) + i;
				y = votey(i,j) + j;
				if x>1 && x < n && y>1 && y<m
					accum(x,y) = accum(x,y)+1;
				end
			end
		end
	end
	sorted = sort(accum(:));
	first = sorted(end);
	sec = sorted(end-1);
	[row col] = find(accum==first);
	[pts,temp] = size(row);
	sav = zeros(size(imBW));
	sav = imBW;
	
	if pts>1
		centers = [row(1) col(1);row(2) col(2)];
		sav(row(1),col(1)) = 1;
		sav(row(2),col(2)) = 1;
		imshow(sav);
	else
		centers = [row(1) col(1)];
		sav(row(1),col(1)) = 1;
		[row col] = find(accum==sec);
		sav(row(1),col(1)) = 1;
		centers = [centers;row(1) col(1)];
		imshow(sav);
	end
	
end

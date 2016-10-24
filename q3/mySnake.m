function imOut = mySnake(imIn,imInitial,alpha,beta)
	dims = size(size(imIn));
	grey = imIn;
	if dims(2) > 2
		grey = rgb2gray(imIn);
	end
	grey = im2double(grey);
	grad = -imgradient(grey);
	[m,n] = size(grad);
	pts = order(imInitial);
	[a,b] = size(pts);
	if a<5

	end



	

end

function pt = state(origin,state,m,n)
	i = mod(state-1,3);
	j = (state-1-i)/3;
	i = i-1;
	j = j-1;
	if i<1 || i>m
		i = 0;
	end
	if j<1 || j>n
		j = 0;
	end
	pt = origin + [i j];
end

% initial points in coordinates and in order
function pts = order(imInitial)
	[row,col] = find(imInitial);
	all_pts = [row col];
	ind = convhull(all_pts);
	ind(end) = [];
	pts = all_pts(ind,:);
end

% initial energy of first three points
function E = initialE(x,alpha,beta)
	E = alpha*(x(3,:)-x(2,:)).^2;
	E = E + alpha*(x(2,:)-x(1,:)).^2;
	E = E + beta*(x(3,:)-2*x(2,:)+x(1,:)).^2;
end

% new energy of adding a new point
function E = deltaE(x,alpha,beta)
	E = alpha*(x(3,:)-x(2,:)).^2;
	E = E + beta*(x(3,:)-2*x(2,:)+x(1,:)).^2;
end

% energy of first two points and last three points
function E = finalE(x,alpha,beta)
	E = alpha*(x(3,:)-x(2,:)).^2;
	E = E + beta*(x(3,:)-2*x(2,:)+x(1,:)).^2;
	E = E + alpha*(x(3,:)-x(4,:)).^2;
	E = E + beta*(x(5,:)-2*x(4,:)+x(3,:)).^2;
	E = E + beta*(x(4,:)-2*x(3,:)+x(2,:)).^2;
end

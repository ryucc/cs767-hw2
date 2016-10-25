function [imOut, parentx parenty] = activescissors(imIn)
	dims = size(size(imIn));
	grey = imIn;
	if dims(2) > 2
		grey = rgb2gray(imIn);
	end
	if strcmp(class(grey),'double') == 0
		grey = im2double(grey);
	end
	[m,n] = size(grey);
	dist = dists(grey);
	imshow(imIn);
	x = ginput();
	x = x(1,:);
	seed(1) = x(2);
	seed(2) = x(1);
	sup = Inf(1);
	dd = Inf(size(grey));
	parentx = sup*ones(size(grey));
	parenty = sup*ones(size(grey));
	visited = ones(size(grey));

	seed = uint16(seed)

	dd(seed(1),seed(2)) = 0;
	parentx(seed(1),seed(2)) = seed(1);
	parenty(seed(1),seed(2)) = seed(2);
	% shortest path
	% priority queue
	qx = [seed(1)];
	qy = [seed(2)];
	qd = [0];
	while ~isempty(qd)
		%find min distance
		mind = min(qd);
		ind = find(qd==mind);
		ind = ind(1);
		% pop elements out of queue
		x = qx(ind);
		y = qy(ind);
		cd = qd(ind);
		qx(ind) = [];
		qy(ind) = [];
		qd(ind) = [];
		visited(x,y) = 0;
		for i = -1:1
			for j = -1:1
				if i+x>0 && i+x <=m && j+y>0 && j+y<=n
					d = dist(x,y,3*(i+1)+j+2);
					if dd(x+i,y+j) > dd(x,y) + d
						dd(x+i,y+j) = dd(x,y) + d;
						qx = [qx x+i];
						qy = [qy y+j];
						qd = [qd dd(x,y)+d];
						parentx(x+i,y+j) = x;
						parenty(x+i,y+j) = y;
					end
				end
			end
		end
	end
	imOut = dd;
	while 1
		temp = imIn;
		x = ginput();
		x = x(1,:);
		y(2) = x(1);
		y(1) = x(2);
		x = uint16(y);
		while x(1)~=seed(1) || x(2)~=seed(2)
			x = uint16(x);
			temp(x(1),x(2),1) = 1.0;
			temp(x(1),x(2),2) = 1.0;
			temp(x(1),x(2),3) = 1.0;
			aa = parentx(x(1),x(2));
			bb = parenty(x(1),x(2));
			x = [aa bb];
		end
		x(1)
		x(2)
		seed(1)
		seed(2)
		imshow(temp);
	end
end

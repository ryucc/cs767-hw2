function out_points = mySnake(imIn,imInitial,alpha,beta)
	dims = size(size(imIn));
	grey = imIn;
	if dims(2) > 2
		grey = rgb2gray(imIn);
	end
	if strcmp(class(grey),'double') == 0
		grey = im2double(grey);
	end
	if strcmp(class(imIn),'double') == 0
		imIn = im2double(imIn);
	end
	imshow(imIn);
	[row, col] = find(imInitial);
	x = [row col];
	x = uint16(x);
	[outpts,energy] = mySnake1(grey,x,alpha,beta);
	[a,b] = size(outpts);
	disp(energy);
	imshow(imIn);
	for i = 1:a-1
		cur = outpts(i,:);
		nex = outpts(i+1,:);
		line([cur(2), nex(2)],[cur(1),nex(1)]);
		imIn(cur(1),cur(2),1) = 1;
		imIn(cur(1),cur(2),2) = 1;
		imIn(cur(1),cur(2),3) = 1;
	end
	cur = outpts(a,:);
		imIn(cur(1),cur(2),1) = 1;
		imIn(cur(1),cur(2),2) = 1;
		imIn(cur(1),cur(2),3) = 1;
	nex = outpts(1,:);
	line([cur(2), nex(2)],[cur(1),nex(1)]);

	for l = 1:15
		imshow(imIn);
		disp(l);
		[outpts,energy] = mySnake1(grey,outpts,alpha,beta);
		[a,b] = size(outpts);
		disp(energy);
		for i = 1:a-1
			cur = outpts(i,:);
		imIn(cur(1),cur(2),1) = 1;
		imIn(cur(1),cur(2),2) = 1;
		imIn(cur(1),cur(2),3) = 1;
			nex = outpts(i+1,:);
			line([cur(2), nex(2)],[cur(1),nex(1)]);
		end
		cur = outpts(a,:);
		imIn(cur(1),cur(2),1) = 1;
		imIn(cur(1),cur(2),2) = 1;
		imIn(cur(1),cur(2),3) = 1;
		nex = outpts(1,:);
		line([cur(2), nex(2)],[cur(1),nex(1)]);
	end
end
function [out_points,cur_energy] = mySnake1(imIn,initpts,alpha,beta)
	grey = imIn;
	cur_energy = Inf;
	cur_pts = [];
	% iterate through first and second point to make loop possible
	for i = [5 1:4 6:9]
		for j = [5 1:4 6:9]
			[points,energy] = mySnake2(grey,initpts,alpha,beta,i,j);
			% help converge, encourge to stay in origin
			if energy<cur_energy -0.00001
				cur_pts = points;
				cur_energy = energy;
			end
		end
	end
	out_points = cur_pts;
end

function [points,energy] = mySnake2(imIn,initpts,alpha,beta,i,j)
	[m,n] = size(imIn);
	grad = -imgradient(imIn);
	[m,n] = size(grad);
	first = state(initpts(1,:),i,m,n);
	second = state(initpts(2,:),j,m,n);
	prev_paths = cell(9);
	prevE = zeros(9);
	for k = 1:9
		for l = 1:9
			prev_paths{k,l} = [first;second];
			prevE(k,l) = alpha*sum((double(first-second)).^2) + grad(first(1),first(2))+grad(second(1),second(2)); 
		end
	end
	[l,m] = size(initpts);
	for p = 3:l-1
		cur_paths = cell(9);
		cur_E = zeros(9);
		for j = [5 1:4 6:9]
			cur = state(initpts(p,:),j,m,n);
			for k = [5 1:4 6:9]
				prev = state(initpts(p-1,:),k,m,n);
				minE = Inf;
				cr = 1;
				for r = [5 1:4 6:9]
					pprev = state(initpts(p-2,:),r,m,n);
					curE = prevE(r,k) + deltaE([pprev;prev;cur],alpha,beta);
					curE = curE + grad(cur(1),cur(2));
					if curE< minE
						minE = curE;
						cr = r;
					end
				end
				cur_paths{k,j} = [prev_paths{cr,k};state(initpts(p,:),j,m,n)];
				cur_E(k,j) = minE;
			end
		end
		prevE = cur_E;
		prev_paths = cur_paths;
	end
	% end node
	cur_paths = cell(9);
	cur_E = zeros(9);
	for j = [5 1:4 6:9]
		cur = state(initpts(l,:),j,m,n);
		for k = [5 1:4 6:9]
			prev = state(initpts(l-1,:),k,m,n);
			minE = Inf;
			cr = 1;
			for r = [5 1:4 6:9]
				pprev = state(initpts(l-2,:),r,m,n);
				curE = prevE(r,k) + finalE([pprev;prev;cur;first;second],alpha,beta);
				curE = curE + grad(cur(1),cur(2));
				if curE< minE
					minE = curE;
					cr = r;
				end
			end
			cur_paths{k,j} = [prev_paths{cr,k};state(initpts(l,:),j,m,n)];
			cur_E(k,j) = minE;
		end
	end
	prevE = cur_E;
	prev_paths = cur_paths;
	minE = Inf;
	points = [];
	for j = [5 1:4 6:9]
		for k = [5 1:4 6:9]
			if prevE(j,k) < minE -0.01
				minE = prevE(j,k);
				points = prev_paths{j,k};
			end
		end
	end
	energy = minE;

end


function pt = state(origin,state,m,n)
	i = mod(state-1,3);
	j = (state-1-i)/3;
	i = i-1;
	j = j-1;
	x = origin(1)+i;
	y = origin(2)+j;
	if x<1 || x>m
		x = origin(1);
	end
	if y<1 || y>n
		y = origin(2);
	end
	pt = [x y];
end

% initial points in coordinates and in order
function pts = order(imInitial)
	[row,col] = find(imInitial);
	all_pts = [row col];
	ind = convhull(all_pts);
	ind(end) = [];
	pts = all_pts(ind,:);
end
% initial energy of two points
function E = initialE(x,alpha,beta)
	x = double(x);
	E = sum(alpha*(x(1,:)-x(2,:)).^2);
end
% new energy of adding a new point
function E = deltaE(x,alpha,beta)
	x = double(x);
	E = sum(alpha*(x(3,:)-x(2,:)).^2);
	E = E + sum(beta*(x(3,:)-2*x(2,:)+x(1,:)).^2);
end

% energy of first two points and last three points
function E = finalE(x,alpha,beta)
	x = double(x);
	E = sum(alpha*(x(3,:)-x(2,:)).^2);
	E = E + sum(beta*(x(3,:)-2*x(2,:)+x(1,:)).^2);
	E = E + sum(alpha*(x(3,:)-x(4,:)).^2);
	E = E + sum(beta*(x(5,:)-2*x(4,:)+x(3,:)).^2);
	E = E + sum(beta*(x(4,:)-2*x(3,:)+x(2,:)).^2);
end

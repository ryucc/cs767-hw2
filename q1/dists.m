function [out] = dists(imIn)
	out = zeros([size(imIn) 9]);
	sup = -sum(sum(abs(imIn)));
	% conv operators
	first = [0 -1;1 0]/sqrt(2);
	sec = [1 0;0 -1]/sqrt(2);
	left = [1 1;0 0;-1 -1]/2;
	top = [1 0 -1;1 0 -1]/2;
	% fast conv
	ff = abs(conv2(first,imIn));
	ss = abs(conv2(sec,imIn));
	ll = abs(conv2(left,imIn));
	tt = abs(conv2(top,imIn));
	% make distance mat
	out(:,:,1)=ff(1:end-1,1:end-1);
	out(1,:,1) = sup;
	out(:,1,1) = sup;
	out(:,:,9) = ff(2:end,2:end);
	out(:,end,9) = sup;
	out(end,:,9) = sup;
	
	out(:,:,3) = ss(1:end-1,2:end);
	out(1,:,3) = sup;
	out(:,end,3) = sup;
	out(:,:,7) = ss(2:end,1:end-1);
	out(end,:,7) = sup;
	out(:,1,7) = sup;

	% left and right
	out(:,:,6) = ll(2:end-1,2:end);
	out(1,:,6) = sup;
	out(end,:,6) = sup;
	out(:,end,6) = sup;
	out(:,:,4) = ll(2:end-1,1:end-1);
	out(1,:,4) = sup;
	out(end,:,4) = sup;
	out(:,1,4) = sup;
	% top and down
	out(:,:,2) = tt(1:end-1,2:end-1);
	out(1,:,2) = sup;
	out(:,1,2) = sup;
	out(:,end,2) = sup;
	out(:,:,8) = tt(1:end-1,2:end-1);
	out(end,:,8) = sup;
	out(:,1,8) = sup;
	out(:,end,8) = sup;

	% delta
	delta = max(max(max(out)));
	out = delta-out;
	out(:,:,1) = sqrt(2) * out(:,:,1);
	out(:,:,3) = sqrt(2) * out(:,:,3);
	out(:,:,7) = sqrt(2) * out(:,:,7);
	out(:,:,9) = sqrt(2) * out(:,:,9);
end

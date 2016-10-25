### Problem 1

scissors(imIn, seedRow, seedCol,destRow,destCol):
Usage: works as specified.
Optimization: when generating the distances, the diagonal edges can be computed by:
kernel = [1 0;0 -1], [0 1; -1 0]; [1 1; 0 0; -1 -1], [1 0 -1;1 0 -1]
the do a convolution with imIn, and do some row shifting.

after that, is a standard shortest path algorithm from seed to destination.

activescissors(imIn):
Usage: 
1. input the image
2. the image will show, click on the seed you want, then press enter.
3. activescissors will calculate the shortest path tree.
4. while you are happy, click on any point on the image, then press enter. 
	activescissors will show the cut from the seed to your point.
Optimization:
Once the seed is decided, nd the shortest path tree is generated, the shortest pathes can be shown in O(length of path) time.
I think this is convinient for testing, so I made this function.

This works out pretty well.

### Problem 2.2
Usage: 
yourcellvar = myHoughCircleTrain(imBW,c,ptlist) Outputs a cell oject containing the trained data.
centers = myHoughCircleTest(imBWnew,yourcellvar) Outputs the coordinates of the top two detected centers. and also shows them on the screen.

Training stage:
In lecture 5, the generalized hough transform used the local gradient too decide where to vote. So in the training stage, I do:
For each point in the point list:
	1. Put its normalized local gradient into yourcellvar.
	2. Put its relative position to the reference point into yourcellvar.

In the detection stage, I do:
	1. Calculate the normalized gradient for each pixel.
	2. Find the point with closest gradient in yourcellvar. Since the gradient is normalized, the inner product would be enough.
	3. vote, with the -(relative position) of the point in yourcellvar to the pixel.

Failures:
This training does not do well on scaling. It can do well on test.png, where the circles are about the same size of the training circle, but not the others.

### Problem 3

Usage:

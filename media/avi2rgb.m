%Input: full path avi file
%Output: 3 arrays (R,G,B) . each of the arrays contains all the frames of
%the avi movie
%assumptions: 
%  (1) the AVI's frames are indexed images (and not true colored images)
%  (2) all the frames have the same dimensions
%usage: [R G B]=avi2rgb('C:\... ...\myAVI.avi');
function [R G B]=avi2rgb(x)
y=aviread(x);
%number of frames
frame=ind2rgb(y(1).cdata,y(1).colormap);
s=size(frame);
T1=size(y);
T=T1(2);
N=s(1);
M=s(2);
%preallocating for speed: 
R=zeros(N,M,T);G=zeros(N,M,T);B=zeros(N,M,T);
for i=1:T
    frame=ind2rgb(y(i).cdata,y(i).colormap);
    R(1:N,1:M,i)=frame(1:N,1:M,1); 
    G(1:N,1:M,i)=frame(1:N,1:M,2);
    B(1:N,1:M,i)=frame(1:N,1:M,3);
end
    


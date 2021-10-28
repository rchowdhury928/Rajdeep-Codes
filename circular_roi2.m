%% step-4: this program is intended to pick the localization points within the droplet. Upon running the program GFP image will be opened,
%% followed by one click and drawing an ellipse on top of the droplet. You can resize the ellipse to make it nearly circle if you want and 
%% also you can drag it to place you want. When you are done with placing it properly, double click inside the ellipse to save 
%% the position of the ellipse and the points within this ellipse will be automatically saved. Now you may go to next ROI and repeat the same 
%% process. When you are done with all ROI's, press 1 to end the program only when the cross hair is seen. You need to run this program twice 
%% separately for top (p=1) & bottom (p=2). Don't forget to change name of text file at line 14 and 68.
function circular_roi2
clc
clear
pixel_size=118; %% unit nm
fold_name='C:\H Drive Back Up\Selfmade Programs\ppalm new\';
file_name1='gfp dropet15';
file_name2='roi_photon_filtered';
img=double(imread([fold_name file_name1 '.tif'])); 
overall_2=load([fold_name file_name2 '.txt']);
id_sorted=overall_2(:,1);
frame_sorted=overall_2(:,2);
xxnm_sorted=overall_2(:,3);
yynm_sorted=overall_2(:,4);
z_sorted=overall_2(:,5);
xwidth_sorted=overall_2(:,6);
ywidth_sorted=overall_2(:,7);
photon_sorted=overall_2(:,8);
xx_sorted=overall_2(:,9);
yy_sorted=overall_2(:,10);
roi_all_combine=[];
button=1;
while button==1
hold off
imshow(img,'DisplayRange',[min(min(img)),max(max(img))],'InitialMagnification','fit');
[xp,yp,bt]=ginput(1);
button=bt;
if button==1
%% select rectangular
h=imellipse;
position=wait(h);
if position(3)==0  %% double click to end
    close;
    break;
end
ellipse_x=position(:,1); % all x-points under the ellipse you drawn
ellipse_y=position(:,2); % all y-points under the ellipse you drawn
pos1=min(ellipse_x);pos2=max(ellipse_x);pos3=min(ellipse_y);pos4=max(ellipse_y);
[i,j]=find(xx_sorted>pos1 & xx_sorted<pos2 & yy_sorted>pos3 & yy_sorted<pos4); % finding the spots you select as elliptical boxes
id_roi=[];
frame_roi=[];
xnm_roi=[];
ynm_roi=[];
z_roi=[];
xwidth_roi=[];
ywidth_roi=[];
photon_roi=[];
x_roi=[];
y_roi=[];
k=1;
for w=1:1:length(i) % length(i) is the number of spots you select as elliptical boxes
    id_roi(k)=id_sorted(i(w));
frame_roi(k)=frame_sorted(i(w));
xnm_roi(k)=xxnm_sorted(i(w));
ynm_roi(k)=yynm_sorted(i(w));
z_roi(k)=z_sorted(i(w));
xwidth_roi(k)=xwidth_sorted(i(w));
ywidth_roi(k)=ywidth_sorted(i(w));
photon_roi(k)=photon_sorted(i(w));
x_roi(k)=xx_sorted(i(w));
y_roi(k)=yy_sorted(i(w));
k=k+1;
end
pause(1)
roi_all=[id_roi',frame_roi',xnm_roi',ynm_roi',z_roi',xwidth_roi',ywidth_roi',photon_roi'x_roi',y_roi',];
roi_all_combine=[roi_all_combine;roi_all];
end
end
%% eliminating points which may have counted multiple times
[Mu,ia,ic]=unique(roi_all_combine, 'rows', 'stable'); % Mu is a list of all unique points
save([fold_name file_name2 'roi.txt'],'-ascii','-TABS','Mu');
end

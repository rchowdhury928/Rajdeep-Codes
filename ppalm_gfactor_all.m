%% step1: automatically detects spot in the top channel
function ppalm_gfactor_all
clc
clear
len=200;
fold_name='C:\H Drive Back Up\Selfmade Programs\ppalm new\';
file_name='D1prewash000.ome';
quantum_yield=0.96;
%%%%%%% Gaussian fitting
%% region selected
fcl=1;
fch=512; % this is half the number of total y-pixels
frl=1;
frh=512; % this is the total number of x-pixels
pixel_size=118; %% nm
r=6;
k=1;
spot_details=[];
for i=1:1:len
img=double(imread([fold_name file_name '.tif'],i)); 
imgr=img(frl:frh,fcl:fch);
[peak_num,xp1,yp1]=multi_spot_finding(imgr,r);
b=[];
x_width=[];
y_width=[];
xx=[];
xx_nm=[];
yy_nm=[];
yy=[];
photon_c=[];
if peak_num==0
else
u=peak_num;
for t=1:u
    xp=xp1(t)
    yp=yp1(t)
    ps=double(imgr(yp:yp+2*r,xp:xp+2*r));
    bs=imgr(1:2*r+1,1:2*r+1);
p=gau_fitting(ps,bs,r);
xx1(t)=xp+p(3)-1;
yy1(t)=yp+p(4)-1;
xx1nm(t)=xx1(t)*pixel_size; % in nm
yy1nm(t)=yy1(t)*pixel_size; % in nm
x_width1(t)=pixel_size*p(5);
y_width1(t)=pixel_size*p(6);
photon_c1(t)=sum(sum(ps(1:2*r+1,1:2*r+1)))/quantum_yield;
b=[b;i]
xx=[xx;xx1(t)];
yy=[yy;yy1(t)];
xx_nm=[xx_nm;xx1nm(t)];
yy_nm=[yy_nm;yy1nm(t)];
x_width=[x_width;x_width1(t)];
y_width=[y_width;y_width1(t)];
photon_c=[photon_c;photon_c1(t)];
int=double(ps(1:2*r+1,1:2*r+1));
s=1:2*r+1;
for l=1:2*r+1
    intd(l)=int(l,l);
end
intdata{t}=intd;
s1=1:0.1:2*r+1;
a=length(s1);
for j=1:a
intf(j)=p(1)+p(2)*exp(-(s1(j)-p(3)).^2/(2*p(5).^2)-(s1(j)-p(4)).^2/(2*p(6).^2));
end
intfit{t}=intf;
%%%%check the fitting
% hold on
% f=figure(1);
% subplot(1,2,1)
% imshow(imgr,'DisplayRange',[min(min(imgr)),max(max(imgr))],'InitialMagnification','fit')
% hold on
% plot(xx1(t),yy1(t),'r*')
% title(['Movie' ' Frame' num2str(i)]);
% hold on
% subplot(1,2,2)
% plot(s,intdata{t},'r*',s1,intfit{t},'b');
% pause(3)
% hold off
end
end
% if peak_num==0
% else
% clf(f)
% end
spot_details2=[b,xx,xx_nm,x_width,yy,yy_nm,y_width,photon_c];
spot_details=[spot_details;spot_details2];
%%
%%%imgr(yp1:yp1+2*r,xp1:xp1+2*r)=bs;
end
% spot_details(spot_details(:,5)<10,:)=[];
% spot_details(spot_details(:,5)>55,:)=[];
% spot_details(spot_details(:,2)<25,:)=[];
% spot_details(spot_details(:,2)>90,:)=[];
save([fold_name file_name 'overall_all.txt'],'-ascii','-TABS','spot_details');
% close (f)
%%%%%% functions
function [peak_num,xp1,yp1]=multi_spot_finding(img,r)
[m,n]=size(img);
imgt=img(r+1:m-r-1,r+1:n-r-1);
xdim=size(imgt,1);
ydim=size(imgt,2);
int_row=[];
for v=1:ydim
    int_row1=imgt(v,:);
    int_row=[int_row,int_row1];
end
[pks,locs,w] = findpeaks(int_row);
    peak_details=[pks',locs',w'];
    peak_intensed=find(peak_details(:,1)>30); %the number after > sign indicates that the code will detect spots only when max intensed pixel in spotis > "number"
    peak_sorted=peak_details(peak_intensed,:);
    
% Find indices that were peaks in both x and y
peak_number=length(peak_sorted(:,1));
locs_sorted=peak_sorted(:,2);
x_ind=[];
y_ind=[];
for y=1:peak_number
    yy=locs_sorted(y);
    y_ind1=ceil(yy/ydim)-1;
    x_ind1=yy-1-(y_ind1*ydim);
    x_ind=[x_ind;x_ind1];
    y_ind=[y_ind;y_ind1];
end 
xp=x_ind;
yp=y_ind;
Spot_locations=[xp,yp];
for w=1:length(xp)
    if xp(w)==0
    else
    ss=xp(w);
    sss=yp(w);
    t2=find(xp-ss<15 & xp-ss>-15 & yp-sss<15 & yp-sss>-15); %% eliminating two spots closer than 7 pixels
    tt=find(t2~=w);
    ttt=t2(tt);
    xp(ttt)=0;yp(ttt)=0;
    Spot_locations=[xp,yp];
    end
end
xp1=xp(xp~=0)
yp1=yp(yp~=0)
if length(xp1)==length(yp1)
peak_num=length(xp1)
else
    peak_num=0;
    xp1=[];
    yp1=[];
end
Spot_locations_new=[xp1,yp1];
end
%%%%ps=double(imgr(yp:yp+2*r,xp:xp+2*r)); %% remove the already fitted region

%% Gaussian fitting
function x=gau_fitting(ps,bs,r)
pm=max(max(ps));
bm=mean(mean(bs));
g0=[bm pm-bm r+1 r+1 1 1];
options = optimset('Display','off','MaxIter',1000,'MaxFunEvals',1000,'TolX',1e-10,'LargeScale','on');
[x,resnorm,residual,exitflag,output,lambda] = lsqcurvefit(@gau,double(g0),r,double(ps),[-200000 -200000 0 0 0.1 0.1],[200000 200000 2*r+1 2*r+1 r r],options); % gassusian fitting
end
%% Gaussian function
function f=gau(g,r)
[x,y]=meshgrid(1:1:2*r+1);
f=g(1)+g(2)*exp(-(x-g(3)).^2/(2*g(5).^2)-(y-g(4)).^2/(2*g(6).^2));
end
end
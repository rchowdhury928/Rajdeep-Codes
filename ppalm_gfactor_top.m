%% step-8: automatically detects spots in the top channel based on the spots picked in bottom channel
function ppalm_gfactor_top
clc
clear
len=500;
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
quantum_yield=0.96;
%%%%%% functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pixel_size=118; %% nm
r=6;
k=1;
displace=load([fold_name file_name 'displace' '.txt']);
spot_details=load([fold_name file_name 'overall_bottom2_sorted' '.txt']);
frame_sorted=spot_details(:,1);
x_sorted=spot_details(:,2);
y_sorted=spot_details(:,5);
for q=1:1:length(frame_sorted)
    frame(q)=frame_sorted(q);
    xxp=ceil(x_sorted(q)-displace(1));
    yyp=ceil(y_sorted(q)-displace(2));
    fcl=xxp-r-1;
fch=xxp+r+1;
frl=yyp-r-1;
frh=yyp+r+1;
    img=double(imread([fold_name file_name '.tif'],frame(q)));
imgr=img(frl:frh,fcl:fch);
[xp,yp,ps]=peak_find(imgr,r);
bs=imgr(1:2*r+1,1:2*r+1);
p=gau_fitting(ps,bs,r);
xx1(q)=xp+p(3)-1;
yy1(q)=yp+p(4)-1;
xx(q)=fcl+xx1(q)-1; 
xx_nm(q)=xx(q)*pixel_size;
yy(q)=frl+yy1(q)-1;
yy_nm(q)=xx(q)*pixel_size;
x_width(q)=pixel_size*p(5);
y_width(q)=pixel_size*p(6);
photon_c(q)=sum(sum(ps(1:2*r+1,1:2*r+1)))/quantum_yield;
int=double(ps(1:2*r+1,1:2*r+1));
s=1:2*r+1;
for l=1:2*r+1
    intd(l)=int(l,l);
end
intdata{q}=intd;
s1=1:0.1:2*r+1;
a=length(s1);
for j=1:a
intf(j)=p(1)+p(2)*exp(-(s1(j)-p(3)).^2/(2*p(5).^2)-(s1(j)-p(4)).^2/(2*p(6).^2));
end
intfit{q}=intf;
%check the fitting
% hold on
% subplot(1,2,1)
% imshow(img,'DisplayRange',[min(min(img)),max(max(img))],'InitialMagnification','fit')
% hold on
% plot(fcl+xx1(q)-1,frl+yy1(q)-1,'r*')
% plot(x_sorted(q),y_sorted(q),'b*')
% title([file_name, ' frame', num2str(frame(q))]);
% hold on
% subplot(1,2,2)
% plot(s,intdata{q},'r*',s1,intfit{q},'b');
% pause(2)
% hold off
%%
imgr(yp:yp+2*r,xp:xp+2*r)=bs;
end
% close(1)
photon_c_bottom=photon_c;
spot_details_top=[frame',xx',xx_nm',x_width',yy',yy_nm',y_width',photon_c_bottom'];
save([fold_name file_name 'overall_top2_added.txt'],'-ascii','-TABS','spot_details_top');
function [xp,yp,ps]=peak_find(img,r)
[m,n]=size(img); 
imgt=img(r+1:m-r-1,r+1:n-r-1);
[pss1,pii]=max(imgt);
[pss2,piii]=max(pss1);
yp1=pii(piii)-r+r;  %% maximal position minuse r
xp1=piii-r+r;
yp=yp1;
xp=xp1;
ps=double(imgr(yp:yp+2*r,xp:xp+2*r)); %% remove the already fitted region
end
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

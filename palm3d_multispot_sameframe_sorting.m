%%% Step-2: In some cases same spot is detected twice or more within the same frame. This
%%% program remove those repeated spots
function palm3d_multispot_sameframe_sorting
clc
clear
fold_name='C:\H Drive Back Up\Selfmade Programs\ppalm new\';
stream_name='D1prewash000.ome';
quantum_yield=0.96; 
pixel_size=118;
%%%%%%% Gaussian fitting
%% region selected
fd=load([fold_name stream_name 'overall_all.txt']);
frame=fd(:,1);
xp=fd(:,2);
x_width=fd(:,4);
yp=fd(:,5);
y_width=fd(:,7);
photon_c=fd(:,8);
fr_sel=unique(frame);
spot_detail=[];
for m=1:1:length(fr_sel)
    mm=fr_sel(m);
    seq_num=find(frame(:,1)==mm);
    frame1=frame(seq_num);
    xp1=xp(seq_num);
    x_width1=x_width(seq_num);
    yp1=yp(seq_num);
    y_width1=y_width(seq_num);
    photon_c1=photon_c(seq_num);
    for w=1:length(frame1)
        ss=xp1(w);
    sss=yp1(w);
    t2=find(xp1-ss<15 & xp1-ss>-15 & yp1-sss<15 & yp1-sss>-15); %% eliminating two spots closer than 7 pixels
    tt=find(t2~=w);
    ttt=t2(tt);
    frame1(ttt)=0;
    xp1(ttt)=0;
    x_width1(ttt)=0;
    yp1(ttt)=0;
    y_width1(ttt)=0;
    photon_c1(ttt)=0;
    end
    frame2=frame1(frame1~=0);
    xp2=xp1(xp1~=0);
    x_width2=x_width1(x_width1~=0);
    yp2=yp1(yp1~=0);
    y_width2=y_width1(y_width1~=0);
    photon_c2=photon_c1(photon_c1~=0);
    xp2nm=xp2*pixel_size;
    yp2nm=yp2*pixel_size;
    spot_det=[frame2,xp2,xp2nm,x_width2,yp2,yp2nm,y_width2,photon_c2];
    spot_detail=[spot_detail;spot_det];
end
save([fold_name stream_name 'overall_all2.txt'],'-ascii','-TABS','spot_detail');
end
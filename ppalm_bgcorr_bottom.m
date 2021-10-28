% Step11: bottom Channel: Calculates average background photon counts from last 100 frames of the movie and gives background corrected spot intensity. 
% It takes the same ROI as taken for the detected spot and calculates the intensity of the same ROI from only those frames where there is no
% detected spots nereby and average out those frames
function ppalm_bgcorr_bottom
clc
clear
len=500;
quantum_yield=0.96;
r=6;
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
spot_selected=load([fold_name file_name 'overall_bottom2_combined' '.txt']);
fr=load([fold_name file_name 'fr' '.txt']);
frame_selected=spot_selected(:,1);
x_selected=spot_selected(:,2);
y_selected=spot_selected(:,5);
int_selected=spot_selected(:,8);
int_avg=[];
for s=1:length(frame_selected)
    ss=frame_selected(s)
    sx=ceil(x_selected(s));
    sy=ceil(y_selected(s));
    int=[];
    for t=1:length(fr)
        tt=fr(t);
        img=double(imread([fold_name file_name '.tif'],tt));
        int1=sum(sum(img(sy-r:sy+r,sx-r:sx+r)))/quantum_yield;
    int=[int;int1];
    end
    int;
    int_avg1=sum(int)/length(fr);
    int_avg=[int_avg;int_avg1];
end
int_corr_bottom=int_selected-int_avg;
spot_details_bg_bottom=[spot_selected,int_avg,int_corr_bottom];
save([fold_name file_name 'spot_details_bg_bottom.txt'],'-ascii','-TABS','spot_details_bg_bottom');
end
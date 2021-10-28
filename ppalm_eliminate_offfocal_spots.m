% step-13: Eliminates spots which are beyond z=+/- 400 nm
function ppalm_eliminate_offfocal_spots
clc
clear
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
cal_z=load([fold_name 'width_diff 60nm' '.txt']);
z_theo=cal_z(:,1);
wid_diff_theo=cal_z(:,2);
spot_details_top=load([fold_name file_name ' top_intensed' '.txt']);
xwid_top=spot_details_top(:,4);
ywid_top=spot_details_top(:,7); 
wid_diff_top=xwid_top-ywid_top;
spot_details_bottom=load([fold_name file_name ' bottom_intensed' '.txt']);
k=1;
for i=1:1:length(wid_diff_top)
distance=wid_diff_top(i)-wid_diff_theo;
[m,n]=min(abs(distance-0));
z(k)=z_theo(n);
k=k+1;
end
z=z';
spot_details_top1=[spot_details_top,z];
ind=find(z>-400 & z<400);
spot_details_top2=spot_details_top1(ind,:);
spot_details_bottom1=[spot_details_bottom,z];
spot_details_bottom2=spot_details_bottom1(ind,:);
save([fold_name file_name ' top_z_selected.txt'],'-ascii','-TABS','spot_details_top2');
save([fold_name file_name ' bottom_z_selected.txt'],'-ascii','-TABS','spot_details_bottom2');
end
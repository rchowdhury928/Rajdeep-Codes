%% step6: Find the displacement between top and bottom channel based on the spots which are picked in both channels
function displacement
clc
clear
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
fd_top=load([fold_name file_name 'overall_top2_sorted.txt']);
frame_top=fd_top(:,1);
fd_bottom=load([fold_name file_name 'overall_bottom2_sorted.txt']);
frame_bottom=fd_bottom(:,1);
[val_top,pos_top]=intersect(frame_top,frame_bottom);
top_sel=fd_top(pos_top,:); %top spot details which are common with bottom
[val_bottom,pos_bottom]=intersect(frame_bottom,frame_top);
bottom_sel=fd_bottom(pos_bottom,:); %bottom spot details which are common with top
top_x=top_sel(:,2);
bottom_x=bottom_sel(:,2);
diff_x=bottom_x-top_x;
mean_diff_x=mean(diff_x);
top_y=top_sel(:,5);
bottom_y=bottom_sel(:,5);
diff_y=bottom_y-top_y;
mean_diff_y=mean(diff_y);
displaced=[mean_diff_x,mean_diff_y];
save([fold_name file_name 'displace.txt'],'-ascii','-TABS','displaced');
end
% step-13: Eliminates spots which are close to the coverslip based on their
% (x_width-y_width) value. This program is needed only for screening spots
% based on their z-value. For non-astigmatic spots, skip this program. If
% you need to run this program twice then you have to run step 12 first
% followed by running this one.
function ppalm_eliminate_belowfocus_spots
clc
clear
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
spot_details_top=load([fold_name file_name ' top_intensed' '.txt']);
xwid_top=spot_details_top(:,4);
ywid_top=spot_details_top(:,7); 
wid_diff_top=xwid_top-ywid_top;
int_top=spot_details_top(:,10);
spot_details_bottom=load([fold_name file_name ' bottom_intensed' '.txt']);
xwid_bottom=spot_details_bottom(:,4);
ywid_bottom=spot_details_bottom(:,7);
wid_diff_bottom=xwid_bottom-ywid_bottom;
int_bottom=spot_details_bottom(:,10);
top=[];
bottom=[];
for i=1:1:length(xwid_top)
if int_top(i)>int_bottom(i)
    if xwid_top(i)-ywid_top(i)<-200 % decide this value from calibration curve
        top1=spot_details_top(i,:);
        bottom1=spot_details_bottom(i,:);
    else
        top1=[];
        bottom1=[];
    end
    top=[top;top1];
bottom=[bottom;bottom1];
else
    if xwid_bottom(i)-ywid_bottom(i)<-200 % decide this value from calibration curve
        top1=spot_details_top(i,:);
        bottom1=spot_details_bottom(i,:);
    else
        top1=[];
        bottom1=[];
    end
end
top=[top;top1];
bottom=[bottom;bottom1];
end
% row_eliminate_from_top=spot_details_top(:,7)>350; % indices to be eliminated from top spots
% step1_eliminated_top=spot_details_top(row_eliminate_from_top,:); % after elimination of dimmer spots from top channel
% step1_eliminated_bottom=spot_details_bottom(row_eliminate_from_top,:); % after elimination of same spots (which are dimmer in top channel) from bottom channel
% else
%     row_eliminate_from_bottom=spot_details_bottom(:,7)>350; % indices to be eliminated from top spots
% step1_eliminated_bottom=spot_details_bottom(row_eliminate_from_bottom,:); % after elimination of dimmer spots from top channel
% step1_eliminated_top=spot_details_top(row_eliminate_from_bottom,:); % after elimination of same spots (which are dimmer in top channel) from bottom channel
% end
save([fold_name file_name ' top_intensed.txt'],'-ascii','-TABS','top');
save([fold_name file_name ' bottom_intensed.txt'],'-ascii','-TABS','bottom');
end
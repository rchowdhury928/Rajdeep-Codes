%step-12: Eliminates spots based on the photon count
function ppalm_eliminate_dim_spots
clc
clear
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
spot_details_top=load([fold_name file_name 'spot_details_bg_top' '.txt']);
% spot_int_top=spot_details_top(:,10);
spot_details_bottom=load([fold_name file_name 'spot_details_bg_bottom' '.txt']);
% spot_int_bottom=spot_details_bottom(:,10);
row_eliminate_from_top=spot_details_top(:,10)>-50; % indices to be eliminated from top spots
step1_eliminated_top=spot_details_top(row_eliminate_from_top,:); % after elimination of dimmer spots from top channel
step1_eliminated_bottom=spot_details_bottom(row_eliminate_from_top,:); % after elimination of same spots (which are dimmer in top channel) from bottom channel
row_eliminate_from_bottom=step1_eliminated_bottom(:,10)>-50; % indicies to be eliminated from bottom
step2_eliminated_top=step1_eliminated_top(row_eliminate_from_bottom,:); % after elimination of dimmer spots (in bottom channel) from top channel
step2_eliminated_bottom=step1_eliminated_bottom(row_eliminate_from_bottom,:); % after elimination of dimmer spots (in bottom channel) from bottom channel
%%%%%% eliminate spots where total (top+bottom) intensity is less than 100 photons 
top_intensed=step2_eliminated_top(:,10);
bottom_intensed=step2_eliminated_bottom(:,10);
total_intensed=top_intensed+bottom_intensed;
row_to_keep=total_intensed(:,1)>100; % index of those spots where total intensity is >100 photons
spots_top_after_elimination=step2_eliminated_top(row_to_keep,:);
spots_bottom_after_elimination=step2_eliminated_bottom(row_to_keep,:);
save([fold_name file_name ' top_intensed.txt'],'-ascii','-TABS','spots_top_after_elimination');
save([fold_name file_name ' bottom_intensed.txt'],'-ascii','-TABS','spots_bottom_after_elimination');
end
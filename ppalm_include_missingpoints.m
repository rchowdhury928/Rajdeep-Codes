%% step-9: It will merge bottom2_sorted and top2_added and include missing points from bottom2_added and top2_sorted
function ppalm_include_missingpoints
clc
clear
len=500;
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
quantum_yield=0.96;
top_init_pts=load([fold_name file_name 'overall_top2_added' '.txt']);
bottom_init_pts=load([fold_name file_name 'overall_bottom2_sorted' '.txt']);
top_tobe_added_from=load([fold_name file_name 'overall_top2_sorted' '.txt']);
bottom_tobe_added_from=load([fold_name file_name 'overall_bottom2_added' '.txt']);
fr_top_init_pts=top_init_pts(:,1);
fr_top_tobe_added_from=top_tobe_added_from(:,1);
[fr_top_unique,fr_top_unique_indices]=setdiff(fr_top_tobe_added_from,fr_top_init_pts);
top_tobe_added=top_tobe_added_from(fr_top_unique_indices,:);
bottom_tobe_added=bottom_tobe_added_from(fr_top_unique_indices,:);
top_combined=[top_init_pts;top_tobe_added];
top_combined2=sortrows(top_combined,1);
bottom_combined=[bottom_init_pts;bottom_tobe_added];
bottom_combined2=sortrows(bottom_combined,1);
save([fold_name file_name 'overall_top2_combined.txt'],'-ascii','-TABS','top_combined2');
save([fold_name file_name 'overall_bottom2_combined.txt'],'-ascii','-TABS','bottom_combined2');
end
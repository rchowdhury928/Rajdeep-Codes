%step-14: Generates a polarization histogram and gives a g-value by trial and error
function ppalm_gfactor_calibration
clc
clear
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03042020\droplet\';
file_name='5ms0006';
spot_details_top=load([fold_name file_name ' top_intensed' '.txt']);
spot_int_top=spot_details_top(:,10);
spot_details_bottom=load([fold_name file_name ' bottom_intensed' '.txt']);
spot_int_bottom=spot_details_bottom(:,10);
g=1.2;
s=spot_int_bottom*g;
p_numerator=spot_int_top-s;
p_denominator=spot_int_top+s;
p=p_numerator./p_denominator;
p_sorted_1=p(p(:)>-1.25);
p_sorted=p_sorted_1(p_sorted_1(:)<1.25);
p_squared=p_sorted.^2;
pol=[p_sorted,p_squared]
save([fold_name file_name ' p_cal.txt'],'-ascii','-TABS','pol');
% p_squared=p.^2;
% pola=[p,p_squared];
% save([fold_name file_name ' p_cal.txt'],'-ascii','-TABS','pola');
end
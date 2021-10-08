% Calculation of frequency against bin to plot as a histogram
function histogram_calculator
clc
clear
fold_name='C:\G Drive Back Up\TAMHSC\Adaptive Optics\Calibration curve\03052020\';
file_name=' step_size_3d';
data_nm=load([fold_name file_name '.txt']);
data=data_nm/1000; %conversion of your data some other unit (e.g. from nm to um), if you don't need any conversion set the denominator as 1
bin_size=0.02; % you need to define this value
lowest_value=0; % you need to define this value for 1d step size, 0 is good for 2d and 3d
center_of_low_bin=abs((bin_size+lowest_value)/2);
data_min=min(data);
data_max=max(data);
a=data_min/bin_size;b=data_max/bin_size;
diff=abs(b-a);
c=ceil(diff)+4;
d=ceil(a)-2;
e=d*bin_size;
f=[e:bin_size:e+(c-1)*bin_size]'; % similar to column I in excel, minimum value of each bin
g=f+bin_size; % similar to H column in excel, maximum value of each bin
h=g-(bin_size/2); % similar to F column in excel,  center of each bin
for n=1:1:length(f)
    j1=f(n);
    j2=g(n);
    k(n)=sum(data>=j1 & data<j2); % calculates frequency of each bin
end
k=k';
hist_unnormalized=[h,k];
m=sum(k);
n=k./m;
hist_normalized=[h,n];
save([fold_name file_name ' hist_normalized.txt'],'-ascii','-TABS','hist_normalized');
end
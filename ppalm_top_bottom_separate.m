%% step3: Separates spots in top and bottom channel
function ppalm_top_bottom_separate
clc
clear
len=200;
fold_name='C:\H Drive Back Up\Selfmade Programs\ppalm new\';
file_name='D1prewash000.ome';
quantum_yield=0.96;
fd=load([fold_name file_name 'overall_all.txt']);
frame=fd(:,1);
x=fd(:,2);
y=fd(:,5);
overall_top=[];
overall_bottom=[];
for p=1:1:length(frame)
    if y(p)<244 % select this value based on the point of separation between top and bottom channel
        top1=fd(p,:);
        overall_top=[overall_top;top1];
    else
        bottom1=fd(p,:);
        overall_bottom=[overall_bottom;bottom1];
    end
end
overall_top;
overall_bottom;
save([fold_name file_name 'overall_top.txt'],'-ascii','-TABS','overall_top');
save([fold_name file_name 'overall_bottom.txt'],'-ascii','-TABS','overall_bottom');
end
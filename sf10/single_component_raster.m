

[parentdir,~,~] = fileparts(pwd);
load(fullfile(parentdir, 'supporting_data/extract_curated.mat'));
load(fullfile(parentdir, 'supporting_data/NMF_ordering.mat'));


[B,I] = sort(Htot');

groupings = zeros(size(S, 3),1);
for i = 1:numel(groupings)
    [r,c] = find(I==i);
    [gm, gi] = max(r);
    groupings(i) = gi;
end




Sthresh = zeros(size(S));
for i = 1:size(S,3)
    Sthresh(:,:,i) = S(:,:,i) > 0.1*max(S(:,:,i),[],'all');
end

outlines = double(sum(Sthresh, 3)>0);



tpeak = [820, 770, 990, 700, 400, 420, 1000, 410];
lb = tpeak-25;
ub = tpeak+25;

active = zeros(8,1);
pactive = active;

for i=1:8

    neurons = find(groupings==i);

    roi = iT(lb(i)*30:ub(i)*30, neurons);

    %a = find(max(roi(900:1300, :)) > prctile(iT(:,neurons), 99));

    a = find(max(roi) > max(iT(:, neurons))*.5);
    active(i) = numel(a);
    pactive(i) = numel(a)/numel(neurons);

    cplot = sum(Sthresh(:,:,neurons(a)),3);
    cplot(cplot>0)=cplot(cplot>0)+1;

    %cmap = parula(256);
    cmap = hsv(3);
    cmap = [0,0,0; .2, .2, .2; 0,.5,1; 1,0,0; 1,0,0];

    imOut = max(outlines+1, cplot+1);
    %imwrite(imOut(:,125:733),cmap,strcat('stripes/',num2str(i),'.png'));
end



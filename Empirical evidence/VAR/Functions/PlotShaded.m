% Fills area between mData(:,1) and mData(:,2) with light grey, starting at
% TimeOrigin

function PlotArea = PlotShaded(mData,TimeOrigin,TimeEnd)
ColorShaded = [0.9, 0.9, 0.9];
%TimeEnd = size(mData,1)-1;
PlotArea=fill([TimeOrigin:TimeEnd TimeEnd:-1:TimeOrigin],[mData(:,1)' flipud(mData(:,2))'],ColorShaded);
set(PlotArea,'EdgeAlpha',0);
end

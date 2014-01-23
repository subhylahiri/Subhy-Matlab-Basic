function bangles=unmod2pi(bangles)

dbangles=diff(bangles);
% upjumps=find(dbangles>1.9*pi);
% dnjumps=find(dbangles<-1.9*pi);
% nupjumps=numel(upjumps);
% ndnjumps=numel(dnjumps);
% if nupjumps>0
%     for i=1:nupjumps
%         bangles(upjumps(i)+1:end)=bangles(upjumps(i)+1:end)-2*pi;
%     end %for i
% end %if nupjumps>0
% if ndnjumps>0
%     for i=1:ndnjumps
%         bangles(dnjumps(i)+1:end)=bangles(dnjumps(i)+1:end)+2*pi;
%     end %for i
% end %if nupjumps>0
if size(bangles,1)>size(bangles,2)
    upjumps=[false;(dbangles>1.0*pi)];
    dnjumps=[false;(dbangles<-1.0*pi)];
else
    upjumps=[false,(dbangles>1.0*pi)];
    dnjumps=[false,(dbangles<-1.0*pi)];
end
jumps=zeros(size(bangles));
jumps(upjumps)=1;
jumps(dnjumps)=-1;
bangles=bangles-2*pi*cumsum(jumps);
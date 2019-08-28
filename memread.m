% close all;
mraw = memmapfile('RLS_2_fileRLS_FFT_009.b',...
    'Offset',0,...
    'Repeat',50000,...
    'Format',{...
    'uint32',1,'size';...
    'double',1,'time';...
    'uint32',1,'senderID';...
    'uint32',1,'signalType';...
    'uint32',1,'signalMode';...
    'uint32',1,'line_num';...
    'uint32',1,'pos';...
    'single',4096,'spectr'});
s1 = [];
pos = [];
k = 1;
for ii = 1:50000
    pos(ii) = mraw.Data(ii).pos;
    if ii > 1 && pos(ii-1) > pos(ii)
        posnum(k) = ii - 1;
        k = k + 1;
    end
end

s1 = [];
for ii = posnum(1) : (posnum(2)-1)
    s1 = [s1 mraw.Data(ii).spectr];
end

s4 = [];
Nrot1 = 50;
Nrot2 = 50;

for M = Nrot1:Nrot2
    k = 0; %количество азимутов
    s2 = [];

    for ii = posnum(M) : (posnum(M+1)-1)
        s2 = [s2 mraw.Data(ii).spectr];
        k = k + 1;
    end
    s3 = [];
    for j = 1:4096
        s3 = [s3 (interp1(1:k, s2(j,1:k), 1:(k/801):k))'];
    end
    s3 = s3';
    s4(:,:,M) = s3;
end

% subplot(1,2,1);
polarplot3d(s4(1:2000,:,50), 'RadialRange', [0 1])
% colormap(gray)
caxis([0 20])
set(gca,'Xlim',[-1.1 1.1],'Ylim',[-1.1 1.1])
view(2);
% im = rgb2gray(im);
% figure
% imshow(im)

% for i = 1:4096
%     for j = 1:1000
%         s4(i,j,:) = medfilt1(s4(i,j,:));
%     end
% end
% 
% subplot(1,2,2);
% polarplot3d(s4(:,:,50), 'RadialRange', [0 1]);
% caxis([0 20]);
% set(gca,'Xlim',[-1.1 1.1],'Ylim',[-1.1 1.1]);
% view(2);



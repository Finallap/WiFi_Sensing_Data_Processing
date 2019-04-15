%T = 0:0.001:2;
%X = chirp(T,100,1,200,'q');
%spectrogram(X,128,120,128,1E3);

%for m=1:L
%    csi_entry=csi_trace{m};
%    csi=get_scaled_csi(csi_entry);   
%    sequence(m,:) = csi(1,1,:);
%end

%sequence = amplitudeA(:,2);
M=ev(:,29);
sequence = amplitude*M;
[S,F,T,P] = spectrogram(sequence(200:1200),32,30,100,100);
%T = T.+20;
surf(T,F,10*log10(P),'edgecolor','none'); 
axis tight;
view(0,90);
xlabel('Time (Seconds)'); 
ylabel('Hz');
title('sample-3-2.dat(#2 Steam)');
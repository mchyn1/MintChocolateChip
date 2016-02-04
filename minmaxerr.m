%finding controller K

maxerr=zeros(21,1);
for K = -10:10 %can change to first order etc.
    H_n=; %normal
    H_p=; %Parkinsonian
    H=tf(H_p,[  %H_p/(1+H_p*K)
    [mag,~] = bode(H,z);
    [mag_p,~] = bode(H_p,z);
    [mag_n,~] = bode(H_n,z);
    %zplane(num,den);
    for z =  0:.1:2*pi
        if abs(mag_n-mag) > maxerr(k)
            maxerr(K) = abs(mag_n-mag);
        end
    end
end
[y,i] = min(maxxerr);
K = -10:10;
K=K(i);
bodeplot(H_p,'b',H_k,'r');

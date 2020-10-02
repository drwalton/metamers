function statg0 = findImageStats(oim, m)

statg0 = zeros(6,m.scale{1}.nMasks);
for imask = 1:m.scale{1}.nMasks
  thisMask = squeeze(m.scale{1}.maskMat(imask,:,:));
  thisMaskNAN = thisMask;
  thisMaskNAN(thisMaskNAN==0) = NaN;
  thisMaskNAN(thisMaskNAN>0) = 1;
  [mn0, mx0] = range2(oim.*thisMaskNAN);
  mean0 = wmean2(oim,thisMask);
  var0 = wvar2(oim,thisMask);
  skew0 = wskew2(oim,thisMask);
  kurt0 = wkurt2(oim,thisMask);
  statg0(:,imask) = [mean0 var0 skew0 kurt0 mn0 mx0]; 
end
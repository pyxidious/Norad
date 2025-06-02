function [output] = noiseSelector(nome_img,rumore)
i = imageReader(nome_img);

if strcmpi(rumore, 'gaussian') % Non è CaseSensitive
    final = gaussNoiseRemover(i);
end
if strcmpi(rumore, 'sp') % Non è CaseSensitive
    final = saltpepperNoiseRemover(i);
end

if strcmpi(rumore, 'periodic') % Non è CaseSensitive
    final = periodicNoiseRemover(i);
end

output = final;
end
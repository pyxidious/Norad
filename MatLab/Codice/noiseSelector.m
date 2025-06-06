function [output] = noiseSelector(nome_img,rumore)
i = imageReader(nome_img);

if strcmpi(rumore, 'gaussian') % Non è CaseSensitive
    final = gaussNoiseRemover(i);
end
if strcmpi(rumore, 'sp')
    final = saltpepperNoiseRemover(i);
end

if strcmpi(rumore, 'periodic')
    final = periodicNoiseRemover(i);
end

if strcmpi(rumore, 'vstriping')
    final = verticalStripingNoiseRemover(i);
end

if strcmpi(rumore, 'hstriping')
    final = horizontalStripingNoiseRemover(i);
end

output = final;
end
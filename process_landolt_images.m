% Process Landolt images


for angle = 10:30
    for type = ["c", "o"]
        filename = sprintf("landolt_%s_M_%d.png", type, angle);
        oim = double(imread(filename));
        oim = oim - rand(size(oim))*0.01;
        output_filename = sprintf("landolt_%s_M_%d_metamer.png", type, angle);
        fprintf("Processing image %s\n", filename);
        fprintf("Producing output %s\n", output_filename);
        makeMetamer360SubIm(oim, angle, output_filename);
    end
end

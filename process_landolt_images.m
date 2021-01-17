% Process Landolt images

for type = ["o", "c"]
    for angle = 5:30
        filename = sprintf("landolt_%s_M_%d.png", type, angle);
        oim = double(imread(filename));
        output_filename = sprintf("landolt_%s_M_%d_metamer.png", type, angle);
        fprintf("Processing image %s\n", filename);
        fprintf("Producing output %s\n", output_filename);
        makeMetamer360SubIm(oim, angle, output_filename);
    end
end

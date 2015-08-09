
//
// Disclamer:
// ----------
//
// This code will work only if you selected window, graphics and audio.
//
// In order to load the resources like cute_image.png, you have to set up
// your target scheme:
//
// - Select "Edit Scheme…" in the "Product" menu;
// - Check the box "use custom working directory";
// - Fill the text field with the folder path containing your resources;
//        (e.g. your project folder)
// - Click OK.
//

#include <SFML/Graphics/Image.hpp>

#include <iostream>
#include <fstream>
#include <string>

using namespace sf;

typedef unsigned char byte;

int main(int argc, const char * argv [])
{
    // Получение пути и имени файла
    std::string path(argv[argc - 1]);
    std::cout << "Input file: " << path << std::endl;
    
    // Загрузка файла
    Image img;
    if (!img.loadFromFile(path))
    {
        throw std::runtime_error("Unknown file!\n");
        return EXIT_FAILURE;
    }
    
    // Формирования имени файла
    std::string outFileName(path);
    outFileName += ".msk";
    
    // Запись в файл
    unsigned long width = img.getSize().x, height = img.getSize().y;
    std::ofstream outFile(outFileName, std::ios::binary);
    if (!outFile.good())
    {
        std::runtime_error("Unable to open resulting file");
    }
    std::cout << "Starting to write mask to file with name " << "\n\t" << outFileName << std::endl;
    try
    {
        byte prevAlpha = (img.getPixel(0, 0).a & 0x01), currentAlpha;
        for (unsigned long i = 0, matches = 0; i < height * width; ++i)
        {
            currentAlpha = (img.getPixel(i % width, i / height).a & 0x01);
            if ((currentAlpha == prevAlpha) && (matches < 0xFE))
            {
                matches ++;
            }
            else
            {
                if (!matches)
                {
                    outFile << (byte)currentAlpha;
                }
                else
                {
                    outFile << (byte)(0xF0 + prevAlpha) << (byte)(matches + 1);
                    matches = (matches >= 0xFE) ? 0 : matches;
                }
            }
            prevAlpha = currentAlpha;
        }
    }
    catch(std::exception exception)
    {
        std::cout << "Unknow error has occured" << std::endl;
        return EXIT_FAILURE;
    }
    outFile.close();
    std::cout << "Write to file successfull" << std::endl;
    
    return EXIT_SUCCESS;
}

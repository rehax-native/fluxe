
#pragma once

namespace fluxe {

struct Color
{
    static Color RGBA(float r, float g, float b, float a);
    Color();
    Color(int color);
    int color;
};

}

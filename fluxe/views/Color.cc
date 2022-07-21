#include "Color.h"

using namespace fluxe;

Color::Color()
:color(0)
{}

Color::Color(int color)
:color(color)
{}

Color Color::RGBA(float r, float g, float b, float a)
{
  auto nr = (int) (r * 255.0);
  auto ng = (int) (g * 255.0);
  auto nb = (int) (b * 255.0);
  auto na = (int) (a * 255.0);
  auto color = (na << 24) | (nr << 16) | (ng << 8) | nb;
  return Color(color);
}

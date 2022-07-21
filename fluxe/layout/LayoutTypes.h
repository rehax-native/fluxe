#pragma once

#include <variant>
#include "../misc/Nullable.h"

namespace fluxe {

namespace SizeDimensionTypes {
  /** Natural, meaning the size that the view reports **/
  struct Natural {};

  /** Fixed size in screen independent pixels **/
  struct Fixed
  {
    float size;
  };

  /** Fill the parent (looking at the parent's layout constraints) **/
  struct Fill {};

  /** Percentage of parent (looking at the parent's layout constraints) **/
  struct Percentage {
    float percent;
  };
}

using SizeDimension = std::variant<
  SizeDimensionTypes::Natural,
  SizeDimensionTypes::Fixed,
  SizeDimensionTypes::Fill,
  SizeDimensionTypes::Percentage
>;

namespace PositionDimensionTypes {
  /** Natural, meaning the position set by the layout **/
  struct Natural {};

  /** Fixed positin in screen independent pixels, relative to the parent **/
  struct Fixed
  {
    float amount;
  };

  /** Percentage of parent (looking at the parent's layout constraints) **/
  struct Percentage {
    float percent;
  };
}

using PositionDimension = std::variant<
  PositionDimensionTypes::Natural,
  PositionDimensionTypes::Fixed,
  PositionDimensionTypes::Percentage
>;

struct LayoutSizeOverride
{
  SizeDimension width = SizeDimensionTypes::Natural{};
  SizeDimension height = SizeDimensionTypes::Natural{};
};

struct LayoutPositionOverride
{
  PositionDimension left = PositionDimensionTypes::Natural{};
  PositionDimension top = PositionDimensionTypes::Natural{};
  PositionDimension right = PositionDimensionTypes::Natural{};
  PositionDimension bottom = PositionDimensionTypes::Natural{};
};

struct PossibleLayoutSize
{
  Nullable<float> width;
  Nullable<float> height;
};

struct LayoutSize
{
  float width;
  float height;
};

struct LayoutPosition
{
  float left;
  float top;
};

}

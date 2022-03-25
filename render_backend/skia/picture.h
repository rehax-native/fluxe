#pragma once

// // #include "flutter/display_list/display_list.h"
// // #include "flutter/flow/skia_gpu_object.h"
// #include "flutter/lib/ui/painting/image.h"
// #include "third_party/skia/include/core/SkPicture.h"

// namespace fluxe {
// class Canvas;

// // class Picture : public RefCountedDartWrappable<Picture> {
// class Picture {
//   DEFINE_WRAPPERTYPEINFO();
//   FML_FRIEND_MAKE_REF_COUNTED(Picture);

//  public:
//   ~Picture() override;
//   static fml::RefPtr<Picture> Create(flutter::SkiaGPUObject<SkPicture> picture);
//   // static fml::RefPtr<Picture> Create(flutter::SkiaGPUObject<DisplayList> display_list);

//   sk_sp<SkPicture> picture() const { return picture_.skia_object(); }
//   sk_sp<DisplayList> display_list() const {
//     return display_list_.skia_object();
//   }

//   Dart_Handle toImage(uint32_t width,
//                       uint32_t height,
//                       Dart_Handle raw_image_callback);

//   void dispose();

//   size_t GetAllocationSize() const override;

//  private:
//   explicit Picture(flutter::SkiaGPUObject<SkPicture> picture);
//   explicit Picture(flutter::SkiaGPUObject<DisplayList> display_list);

//   flutter::SkiaGPUObject<SkPicture> picture_;
//   flutter::SkiaGPUObject<DisplayList> display_list_;
// };

// }  // namespace fluxe

#pragma once

// #include "third_party/skia/include/core/SkVertices.h"

// namespace fluxe {

// class Vertices {
//   DEFINE_WRAPPERTYPEINFO();
//   FML_FRIEND_MAKE_REF_COUNTED(Vertices);

//  public:
//   ~Vertices() override;

//   static bool init(Dart_Handle vertices_handle,
//                    SkVertices::VertexMode vertex_mode,
//                    tonic::Float32List& positions,
//                    tonic::Float32List& texture_coordinates,
//                    tonic::Int32List& colors,
//                    tonic::Uint16List& indices);

//   const sk_sp<SkVertices>& vertices() const { return vertices_; }

//   size_t GetAllocationSize() const override;

//  private:
//   Vertices();

//   sk_sp<SkVertices> vertices_;
// };

// }  // namespace fluxe

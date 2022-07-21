#pragma once

#include <utility>
#include <iostream>

namespace fluxe {

class ReferenceCounter;

template <typename T>
class WeakObjectPointer;


/*
  An automatic reference counting pointer to an Object, similar to std::shared_ptr with std::enable_shared_from_this
*/
template <typename T>
class ObjectPointer
{
public:

  template <typename Other> friend class ObjectPointer;

  ObjectPointer()
  :object(nullptr)
  {}

  // constructor from pointer
  ObjectPointer(T * t)
  :object(t)
  {
    if (object != nullptr)
    {
      object->increaseReferenceCount();
    }
  }

  ~ObjectPointer()
  {
    if (object != nullptr)
    {
      object->decreaseReferenceCount();
    }
  }

  // copy constructor
  ObjectPointer(const ObjectPointer& other) noexcept
  :object(other.object)
  {
    object->increaseReferenceCount();
  }

  template <typename Subclass, typename = typename std::enable_if<std::is_convertible<Subclass*, T*>::value, void>::type>
  ObjectPointer(const ObjectPointer<Subclass>& other) noexcept
  :object(other.object)
  {
    object->increaseReferenceCount();
  }

  // move constructor
  ObjectPointer(ObjectPointer&& other) noexcept
  :object(other.object)
  {
    other.object = nullptr;
  }

  template <typename Subclass, typename = typename std::enable_if<std::is_convertible<Subclass*, T*>::value, void>::type>
  ObjectPointer(ObjectPointer<Subclass>&& other) noexcept
  :object(other.object)
  {
    other.object = nullptr;
  }

  // copy assignment
  ObjectPointer& operator = (const ObjectPointer& other) noexcept
  {
    if (object == other.object)
    {
      return *this;
    }
    if (other.object != nullptr)
    {
      other.object->increaseReferenceCount();
    }
    if (object != nullptr)
    {
      object->decreaseReferenceCount();
    }

    object = other.object;
    return *this;
  }

  template <typename Subclass, typename = typename std::enable_if<std::is_convertible<Subclass*, T*>::value, void>::type>
  ObjectPointer& operator = (const ObjectPointer<Subclass>& other) noexcept
  {
    if (object == other.object)
    {
      return *this;
    }
    if (other.object != nullptr)
    {
      other.object->increaseReferenceCount();
    }
    if (object != nullptr)
    {
      object->decreaseReferenceCount();
    }
    object = other.object;
    return *this;
  }

  // move assignment
  ObjectPointer& operator = (ObjectPointer&& other) noexcept
  {
    if (object == other.object)
    {
      return *this;
    }
    if (object != nullptr)
    {
      object->decreaseReferenceCount();
    }
    object = other.object;
    other.object = nullptr;
    return *this;
  }

  template <typename Subclass, typename = typename std::enable_if<std::is_convertible<Subclass*, T*>::value, void>::type>
  ObjectPointer& operator = (ObjectPointer<Subclass>&& other) noexcept
  {
    if (object == other.object)
    {
      return *this;
    }
    if (object != nullptr)
    {
      object->decreaseReferenceCount();
    }
    object = other.object;
    other.object = nullptr;
    return *this;
  }

  T& operator * () const noexcept {
    return *object;
  }
   

  T* operator->() const
  {
    return object;
  }

  bool hasPointer()
  {
    return object != nullptr;
  }

  T* get() const
  {
    return object;
  }

  bool operator == (const ObjectPointer& other) const noexcept
  { return object == other.object; }

  //! test inequality of only the pointer values.
  bool operator != (const ObjectPointer& other) const noexcept
  { return object != other.object; }

  //! test equality of only the address pointed to
  bool operator == (T* other) const noexcept
  { return object == other; }

  //! test inequality of only the address pointed to
  bool operator != (T* other) const noexcept
  { return object != other; }

  //! compare the pointer values.
  bool operator < (const ObjectPointer& other) const noexcept
  { return object < other.object; }

  //! compare the pointer values.
  bool operator <= (const ObjectPointer& other) const noexcept
  { return object <= other.object; }

  //! compare the pointer values.
  bool operator > (const ObjectPointer& other) const noexcept
  { return object > other.object; }

  //! compare the pointer values.
  bool operator >= (const ObjectPointer& other) const noexcept
  { return object >= other.object; }

  //! compare the pointer values.
  bool operator < (T* other) const noexcept
  { return object < other; }

  //! compare the pointer values.
  bool operator <= (T* other) const noexcept
  { return object <= other; }

  //! compare the pointer values.
  bool operator > (T* other) const noexcept
  { return object > other; }

  //! compare the pointer values.
  bool operator >= (T* other) const noexcept
  { return object >= other; }

  friend class WeakObjectPointer<T>;

private:
  T * object;
};


/*
  A weak pointer to an Object
*/
template <typename T>
class WeakObjectPointer
{
public:
  WeakObjectPointer();

  WeakObjectPointer(T * t)
  :
  object(t)
  {
    if (t != nullptr)
    {
      weakReferenceCounter = object->referenceCounter;
    }
  }

  ~WeakObjectPointer()
  {}

  WeakObjectPointer(const ObjectPointer<T>& other) noexcept
  : object(other.object),
  weakReferenceCounter(object->referenceCounter)
  {
  }

  WeakObjectPointer(ObjectPointer<T>&& other) noexcept
  :
  object(other.object),
  weakReferenceCounter(object->referenceCounter)
  {
  }

  WeakObjectPointer& operator = (const ObjectPointer<T>& other) noexcept
  {
    object = other.object;
    weakReferenceCounter = other->referenceCounter;
    return *this;
  }

  WeakObjectPointer& operator = (ObjectPointer<T>&& other) noexcept
  {
    object = other.object;
    weakReferenceCounter = other->referenceCounter;
    return *this;
  }

  T* operator->() {
    return object;
  }

  bool isValid() const;
  operator bool () const
  {
    return isValid();
  }

private:
  T * object;
  ObjectPointer<ReferenceCounter> weakReferenceCounter;
};


/*
  The base class for pointer objects, similar to std::enable_shared_from_this.
  In addition to std::shared_ptr it allows to manually increase/decrease the reference count.
  This is useful in cases where you have to pass the raw pointer to an object to somewhere else,
  and you cannot use ObjectPointers.
*/
template <typename T>
class Object
{
public:

  template <typename... Args>
  static ObjectPointer<T> Create(Args&&... args)
  {
    auto t = new T(std::forward<Args>(args)...);
    auto ptr = ObjectPointer<T>(t);
    // Creating an object initializes it with a reference count of 1.
    // The object pointer now takes ownership of the object, and is the only reference to the object.
    // Therefore we have to decrease the count by 1 here.
    ptr->decreaseReferenceCount();
    return ptr;
  }

  Object();
  virtual ~Object() {}

  ObjectPointer<T> getThisPointer()
  {
    T * t = dynamic_cast<T*>(this);
    return ObjectPointer<T>(t);
  }

  void increaseReferenceCount();
  void decreaseReferenceCount();
  int getReferenceCount();

  friend class WeakObjectPointer<T>;
  friend class ObjectPointer<T>;

private:
  ObjectPointer<ReferenceCounter> referenceCounter;
};




template <>
class Object<ReferenceCounter>
{
public:

  template <typename... Args>
  static ObjectPointer<ReferenceCounter> Create(Args&&... args);

  ObjectPointer<Object<ReferenceCounter>> getThisPointer()
  {
    return ObjectPointer<Object<ReferenceCounter>>(this);
  }

  void increaseReferenceCount()
  {
    referenceCountInner++;
  }
  void decreaseReferenceCount()
  {
    referenceCountInner--;
    // std::cout << "Counter Ref count " << referenceCountInner << std::endl;
    if (referenceCountInner <= 0)
    {
        std::cout << "Counter DELETE " << referenceCountInner << std::endl;
        delete this;
    }
  }
  int getReferenceCount()
  {
    return referenceCountInner;
  }

  int referenceCountInner = 0;

};

class ReferenceCounter : public Object<ReferenceCounter>
{
public:
  int objectReferenceCount = 0;
};

template <typename... Args>
ObjectPointer<ReferenceCounter> Object<ReferenceCounter>::Create(Args&&... args)
{
  auto t = new ReferenceCounter(std::forward<Args>(args)...);
  auto ptr = ObjectPointer<ReferenceCounter>(t);
  return ptr;
}

template <typename T>
Object<T>::Object()
:referenceCounter(Object<ReferenceCounter>::Create())
{
  // Creating an object initializes the reference counter to 1.
  increaseReferenceCount();
}

template <typename T>
void Object<T>::increaseReferenceCount()
{
  referenceCounter->objectReferenceCount++;
}

template <typename T>
void Object<T>::decreaseReferenceCount()
{
  referenceCounter->objectReferenceCount--;
    // std::cout << "Class Ref count " << referenceCounter->referenceCountOuter << std::endl;
    // std::cout << "Counter Ref count " << referenceCounter->referenceCountInner << std::endl;
  if (referenceCounter->objectReferenceCount <= 0)
  {
    std::cout << "DELETE" << std::endl;
    delete this;
  }
}

template <typename T>
int Object<T>::getReferenceCount()
{
  return referenceCounter->objectReferenceCount;
}

template <typename T>
WeakObjectPointer<T>::WeakObjectPointer()
:object(nullptr), weakReferenceCounter(Object<ReferenceCounter>::Create())
{}

template <typename T>
bool WeakObjectPointer<T>::isValid() const
{
  return object != nullptr && weakReferenceCounter->objectReferenceCount > 0;
}

template<class T, class U> 
ObjectPointer<T> dynamic_pointer_cast(const ObjectPointer<U>& r) noexcept
{
  if (auto p = dynamic_cast<T*>(r.get())) {
    return ObjectPointer<T>{p};
  } else {
    return ObjectPointer<T>{};
  }
}

}

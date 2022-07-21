#pragma once

namespace fluxe {

template <typename T>
class Nullable
{
public:
    bool isSet;
    T value;

    Nullable()
        : isSet(false)
    {
    }

    Nullable(const T value)
        : isSet(true)
        , value(value)
    {
    }

    void set(T t) {
        value = t;
        isSet = true;
    }

    void unset() {
        isSet = false;
    }

};

}

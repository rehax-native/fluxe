#include <gtest/gtest.h>
#include "../Object.h"
#include <vector>

class ParentTestClass : public fluxe::Object<ParentTestClass>
{
public:
    void parentTest() {}
};

class OtherParentTestClass : public fluxe::Object<ParentTestClass>
{
public:
    void otherParentTest() {}
};

class DerivedTestClass : public ParentTestClass
{
public:
    int derivedTest() {
        return 2;
    }
};

// class OtherDerivedTestClass : virtual public ParentTestClass, virtual public OtherParentTestClass
// {
// public:
//     void otherDerivedTest() {}
// };



TEST(CastTest, BasicAssertions) {

    fluxe::ObjectPointer<ParentTestClass> thing = fluxe::Object<DerivedTestClass>::Create();
    thing->parentTest();

    fluxe::ObjectPointer<DerivedTestClass> derivedThing = fluxe::dynamic_pointer_cast<DerivedTestClass>(thing);
    fluxe::ObjectPointer<ParentTestClass> sameThing = derivedThing;
    int result = derivedThing->derivedTest();

    EXPECT_EQ(result, 2);
    EXPECT_EQ(thing->getReferenceCount(), 3);
    EXPECT_EQ(derivedThing->getReferenceCount(), 3);
    EXPECT_EQ(sameThing->getReferenceCount(), 3);

    // fluxe::ObjectPointer<OtherDerivedTestClass> otherThing = fluxe::Object<OtherDerivedTestClass>::Create();
    // EXPECT_EQ(otherThing->getReferenceCount(), 1);
}

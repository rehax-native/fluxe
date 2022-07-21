#include <gtest/gtest.h>
#include "../Object.h"
#include <vector>

class ReferenceCounterTestClass : public fluxe::Object<ReferenceCounterTestClass>
{
public:
    ReferenceCounterTestClass(std::vector<std::pair<int, std::string>>& events)
    :events(events)
    {
        id = (int) events.size();
        events.push_back({ id, "Create ReferenceCounterTestClass" });
    }

    ~ReferenceCounterTestClass()
    {
        // std::cout << "?" << std::endl;
        events.push_back({ id, "Destroy ReferenceCounterTestClass" });
    }

    std::vector<std::pair<int, std::string>> & events;
    int id = 0;
};

TEST(ReferenceCounterTest, BasicAssertions) {
    std::vector<std::pair<int, std::string>> events;

    fluxe::WeakObjectPointer<ReferenceCounterTestClass> weakPtr;

    {
        auto obj = fluxe::Object<ReferenceCounterTestClass>::Create(events);
        EXPECT_EQ(obj->getReferenceCount(), 1);
        {
            auto nextOne = obj;
            EXPECT_EQ(obj->getReferenceCount(), 2);
            EXPECT_EQ(nextOne->getReferenceCount(), 2);

            auto nextTwo = obj;
            EXPECT_EQ(obj->getReferenceCount(), 3);
            EXPECT_EQ(nextOne->getReferenceCount(), 3);
            EXPECT_EQ(nextTwo->getReferenceCount(), 3);

            weakPtr = nextTwo;

            EXPECT_EQ(weakPtr.isValid(), true);

            {
                auto nextNext = nextTwo;
                EXPECT_EQ(obj->getReferenceCount(), 4);
                EXPECT_EQ(nextOne->getReferenceCount(), 4);
                EXPECT_EQ(nextTwo->getReferenceCount(), 4);
                EXPECT_EQ(nextNext->getReferenceCount(), 4);
            }

            EXPECT_EQ(obj->getReferenceCount(), 3);
            EXPECT_EQ(weakPtr.isValid(), true);
        }

        EXPECT_EQ(obj->getReferenceCount(), 1);

        EXPECT_EQ(events.size(), 1);
        EXPECT_EQ(std::get<0>(events[0]), 0);
        EXPECT_STREQ(std::get<1>(events[0]).c_str(), "Create ReferenceCounterTestClass");
        EXPECT_EQ(weakPtr.isValid(), true);
    }

    EXPECT_EQ(events.size(), 2);
    EXPECT_EQ(std::get<0>(events[0]), 0);
    EXPECT_STREQ(std::get<1>(events[0]).c_str(), "Create ReferenceCounterTestClass");
    EXPECT_EQ(std::get<0>(events[1]), 0);
    EXPECT_STREQ(std::get<1>(events[1]).c_str(), "Destroy ReferenceCounterTestClass");
    EXPECT_EQ(weakPtr.isValid(), false);
}
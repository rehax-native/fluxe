#include <gtest/gtest.h>
#include "../Object.h"
#include <vector>

class ReferenceCounterTreeTestClass : public fluxe::Object<ReferenceCounterTreeTestClass>
{
public:
    ReferenceCounterTreeTestClass(std::vector<std::pair<int, std::string>>& events)
    :events(events)
    {
        id = (int) events.size();
        events.push_back({ id, "Create ReferenceCounterTreeTestClass" });
    }

    ~ReferenceCounterTreeTestClass()
    {
        // std::cout << "?" << std::endl;
        events.push_back({ id, "Destroy ReferenceCounterTreeTestClass" });
    }

    std::vector<std::pair<int, std::string>> & events;
    int id = 0;

    std::vector<fluxe::ObjectPointer<ReferenceCounterTreeTestClass>> children;
    fluxe::WeakObjectPointer<ReferenceCounterTreeTestClass> parent;
};

TEST(ReferenceCounterTreeTest, BasicAssertions) {
    std::vector<std::pair<int, std::string>> events;

    fluxe::WeakObjectPointer<ReferenceCounterTreeTestClass> weakRoot;
    fluxe::WeakObjectPointer<ReferenceCounterTreeTestClass> weakChildChild1;
    fluxe::WeakObjectPointer<ReferenceCounterTreeTestClass> weakChildChild2;
    fluxe::WeakObjectPointer<ReferenceCounterTreeTestClass> weakChild1;
    fluxe::WeakObjectPointer<ReferenceCounterTreeTestClass> weakChild2;

    {
        auto strongRoot = fluxe::Object<ReferenceCounterTreeTestClass>::Create(events);
        weakRoot = strongRoot;
        {
            auto child1 = fluxe::Object<ReferenceCounterTreeTestClass>::Create(events);
            auto child2 = fluxe::Object<ReferenceCounterTreeTestClass>::Create(events);

            weakChild1 = child1;
            weakChild2 = child2;

            strongRoot->children.push_back(child1);
            strongRoot->children.push_back(child2);

            child1->parent = strongRoot;
            child2->parent = strongRoot;

            auto childChild1 = fluxe::Object<ReferenceCounterTreeTestClass>::Create(events);
            auto childChild2 = fluxe::Object<ReferenceCounterTreeTestClass>::Create(events);

            weakChildChild1 = childChild1;
            weakChildChild2 = childChild2;

            child1->children.push_back(childChild1);
            child1->children.push_back(childChild2);

            childChild1->parent = child1;
            childChild2->parent = child1;
        }

        EXPECT_EQ(weakRoot.isValid(), true);
        EXPECT_EQ(weakChild1.isValid(), true);
        EXPECT_EQ(weakChild2.isValid(), true);
        EXPECT_EQ(weakChildChild1.isValid(), true);
        EXPECT_EQ(weakChildChild2.isValid(), true);
    }

    EXPECT_EQ(weakRoot.isValid(), false);
    EXPECT_EQ(weakChild1.isValid(), false);
    EXPECT_EQ(weakChild2.isValid(), false);
    EXPECT_EQ(weakChildChild1.isValid(), false);
    EXPECT_EQ(weakChildChild2.isValid(), false);
}
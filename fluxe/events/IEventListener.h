#pragma once

#include "../misc/Object.h"
#include <unordered_map>
#include <vector>
#include <set>

namespace fluxe {

class IEventListener
{
    virtual ~IEventListener() = default;
};

class IEventListenerContainer 
{
public:
  bool doesSupportEventListener(const std::string eventName);
  std::set<ObjectPointer<IEventListener>> getEventListeners(const std::string eventName);

private:
  // std::unordered_map<std::string, std::set<ObjectPointer<IEventListener>>> eventListeners;
};

}

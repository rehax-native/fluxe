#include "ViewManager.h"

using namespace fluxe;

ViewManager::ViewManager(ObjectPointer<View> view)
:
container(Object<ViewsContainer>::Create(this)),
pipeline(container),
mouseEventsManager(container),
keyboardEventsManager(focusManager)
{
  container->addSubView(view);
}

void ViewManager::setNeedsRerender()
{
  onNeedsRerender();
}

sk_sp<Surface> ViewManager::renderCallback(int width, int height, float scale)
{
  auto surface = pipeline.render(width, height, scale);
  return surface;
}

void ViewManager::mouseCallback(ShellMouseInstruction instruction)
{
  mouseEventsManager.handleInstruction(instruction);
}

void ViewManager::keyCallback(ShellKeyboardKeyInstruction instruction)
{}

void ViewManager::textCallback(std::string str)
{
  keyboardEventsManager.onTextInput(str);
}

void ViewManager::moveCallback(ShellKeyboardMoveInstruction instruction)
{
  keyboardEventsManager.onKeyboardMoveAction(instruction);
}

void ViewManager::onViewAdded(ObjectPointer<View> view)
{}

void ViewManager::onViewRemoved(ObjectPointer<View> view)
{}

FocusManager & ViewManager::getFocusManager()
{
  return focusManager;
}

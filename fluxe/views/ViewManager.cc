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

void ViewManager::renderCallback(int width, int height, float scale, sk_sp<SkSurface> surface)
{
  pipeline.render(width, height, scale, surface);
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

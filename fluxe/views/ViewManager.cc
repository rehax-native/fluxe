#include "ViewManager.h"

using namespace fluxe;

ViewManager::ViewManager(ObjectPointer<View> view)
:
container(Object<ViewsContainer>::Create(this)),
pipeline(container),
mouseEventsManager(this, container),
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
  hasRenderedOnce = true;
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
{
  if (hasRenderedOnce) {
    setNeedsRerender();
  }
}

void ViewManager::onViewRemoved(ObjectPointer<View> view)
{
  setNeedsRerender();
}

FocusManager & ViewManager::getFocusManager()
{
  return focusManager;
}

void ViewManager::showContextMenu(ObjectPointer<View> view)
{
  contextMenu = view;
  container->addSubView(view);
}

ObjectPointer<View> ViewManager::getContextMenu()
{
  return contextMenu;
}

void ViewManager::closeContextMenu()
{
  if (contextMenu.hasPointer()) {
    contextMenu->removeFromParent();
  }
}

#include "EngineUtility.h"
#include "ViewManager.h"

using namespace fluxe;

void EngineUtility::startWithView(ObjectPointer<View> view)
{
  EngineUtility util;
  auto window = util.engine.createPlatformWindow();
  util.initWithWindow(view, window);
}

void EngineUtility::startWithViewAndPlatformView(ObjectPointer<View> view, void * platformView)
{
  EngineUtility util;
  util.initWithPlatformView(view, platformView);
}

void EngineUtility::initWithWindow(ObjectPointer<View> view, void * window)
{
  engine.attachToPlatformWindow(window);
  viewManager = Object<ViewManager>::Create(view);
  viewManager->onNeedsRerender = [this] () {
    engine.setNeedsRerender();
  };
  engine.setRenderCallback([this] (int w, int h, float scale, sk_sp<SkSurface> surface) { viewManager->renderCallback(w, h, scale, surface); });
  engine.setMouseCallback([this] (ShellMouseInstruction instruction) { return handleMouseCallback(instruction); });
  engine.setKeyCallback([this] (ShellKeyboardKeyInstruction instruction) { return handleKeyCallback(instruction); });
  engine.setMoveCallback([this] (ShellKeyboardMoveInstruction instruction) { return handleMoveCallback(instruction); });
  engine.setTextCallback([this] (const char * str) { return viewManager->textCallback(std::string(str)); });
  engine.setCanHandleKeyboardCommandCallback([this] (ShellKeyboardCommand command) { return viewManager->isHandlingKeyboardCommand(command); });
  engine.setKeyboardCommandCallback([this] (ShellKeyboardCommand command) { return viewManager->handleKeyboardCommand(command); });
  // engine.setClipboardCallback([this] (ShellClipboardInstruction instruction) { return viewManager->clipboardCallback(instruction); });
  engine.startMainLoop();
  engine.detachFromPlatformWindow();
  engine.closePlatformWindow(window);
}

void EngineUtility::initWithPlatformView(ObjectPointer<View> view, void * platformView)
{
  engine.attachToPlatformView(platformView);
  viewManager = Object<ViewManager>::Create(view);
  viewManager->onNeedsRerender = [this] () {
    engine.setNeedsRerender();
  };
  engine.setRenderCallback([this] (int w, int h, float scale, sk_sp<SkSurface> surface) { viewManager->renderCallback(w, h, scale, surface); });
  engine.setMouseCallback([this] (ShellMouseInstruction instruction) { return handleMouseCallback(instruction); });
  engine.setKeyCallback([this] (ShellKeyboardKeyInstruction instruction) { return handleKeyCallback(instruction); });
  engine.setMoveCallback([this] (ShellKeyboardMoveInstruction instruction) { return handleMoveCallback(instruction); });
  engine.setTextCallback([this] (const char * str) { return viewManager->textCallback(std::string(str)); });
  engine.setCanHandleKeyboardCommandCallback([this] (ShellKeyboardCommand command) { return viewManager->isHandlingKeyboardCommand(command); });
  engine.setKeyboardCommandCallback([this] (ShellKeyboardCommand command) { return viewManager->handleKeyboardCommand(command); });
  // engine.setClipboardCallback([this] (ShellClipboardInstruction instruction) { return viewManager->clipboardCallback(instruction); });
}

void EngineUtility::handleMouseCallback(ShellMouseInstruction instruction)
{
  viewManager->mouseCallback(instruction);
}

void EngineUtility::handleKeyCallback(ShellKeyboardKeyInstruction instruction)
{
  viewManager->keyCallback(instruction);
}

void EngineUtility::handleMoveCallback(ShellKeyboardMoveInstruction instruction)
{ 
  viewManager->moveCallback(instruction);
}

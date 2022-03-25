#pragma once

namespace fluxe {

/**
 * The fluxe engine is the main entry point if you want to use fluxe in your application.
 * You can either use an existing window and main loop and attach the engine to it,
 * or use the Engine's methods to create a window and set up a run loop for you.
 */
class Engine {

  public:

  Engine();
  ~Engine();

  /**
   * Create a platform native window which can be attached to.
   * A platform native window is a NSWindow on mac, HWND on Win, etc.
   */
  void * createPlatformWindow();

  /**
   * Close a platform native window which was created with `createPlatformWindow()`.
   */
  void closePlatformWindow(void * window);

  /**
   * Attach the engine to a native platform window.
   */
  void attachToPlatformWindow(void * platformWindow);

  /**
   * Detach the engine from the native platform window it is currently attached to.
   */
  void detachFromPlatformWindow();

  /**
   * Set the root object of the engine.
   */
  void setRootObject(Object * object);

  /**
   * Start the main run loop. Call this if you don't have an existing run loop and want fluxe to create one for you.
   * This call is blocking. It is exited when `stopMainLoop()` is called.
  */
  void startMainLoop();

  /**
   * Stops the main run loop.
   */
  void stopMainLoop();

  /**
   * Start the engine without running a main loop. Call this if you have an existing run loop.
   * If you use this method, you are responsible for forwarding events to the engine, such as pointer, keyboard, window events.
   * This call is non blocking. When you're done, stop the engine with `stopEngine()`.
  */
  void startEngine();

  /**
   * Stop the engine that has been started with `startEngine()`.
  */
  void stopEngine();

  // pointer events
  // onMouseButtonDown
  // onMouseButtonUp
  // onMouseLocation

  // keyboard events
  // onKeyDown
  // onKeyUp

  // window events
  // onWindowReize
  // onWindowMove

};

}

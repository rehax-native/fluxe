Typically, if you want to let fluxe take care of everything, you initialize the engine like this:

```
int main()
{
  auto engine = new Engine();
  auto window = engine->createPlatformWindow();
  engine->attachToPlatformWindow(window);

  // Create the root object you want to show
  auto object = ...;
  engine->setRootObject(object);

  // This call will block execution until `engine->stopMainLoop();` is called elsewhere
  engine->startMainLoop();

  engine->detachFromPlatformWindow();
  engine->closePlatformWindow(window);

  return 0;
}
```

If you already have an existing window and want to set up fluxe in that window, you would do:

```
Engine * engine;

void setup(void * platformWindow)
{
  engine = new Engine();
  engine->attachToPlatformWindow(window);

  // Create the root object you want to show
  auto object = ...;
  engine->setRootObject(object);

  engine->startEngine();
} 

void teardown()
{
  engine->stopEngine();
  engine->detachFromPlatformWindow();
}

// If you use an existing run loop you are responsible for sending events to the engine.
// [TBD]
void onKeyDown()
{
  engine->onKeyDown();
}

// [Other events]
```
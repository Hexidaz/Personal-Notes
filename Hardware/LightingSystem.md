# Lighting System

## Triac Dimmer
Mostly used for old incandescnet bulbs and usually dimmed by chopping AC input voltage (AC PWM) that goes into the bulbs.

### Components
- Dimmer Switch (usually dial like)
- Any incandescent bulbs which works by heating up coil under vacuum or 
- Any dimmable AC light bulb (for led bulbs) (example dimmable led bulb)

## 0-10V / 1-10V Dimmer
It is a contorl interface that uses 0-10V / 1-10V to define brightness. Widely used for fancy led strips rarely used for bulbs but possible. Has the potential to control the brightness form 0% to 100% brightness with linear smoothness.

### Components
- Switches (0-10V / 1-10V)
- Driver (Power supply with variable voltage depending on controller input, usually constant current)
	> This Driver comes in several types, some can only control triacs and some only controls dc lights
- LED / bulbs with dimmer support

## Dali
It is a control interface with support for addressing. Mostly used for on a very exclusive places (e.g. mansion, ballroom, etc.). This control interface works as if each devices has its own IP.

### Components
- Controller (Dali Controller)
- Switches (manual light control) (optional)
- Driver (to control the lights)
- LED / bulbs with dimmer support
- Sensors (optional, as Dali works with addressing, you can actually program the controller for groupings, automation, etc.)
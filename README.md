# Enchanté
**Enchanté is my personal PCB business card.** It has been designed to show some of my skills while looking for a job. 
<p align="center">
<img src="https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Enchante-side.png" alt="Enchanté top view" width="" height="">
</p>
The small board (77 x 55 mm) features a **capacitive touch sensor (iPod wheel style)**, some **LEDs for animation and interaction with the touch sensor** and an [**NFC chip**](http://www.st.com/content/st_com/en/products/nfc/st25-nfc-rfid-tags-readers/dynamic-nfc-tags/m24sr-series-dynamic-nfc-tags/m24sr04-y.html) with an **onboard PCB loop antenna**. The NFC will opens the browser with my LinkedIn profile and add my contact info the phone's address book.
The bonus feature is a **PCB reference on the back of the board** (only footprints, no component will be soldered) with:

- Resistor/capacitor/inductor/diode footprints
- Common surface mount component footprints
- Common electrical symbols
- Common conversions
- Trace size comparison
- Font size comparison

Hopefully this will be useful for EEs and will save this business card from ending up in the trash.
<p align="center">
<img src="https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Enchante-bottom.png" alt="Enchanté top view" width="" height="250">
</p>
A TI [MSP430](http://www.ti.com/product/MSP430FR2532/technicaldocuments) microcontroller with CapTIvate touch technology capability handles all the touch functionalities and LED control.
There is a connectorless programming adapter. Just a few exposed pads to do all the programming without having pin headers onboard, this makes the card much easier to carry around.

The board is powered by a 3V CR2032 coin cell battery. A [Boost](http://www.ti.com/product/TLV61225) converter is available to provide a stable 3.3V over the battery’s operating range. This enables energy-harvesting and optimizes the power efficiency.

This board is also a playground for me to learn about technologies I'm not familiar with, specifically NFC. 
The first version of this business card is very expensive. For ten units, the total cost per board is ~11.6$ and can be as low as ~10$ if the boost converter is not populated (which is possible in the schematic).
The BOM cost is ~8$ and the PCB is ~3.6$ (ordered on [Elecrow](https://www.elecrow.com/)). A detailed BOM is [available here](https://docs.google.com/spreadsheets/d/1eNP5zuFRfIdvhxHwnxUuVc3rJX5olWzpR0HwWWoFab0/edit?usp=sharing).
One of the goals for the next iteration would be to make it much cheaper.

## Directory Structure
This repository contains the hardware sources of the board. Although made with Altium Designer, the schematic is available in PDF and the layout is available in Gerber. 
I do not plan to convert the files to KiCad/Eagle at the moment but there are [some converters](https://github.com/thesourcerer8/altium2kicad) you can use.

    Enchanté
    ├── Antenna generation -- OpenSCAD scripts to generate the DXF of the NFC loop antenna
    ├── Board shape -- OpenSCAD scripts to generate the DXF of the board's shape
    ├── Enchante.OutJob
    ├── Enchante.PcbDoc -- PCB Layout
    ├── Enchante.PrjPcb
    ├── Enchante.PrjPcbStructure
    ├── Enchante.SchDoc -- Schematic
    ├── Images -- Images for the README
    ├── Librairies -- Altium component libraries
    └── Project Outputs for Enchante
        ├── Enchante.pdf -- PDF Schematic, layout 2D/3D view
        ├── Enchante_BOM.xls -- BOM
        ├── Gerber -- Gerber fabrication files
        └── NC Drill -- Drill fabrication files

## Hardware source files
### Schematic
[![alt text][2]][1]
  [1]: https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Enchante-schematic.png
  [2]: https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Enchante-schematic.png (Enchanté's Schematics)
### Layout
[![alt text][3]][4]
  [4]: https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Enchante-multi-layout.png
  [3]: https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Enchante-multi-layout.png (Enchanté's Layout)
  
 - Green: top overlay 
 - Red: top copper
 - Blue: bottom copper
 - Yellow: bottom overlay

## Documentation
### Antenna Design
NFC (radio-frequency identification) tags extract all of their power from the reader’s field. The tags’ and reader’s antennas form a system of coupled inductances. The loop antenna of the tag (this board) acts as a transformer’s secondary.
The design principle of the NFC antenna is simple: the external antenna inductance (Lantenna) that needs to be designed on board the PCB should match the NFC chip internal tuning capacitance (Ctuning) in order to create a circuit resonating at 13.56 MHz:
<p align="center">
<img src="https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/Tuning_eq.png" alt="Tuning frequency" width="" height="40">
</p>
The full equations are available in ST's application notes [AN2972](http://www.st.com/content/ccc/resource/technical/document/application_note/bc/ac/13/fe/69/fb/49/8a/CD00232630.pdf/files/CD00232630.pdf/jcr:content/translations/en.CD00232630.pdf) and [AN2866](http://www.proxmark.org/files/Documents/Antennas/How%20to%20design%20a%2013.56%20MHz%20customized%20tag%20antenna.pdf) and TI's application note [SLOA197](http://www.ti.com/lit/an/sloa197/sloa197.pdf).
The antenna fine tuning is done by adjusting the antenna resonance frequency. The parallel capacitors C12 is added to bring the resonance frequency close to 13.56 MHz. C13 & C14 are part of the matching network.
A resistor R7 is added to tune the Quality factor if needed (should be Q < 50).
In this case, the calculated target inductance is 5.398 uH. 
The next step is to choose the shape of the antenna and determine its physical dimensions. A rectangular loop seems to be the usual shape for this type of design. ST provides an [online tool](https://my.st.com/analogsimulator/flex_app/bin/eds_antenna_design.html?msg=%7B%22action%22:%22new_design%22%7D) to help with the math:
![ST eDesignSuite](https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Antenna%20generation/eDesignSuite.png)
Now we need to create the component in the ECAD software (Altium Designer in this case). I was very surprised to find no integrated/easy way to do this. My workflow for this step is as follows:

 1. Create a DXF with the above geometry
 2. Import the DXF in Altium Designer, add vias and create a component

To create the DXF with this geometry, I wrote an [OpenSCAD script](https://github.com/MrZeroo00/Enchante/blob/master/Antenna%20generation/loop_antenna_generator.scad) to handle the job. It takes the following parameters and generates an STL of the desired geometry:

    // Geometry
    loops = 12;
    length = 29.6;
    width = 30;
    copper_width = 0.3;
    copper_spacing = 0.3;
    thickness = 0.03556;
<p align="center">
<img src="https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/openscad_antenna_generator.png" alt="OpenSCAD antenna generation script">
</p>
The next step is to convert the STL to a 2D object and generate a DXF, this is handled by [another OpenSCAD script](https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Antenna%20generation/stl2dxf.scad).
The DXF is then imported in Altium Designer and the component is created by adding two vias to both ends of the antenna. The result in [this Altium Integrated Library.](https://github.com/MrZeroo00/Enchante/raw/master/Librairies/NFC_Antenna/Project%20Outputs%20for%20NFC_Antenna/NFC_Antenna.IntLib)
This maybe overcomplicated, if you find a better way of doing it, please shoot me an [email](mailto:bouslikhin.badr@gmail.com)!

There should be no copper near and especially under the antenna! I used a Polygon Pour coutout on both layers to keep the polygons pour from the desired region.
### Capacitive Sensor Design
Capacitive sensing performs a measurement to detect a capacitive change to a sensor element. A sensor element can be any conductive material (copper PCB plane, a wire, etc.) and the change is due to human interaction, such as a finger, ear, or hand. A touch causes the capacitance of the electrode to increase (typically 1-10pF).
Although expensive, the [TI MSP430FR2532](http://www.ti.com/product/MSP430FR2532/technicaldocuments) microcontroller features CapTIvate touch technology for buttons, sliders, wheels (BSW), and proximity applications. This MCU has hardware blocks dedicated to this measurement hence making it much easier for me.

This technology uses Charge transfer technique to measure a change in capacitance. 
Since we are interested in the change in capacitance and not the absolute value, the basic principle of this technique relies on charge transfer between two capacitors: an unknown capacitor Ctouch we are trying to monitor and a know capacitor Cref (larger enough, ~ tens of pF). Ctouch is filled (charged) and then emptied (transferred) into the Cref. The number of times it takes to fill the Cref is representative of the capacitance of the Ctouch. **If the number of times it takes to fill Cref changes, then the capacitance of Ctouch has changed.**
Further information can be found in TI's [CapTIvate™ Technology Guide](http://software-dl.ti.com/msp430/msp430_public_sw/mcu/msp430/CapTIvate_Design_Center/latest/exports/docs/users_guide/html/index.html).

I chose to implement a wheel and a touch button in the middle. The first complexity of this type of implementation comes from the design of the sensor. In this case I used a spatially interpolated wheel with 3 electrodes connected to 3 different sensing channels of the MCU. 
<p align="center">
<img src="https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/wheel_example_atmel.png" alt="Example of a 3 channels wheel">
</p>
The geometry is once again not trivial to draw in ECAD software. There are few options to do so:

 1. Use OpenSCAD again and import the DXF into Altium to create the component. This approach has been realized in [this design](https://bryanduxbury.com/2013/12/05/designing-a-capacitive-touch-wheel-in-openscad-and-eagle/).
 2. Use [Atmel's touch library](https://techdocs.altium.com/display/ADOH/Support+for+Atmel+Touch+Controls) add-on to Altium.
 3. Copy paste the sensor from TI's [CapTIvate reference design](http://www.ti.com/tool/msp-capt-fr2633). 

The lazy me chose the third option. I only resized the component to meet my needs.

The other touch electrode is a simple button consisting of a copper pad and a via to connect it to the MCU. This one was easy to implement.

Ground planes are necessary to shield the design and protect it from radiated and conducted interference. This is conflicting with the need to minimize the parasitic capacitance (the sensor's sensitivity increases with the decrease of the parasitic capacitance) between the electrode and the ground pour. This is why on the bottom layer, the ground pour is hatched.
<p align="center">
<img src="https://raw.githubusercontent.com/MrZeroo00/Enchante/master/Images/bottom_ground_pour.png" alt="Hatched ground pour on the bottom layer" width="" height="250">
</p>
It is also recommended leaving 4 mm between the capacitive touch trace and any digital signal/ground pour to minimize coupling. 

### Hardware validation

> Done

The boards work perfectly! More details to come here.
###Software
> Done

Done. Code and details coming soon.
For any further information or inquiry, please contact [bouslikhin.badr[at]gmail[dot]com](mailto:bouslikhin.badr@gmail.com)

Sensor Graphs
================

Downloading
-----------

These files include script for downloading from <http://readings.newton.edyn.com> based on numbers of readings. The functions allow you to choose with of the parameters to plot:

1.  battery
2.  humidity
3.  temperature
4.  electrical\_conductivity
5.  light
6.  capacitance

The functions inlcude options to save both the generated graphs (.png) and the tabulated data (.csv).

note: capacitance has been converted to %vwc using log(capacitance)^2 \* 1.3104 + 15.541 \* log(capacitance) + 45.654 For most of the files, the resultant %vwc is cleaned up by removing &lt; 2 | &lt; 65 values. All other graphs are the raw parameter values.

Packages needed
---------------

The code assumes you have jsonlite and gsheet libraries. If not, please run the following code:

    install.packages("jsonlite")
    install.packages("gsheet")

Valve test
----------

This graphing file includes modifications to read a linked gsheet for building subsets. The sharing permissions may have to be temporarily altered for the link to work. Please always change the sharing permissions immediately back to their original settings after importing the data.

Example plot
------------

(coming in next update)

/**
 * Created by azure on 2015-07-22.
 */
function initWiseGrid(objName, width, height) {

    var WISEGRID_TAG = "<OBJECT ID='" + objName + "' codebase='/js/everuxf/lib/wisegrid/wiseGrid.cab#version=5,3,1,29'";
    WISEGRID_TAG = WISEGRID_TAG + " NAME='" + objName + "' WIDTH=" + width + " HEIGHT=" + height + " border=0";
    WISEGRID_TAG = WISEGRID_TAG + " CLASSID='CLSID:E8AA1760-8BE5-4891-B433-C53F7333710F'>";
    WISEGRID_TAG = WISEGRID_TAG + " <PARAM NAME = 'strLicenseKeyList' VALUE='1DF1EA5D002442FF18F53D10DEDD42D3'>";
    WISEGRID_TAG = WISEGRID_TAG + "</OBJECT>";

    document.write(WISEGRID_TAG);
}
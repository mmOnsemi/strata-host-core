/*
 * Copyright (c) 2018-2021 onsemi.
 *
 * All rights reserved. This software and/or documentation is licensed by onsemi under
 * limited terms and conditions. The terms and conditions pertaining to the software and/or
 * documentation are available at http://www.onsemi.com/site/pdf/ONSEMI_T&C.pdf (“onsemi Standard
 * Terms and Conditions of Sale, Section 8 Software”).
 */
function Component() {}

Component.prototype.createOperations = function()
{
    // call default implementation
    component.createOperations();

    // Install Microsoft Visual C++ 2017 X64 Additional Runtime
    if (Component.prototype.isFTDIInstalled() == false)  {
        console.log("installing FTDI CDM Drivers...");
        // status code 512 means succefull installaion
        // status code 2 means succefull installation with a device plugged in
        component.addElevatedOperation("Execute", "{2,512}", installer.value("TargetDir").split("/").join("\\") + "\\StrataUtils\\FTDI\\dpinst-amd64.exe", "/S", "/SE", "/F");
    } else {
        console.log("FTDI CDM Drivers already installed");
    }
}


// Return 1 if a > b
// Return -1 if a < b
// Return 0 if a == b
function compare(a, b) {
    if (a === b) {
       return 0;
    }

    var a_components = a.split(".");
    var b_components = b.split(".");

    var len = Math.min(a_components.length, b_components.length);

    // loop while the components are equal
    for (var i = 0; i < len; i++) {
        // A bigger than B
        if (parseInt(a_components[i]) > parseInt(b_components[i])) {
            return 1;
        }

        // B bigger than A
        if (parseInt(a_components[i]) < parseInt(b_components[i])) {
            return -1;
        }
    }

    // If one's a prefix of the other, the longer one is greater.
    if (a_components.length > b_components.length) {
        return 1;
    }

    if (a_components.length < b_components.length) {
        return -1;
    }

    // Otherwise they are the same.
    return 0;
}

function getVersion(a) {
    if (a == null) {
       return "";
    }

    var a_components = a.split(" ");    // example "08/16/2017 2.12.28"
    var len = a_components.length;

    if (len == 0) {
        return a;       // maybe different in other version
    } else if (len == 1) {
        return a;       // maybe different in other version
    } else if (len == 2) {
        return a_components[1];         // we need the second half
    } else {
        return a;
    }
}

function getPowershellElement(str, element_name) {
    var res = [];
    var x = str.split('\r\n');
    var m = 0;
    for(var i = 0; i < x.length; i++){
        var n = x[i].indexOf(element_name);
        if (n == 0) {
            m = x[i].indexOf(": ", n + element_name.length);
            m += ": ".length;
            res.push(x[i].slice(m));
        } else if (m > 0) {
            if (x[i].charAt(0) == " ") {
                res[res.length-1] = res[res.length-1].concat(" " + x[i].slice(m));
            } else {
                m = 0;
            }
        }
    }

    return res;
}

Component.prototype.isFTDIInstalled = function()
{
    var programName = "Windows Driver Package \\- FTDI CDM Driver Package";
    var powerShellCommand = "(Get-ChildItem -Path HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall, HKLM:\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Uninstall, HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -match '" + programName + "' })";

    console.log("executing powershell command '" + powerShellCommand + "'");
    // the installer is 32bit application :/ it will not find 64bit registry entries unless it is forced to open 64bit binary
    var isInstalled = installer.execute("C:\\Windows\\SysNative\\WindowsPowerShell\\v1.0\\powershell.exe", ["-command", powerShellCommand]);

    // the output of command is the first item, and the return code is the second
    // console.log("execution result code: " + isInstalled[1] + ", result: '" + isInstalled[0] + "'");

    if ((isInstalled[0] != null) && (isInstalled[0] != undefined) && (isInstalled[0] != "")) {
        var up_to_date = false;

        var display_name = getPowershellElement(isInstalled[0], 'DisplayName');
        var display_version = getPowershellElement(isInstalled[0], 'DisplayVersion');
        var uninstall_string = getPowershellElement(isInstalled[0], 'UninstallString');

        console.log("found DisplayName: '" + display_name + "', DisplayVersion: '" + display_version + "', UninstallString: '" + uninstall_string + "'");

        // we should not find multiple entries here, but just in case, check the highest
        if ((display_name.length != 0) && ((display_name.length == display_version.length) && (display_name.length == uninstall_string.length))) {
            for (var i = 0; i < display_version.length; i++) {

                var result = compare(getVersion(display_version[i]), component.value("Version"));    // example "08/16/2017 2.12.28"

                if (result == 1) {
                    up_to_date = true;
                    console.log("program is newer version, DisplayVersion: '" + display_version[i] + "', MyVersion: '" + component.value("Version") + "'");
                } else if (result == 0) {
                    up_to_date = true;
                    console.log("program is the same version, DisplayVersion: '" + display_version[i] + "', MyVersion: '" + component.value("Version") + "'");
                } else {
                    console.log("program is older, will replace with new version if newer is not available, DisplayVersion: '" + display_version[i] + "', MyVersion: '" + component.value("Version") + "'");
                    console.log("executing FTDI uninstall command: '" + uninstall_string[i] + "'");
                    var e = installer.execute(uninstall_string[i], ["/SW"]);
                    console.log(e);
                }
            }
        }

        return up_to_date;
    } else {
        console.log("program not found, will install new version");
        return false;
    }
}

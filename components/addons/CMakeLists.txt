##
## Copyright (c) 2018-2021 onsemi.
##
## All rights reserved. This software and/or documentation is licensed by onsemi under
## limited terms and conditions. The terms and conditions pertaining to the software and/or
## documentation are available at http://www.onsemi.com/site/pdf/ONSEMI_T&C.pdf (“onsemi Standard
## Terms and Conditions of Sale, Section 8 Software”).
##
if (CMAKE_BUILD_TYPE STREQUAL "OTA")
    project(Addons
        DESCRIPTION "Strata Addons"
        LANGUAGES NONE
    )

    set(PROJECT_BUNDLE_ID com.onsemi.strata.addons)

    add_custom_target(${PROJECT_NAME})
    generate_ifw_version(GITTAG_PREFIX "addons_")
endif()


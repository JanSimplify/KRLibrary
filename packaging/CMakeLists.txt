# SPDX-License-Identifier: MIT-0
# SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify

#=============================
# Variables
#=============================

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

set(runtime_component "${PROJECT_NAME}_Runtime")
set(development_component "${PROJECT_NAME}_Development")

if(enable_install_shared)
    list(APPEND install_targets ${shared_target})
    list(APPEND install_exports ${shared_export})
endif()

if(enable_install_static)
    list(APPEND install_targets ${static_target})
    list(APPEND install_exports ${static_export})
endif()

set(config_install_dir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")

set(autogen_cmake_dir "${autogen_root}/cmake")
set(autogen_package_config "${autogen_cmake_dir}/${PROJECT_NAME}Config.cmake")
set(autogen_package_version_file "${autogen_cmake_dir}/${PROJECT_NAME}ConfigVersion.cmake")

#=============================
# Package version
#=============================

write_basic_package_version_file(
    "${autogen_package_version_file}"
    VERSION "${PROJECT_VERSION}"
    COMPATIBILITY "SameMinorVersion"
)

#=============================
# Package config
#=============================

configure_package_config_file(
    "ProjectConfig.cmake.in"
    "${autogen_package_config}"
    INSTALL_DESTINATION "${config_install_dir}"
    PATH_VARS config_install_dir
    NO_SET_AND_CHECK_MACRO
    NO_CHECK_REQUIRED_COMPONENTS_MACRO
)

#=============================
# Install
#=============================

install(
    FILES
        "${autogen_package_config}"
        "${autogen_package_version_file}"
    DESTINATION "${config_install_dir}"
    COMPONENT "${development_component}"
)

foreach(target_name export_name IN ZIP_LISTS install_targets install_exports)
    install(
        TARGETS ${target_name}
        EXPORT ${export_name}
        RUNTIME
            COMPONENT "${runtime_component}"
        BUNDLE
            COMPONENT "${runtime_component}"
        LIBRARY
            COMPONENT "${runtime_component}"
            NAMELINK_COMPONENT "${development_component}"
        ARCHIVE
            COMPONENT "${development_component}"
        FILE_SET
            ${header_set}
            COMPONENT "${development_component}"
        )

    install(
        EXPORT ${export_name}
        DESTINATION "${config_install_dir}"
        NAMESPACE "${PROJECT_NAME}::"
        COMPONENT "${development_component}"
    )
endforeach()

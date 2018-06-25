Return-Path: <SRS0=jM0/=JL=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:43375 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934531AbeFYPBt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 25 Jun 2018 11:01:49 -0400
Received: by mail-wr0-f194.google.com with SMTP id c5-v6so2867294wrs.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 25 Jun 2018 08:01:49 -0700 (PDT)
From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/7] Introduce the very basic part of the C API of KS-1.0
Date: Mon, 25 Jun 2018 18:01:14 +0300
Message-Id: <20180625150121.14291-1-y.karadz@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the first part of the C API used by the
Qt-based version of KernelShark. This part of the API is responsible for
loading trace data files and for filtering of this data. Examples,
demonstration the usage of this part of the API are added as well.
The code can be found also here:
https://github.com/yordan-karadzhov/trace-cmd_qtdev.git

Yordan Karadzhov (VMware) (7):
  kernel-shark-qt: Add Cmake build system for the Qt based KernelShark
  kernel-shark-qt: Automatic generation of doxygen documentation
  kernel-shark-qt: Add API for loading trace.dat files
  kernel-shark-qt: Add an example showing how to load trace data
  kernel-shark-qt: Add a README file to trace-cmd/kernel-shark-qt
  kernel-shark-qt: Add filtering to the C API of KernelShark
  kernel-shark-qt: Add an example showing how to filter trace data

 kernel-shark-qt/CMakeLists.txt           |   53 +
 kernel-shark-qt/README                   |   37 +
 kernel-shark-qt/build/FindTraceCmd.cmake |   70 +
 kernel-shark-qt/build/cmake_clean.sh     |   11 +
 kernel-shark-qt/build/deff.h.cmake       |   20 +
 kernel-shark-qt/doc/dox_config           | 2291 ++++++++++++++++++++++
 kernel-shark-qt/examples/CMakeLists.txt  |    9 +
 kernel-shark-qt/examples/datafilter.c    |  114 ++
 kernel-shark-qt/examples/dataload.c      |   80 +
 kernel-shark-qt/src/CMakeLists.txt       |   13 +
 kernel-shark-qt/src/libkshark.c          |  579 ++++++
 kernel-shark-qt/src/libkshark.h          |  232 +++
 12 files changed, 3509 insertions(+)
 create mode 100644 kernel-shark-qt/CMakeLists.txt
 create mode 100644 kernel-shark-qt/README
 create mode 100644 kernel-shark-qt/build/FindTraceCmd.cmake
 create mode 100755 kernel-shark-qt/build/cmake_clean.sh
 create mode 100644 kernel-shark-qt/build/deff.h.cmake
 create mode 100644 kernel-shark-qt/doc/dox_config
 create mode 100644 kernel-shark-qt/examples/CMakeLists.txt
 create mode 100644 kernel-shark-qt/examples/datafilter.c
 create mode 100644 kernel-shark-qt/examples/dataload.c
 create mode 100644 kernel-shark-qt/src/CMakeLists.txt
 create mode 100644 kernel-shark-qt/src/libkshark.c
 create mode 100644 kernel-shark-qt/src/libkshark.h

-- 
2.17.1

Return-Path: <SRS0=XDEQ=MW=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-dm3nam03on0085.outbound.protection.outlook.com ([104.47.41.85]:42585
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727523AbeJKDeh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Oct 2018 23:34:37 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] Add basic components to be used by the Qt GUI
Date: Wed, 10 Oct 2018 23:10:11 +0300
Message-Id: <20181010201015.23824-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the first components of the Qt-based
KernelShark GUI. It includes some basic utils, as well as various small
widgets and dialogues used by the GUI. The GUI itself will be introdused
in the following series.

Yordan Karadzhov (VMware) (4):
  kernel-shark-qt: Add Qt as a third party dependency.
  kernel-shark-qt: Add KernalShark Utils
  kernel-shark-qt: Add Widgets Lib
  kernel-shark-qt: Add widget demo example.

 kernel-shark-qt/CMakeLists.txt          |   8 +
 kernel-shark-qt/README                  |   6 +-
 kernel-shark-qt/build/deff.h.cmake      |  16 +
 kernel-shark-qt/examples/CMakeLists.txt |   4 +
 kernel-shark-qt/examples/widgetdemo.cpp | 158 +++++
 kernel-shark-qt/src/CMakeLists.txt      |  22 +
 kernel-shark-qt/src/KsUtils.cpp         | 594 ++++++++++++++++
 kernel-shark-qt/src/KsUtils.hpp         | 233 +++++++
 kernel-shark-qt/src/KsWidgetsLib.cpp    | 878 ++++++++++++++++++++++++
 kernel-shark-qt/src/KsWidgetsLib.hpp    | 385 +++++++++++
 10 files changed, 2303 insertions(+), 1 deletion(-)
 create mode 100644 kernel-shark-qt/examples/widgetdemo.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.hpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.cpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.hpp

-- 
2.17.1

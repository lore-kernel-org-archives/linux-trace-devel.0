Return-Path: <SRS0=f4gm=MU=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37880 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbeJHW24 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Oct 2018 18:28:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id 185-v6so8720519wmt.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Oct 2018 08:16:43 -0700 (PDT)
From: Yordan Karadzhov <y.karadz@gmail.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/4] Add basic components to be used by the Qt GUI
Date: Mon,  8 Oct 2018 18:16:25 +0300
Message-Id: <20181008151629.13973-1-ykaradzhov@vmware.com>
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
 kernel-shark-qt/examples/widgetdemo.cpp | 159 +++++
 kernel-shark-qt/src/CMakeLists.txt      |  22 +
 kernel-shark-qt/src/KsUtils.cpp         | 584 ++++++++++++++++
 kernel-shark-qt/src/KsUtils.hpp         | 231 +++++++
 kernel-shark-qt/src/KsWidgetsLib.cpp    | 873 ++++++++++++++++++++++++
 kernel-shark-qt/src/KsWidgetsLib.hpp    | 370 ++++++++++
 10 files changed, 2272 insertions(+), 1 deletion(-)
 create mode 100644 kernel-shark-qt/examples/widgetdemo.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.hpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.cpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.hpp

-- 
2.17.1

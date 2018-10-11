Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0088.outbound.protection.outlook.com ([104.47.36.88]:3680
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730301AbeJLAZp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Oct 2018 20:25:45 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v3 0/4] Add basic components to be used by the Qt GUI
Date: Thu, 11 Oct 2018 16:57:37 +0000
Message-ID: <20181011165713.15257-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches introduces the first components of the Qt-based
KernelShark GUI. It includes some basic utils, as well as various small
widgets and dialogues used by the GUI. The GUI itself will be introdused
in the following series.

This is the second version of this series of patches. It includes a
code rebase, after pulling the latest patches from upstream.

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
 kernel-shark-qt/src/KsWidgetsLib.cpp    | 881 ++++++++++++++++++++++++
 kernel-shark-qt/src/KsWidgetsLib.hpp    | 385 +++++++++++
 10 files changed, 2306 insertions(+), 1 deletion(-)
 create mode 100644 kernel-shark-qt/examples/widgetdemo.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.cpp
 create mode 100644 kernel-shark-qt/src/KsUtils.hpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.cpp
 create mode 100644 kernel-shark-qt/src/KsWidgetsLib.hpp

--=20
2.17.1

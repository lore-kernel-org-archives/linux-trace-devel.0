Return-Path: <SRS0=g7z+=NM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr810073.outbound.protection.outlook.com ([40.107.81.73]:3002
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727753AbeKBGuY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Nov 2018 02:50:24 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/8] This series of patches contains various independent
Date: Thu, 1 Nov 2018 21:45:36 +0000
Message-ID: <20181101214512.18684-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Yordan Karadzhov (8):
  kernel-shark-qt: Free all collections when closing the trace file.
  kernel-shark-qt: Fix potential memory leak when searching in
    collections
  kernel-shark-qt: Put error messages always on top
  kernel-shark-qt: Fix bug when loading the Dual Marker
  kernel-shark-qt: Fix bug when loading plugins from session
  kernel-shark-qt: Fix bug when resizing the KS window for session
  kernel-shark-qt: Change the color convention of the task graphs
  kernel-shark-qt: Remove duplicate code in KsWidgetsLib.cpp

 kernel-shark-qt/examples/dataplot.cpp |  30 +++--
 kernel-shark-qt/src/KsGLWidget.cpp    |  15 ++-
 kernel-shark-qt/src/KsGLWidget.hpp    |   2 +
 kernel-shark-qt/src/KsMainWindow.cpp  |  12 +-
 kernel-shark-qt/src/KsMainWindow.hpp  |  10 +-
 kernel-shark-qt/src/KsPlotTools.cpp   | 152 ++++++++++++++++----------
 kernel-shark-qt/src/KsPlotTools.hpp   |  45 ++++++--
 kernel-shark-qt/src/KsSession.cpp     |  46 +++++---
 kernel-shark-qt/src/KsSession.hpp     |   4 +-
 kernel-shark-qt/src/KsWidgetsLib.cpp  |  28 ++---
 kernel-shark-qt/src/libkshark-model.c |   8 +-
 kernel-shark-qt/src/libkshark.c       |   7 ++
 12 files changed, 233 insertions(+), 126 deletions(-)

--=20
2.17.1

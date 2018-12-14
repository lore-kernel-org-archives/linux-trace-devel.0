Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr730070.outbound.protection.outlook.com ([40.107.73.70]:29361
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726281AbeLNMwg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 07:52:36 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH v2 0/8] More modifications toward KS 1.0
Date: Fri, 14 Dec 2018 12:52:33 +0000
Message-ID: <20181214125212.9637-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches contains the last (hopefully) modifications
needed before releasing KernelShark 1.0.

This is the version 2 of this series of patches. The major changes
from v1 are in patches 1-3 (new patches). These patches aim to address
the deadlock problem reported by Steven.

Yordan Karadzhov (8):
  kernel-shark-qt: Lock completely the searching panel when searching
  kernel-shark-qt: Fix a simple bug in KsTraceViewer::_searchReset()
  kernel-shark-qt: Make the parallelized search stoppable
  kernel-shark-qt: Avoid spurious searches
  kernel-shark-qt: Create "Apply filter XX" checkboxes in KsUtils
  kernel-shark-qt: Improve the KsQuickContextMenu
  kernel-shark-qt: Update the documentation link
  kernel-shark-qt: Version 1.0.0

 kernel-shark-qt/CMakeLists.txt             |  4 +-
 kernel-shark-qt/src/KsMainWindow.cpp       | 41 ++++++++--------
 kernel-shark-qt/src/KsMainWindow.hpp       |  6 +--
 kernel-shark-qt/src/KsModels.cpp           |  6 ++-
 kernel-shark-qt/src/KsModels.hpp           |  5 +-
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 39 +++++++++++++++
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  6 ++-
 kernel-shark-qt/src/KsTraceViewer.cpp      | 57 ++++++++++++++++------
 kernel-shark-qt/src/KsTraceViewer.hpp      |  2 +
 kernel-shark-qt/src/KsUtils.cpp            | 25 ++++++++++
 kernel-shark-qt/src/KsUtils.hpp            |  2 +
 11 files changed, 146 insertions(+), 47 deletions(-)

--=20
2.17.1

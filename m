Return-Path: <SRS0=dEKL=OV=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr780050.outbound.protection.outlook.com ([40.107.78.50]:47139
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727681AbeLLQ6p (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Dec 2018 11:58:45 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 0/5] More modifications toward KS 1.0
Date: Wed, 12 Dec 2018 16:58:43 +0000
Message-ID: <20181212165826.8218-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches contains the last (hopefully) modifications
needed before releasing KernelShark 1.0.

Yordan Karadzhov (5):
  kernel-shark-qt: Avoid spurious searches
  kernel-shark-qt: Create "Apply filter XX" checkboxes in KsUtils
  kernel-shark-qt: Improuve the KsQuickContextMenu
  kernel-shark-qt: Update the documentation link
  kernel-shark-qt: Version 1.0.0

 kernel-shark-qt/CMakeLists.txt             |  4 +--
 kernel-shark-qt/src/KsMainWindow.cpp       | 41 ++++++++++------------
 kernel-shark-qt/src/KsMainWindow.hpp       |  6 ++--
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 39 ++++++++++++++++++++
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  6 +++-
 kernel-shark-qt/src/KsTraceViewer.cpp      | 20 ++++++++---
 kernel-shark-qt/src/KsUtils.cpp            | 25 +++++++++++++
 kernel-shark-qt/src/KsUtils.hpp            |  2 ++
 8 files changed, 109 insertions(+), 34 deletions(-)

--=20
2.17.1

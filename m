Return-Path: <SRS0=0JuE=OA=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr790053.outbound.protection.outlook.com ([40.107.79.53]:64832
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726849AbeKVBtK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 21 Nov 2018 20:49:10 -0500
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: [PATCH 00/11] Small modifications and bug fixes toward KS 1.0
Date: Wed, 21 Nov 2018 15:14:17 +0000
Message-ID: <20181121151356.16901-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

This series of patches contains various independent modifications and
bug fixes needed before releasing KernelShark 1.0.

Yordan Karadzhov (11):
  kernel-shark-qt: Protect all calls of tep_read_number_field()
  kernel-shark-qt: Fix the returned error value of
    kshark_get_event_id_easy()
  kernel-shark-qt: Avoid race condition in kshark_get_event_name_easy()
  kernel-shark-qt: Optimize the search in the text data
  kernel-shark-qt: Add iterator index to the search panel
  kernel-shark-qt: Update search iterator when marker is changed
  kernel-shark-qt: Optimize the search in a case of a small data-set
  kernel-shark qt: No error when Record authentication dialog is closed
  kernel-shark-qt: Remove all system=3Dftrace events from Record dialog
  kernel-shark-qt: Updata Event filter mask when applaing filters to
    Graph
  kernel-shark-qt: Reprocess all CPU collections when the filtering
    changes

 kernel-shark-qt/src/KsCaptureDialog.cpp    |   1 +
 kernel-shark-qt/src/KsMainWindow.cpp       |   8 ++
 kernel-shark-qt/src/KsModels.cpp           |  28 ++--
 kernel-shark-qt/src/KsModels.hpp           |   4 +-
 kernel-shark-qt/src/KsTraceViewer.cpp      | 152 +++++++++++++++------
 kernel-shark-qt/src/KsTraceViewer.hpp      |   9 +-
 kernel-shark-qt/src/KsUtils.cpp            |   6 +
 kernel-shark-qt/src/KsWidgetsLib.cpp       |  10 ++
 kernel-shark-qt/src/KsWidgetsLib.hpp       |   2 +
 kernel-shark-qt/src/libkshark.c            |  15 +-
 kernel-shark-qt/src/plugins/sched_events.c |  52 ++++---
 11 files changed, 204 insertions(+), 83 deletions(-)

--=20
2.17.1

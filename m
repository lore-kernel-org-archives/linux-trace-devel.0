Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-eopbgr700045.outbound.protection.outlook.com ([40.107.70.45]:11200
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728044AbeJFBdI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Oct 2018 21:33:08 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
CC: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v3 0/5] Final preparation before adding the KernelShark GUI
Date: Fri, 5 Oct 2018 18:33:10 +0000
Message-ID: <20181005183241.27026-1-ykaradzhov@vmware.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Five small patches needed as a final preparation before introducing
the first components of the Qt-based KernelShark GUI.

Yordan Karadzhov (1):
  kernel-shark-qt: Fix a bug in kshark_data_collection_alloc()

Yordan Karadzhov (VMware) (4):
  kernel-shark-qt: Add kshark_get_X_easy() functions.
  kernel-shark-qt: Add kshark_convert_nano() function
  kernel-shark-qt: Add functions for fast clearing of the filters.
  kernel-shark-qt: Rename the Cmake-generated header file.

 kernel-shark-qt/build/cmake_clean.sh       |   2 +-
 kernel-shark-qt/build/deff.h.cmake         |   2 +-
 kernel-shark-qt/src/CMakeLists.txt         |   2 +-
 kernel-shark-qt/src/libkshark-collection.c |  27 ++-
 kernel-shark-qt/src/libkshark.c            | 240 ++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.h            |  20 ++
 6 files changed, 281 insertions(+), 12 deletions(-)

--=20
2.17.1

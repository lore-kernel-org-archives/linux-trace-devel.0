Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-sn1nam02on0058.outbound.protection.outlook.com ([104.47.36.58]:21536
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728184AbeIUTfE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:35:04 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/4] Final preparation before adding the KernelShark GUI
Date: Fri, 21 Sep 2018 16:45:36 +0300
Message-Id: <20180921134540.13074-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>

Four small patches needed as a final preparation before introducing
the first components of the Qt-based KernelShark GUI.

Yordan Karadzhov (VMware) (4):
  kernel-shark-qt: Add kshark_get_X_easy() functions.
  kernel-shark-qt: Add kshark_convert_nano() function
  kernel-shark-qt: Add functions for fast filter clearing.
  kernel-shark-qt: Rename the Cmake-generated header file.

 kernel-shark-qt/build/cmake_clean.sh |   2 +-
 kernel-shark-qt/build/deff.h.cmake   |   2 +-
 kernel-shark-qt/src/CMakeLists.txt   |   2 +-
 kernel-shark-qt/src/libkshark.c      | 191 ++++++++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.h      |  18 +++
 5 files changed, 211 insertions(+), 4 deletions(-)

-- 
2.17.1

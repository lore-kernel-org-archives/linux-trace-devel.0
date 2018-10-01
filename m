Return-Path: <SRS0=7B7L=MN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-by2nam03on0049.outbound.protection.outlook.com ([104.47.42.49]:61055
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729182AbeJAUhz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Oct 2018 16:37:55 -0400
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/5] Final preparation before adding the KernelShark GUI
Date: Mon,  1 Oct 2018 16:59:16 +0300
Message-Id: <20181001135921.32379-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Five small patches needed as a final preparation before introducing
the first components of the Qt-based KernelShark GUI.

This is the second version of this series of patches.
Major changes from v1 are:

[1/5] int kshark_get_event_id_easy(struct kshark_entry *entry)
has been added.

[5/5] This is a new patch. It fixes a bug in kshark_data_collection_alloc()

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
 kernel-shark-qt/src/libkshark-collection.c |  26 ++-
 kernel-shark-qt/src/libkshark.c            | 227 ++++++++++++++++++++-
 kernel-shark-qt/src/libkshark.h            |  20 ++
 6 files changed, 267 insertions(+), 12 deletions(-)

-- 
2.17.1

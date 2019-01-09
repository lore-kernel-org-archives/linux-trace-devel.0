Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39311 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfAINKB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 08:10:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id t27so7603017wra.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Jan 2019 05:10:00 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/6] Modifications toward KS 1.0
Date: Wed,  9 Jan 2019 15:09:39 +0200
Message-Id: <20190109130945.28519-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Small modifications needed before releasing KernelShark 1.0.

This is the second version of this series of patches. It includes two new
patches (5/6 and 6/6). The commented-out code in patches 1/6 and 2/6 is
removed.

Yordan Karadzhov (6):
  kernel-shark-qt: Rearrange the "Filter" top menu
  kernel-shark-qt: Cosmetic modifications in KsQuickContextMenu
  kernel-shark-qt: Make the selection in the Table less touchy
  kernel-shark-qt: Do not auto-scrolling  when the marker switches
  kernel-shark-qt: Add the CPU filters to the filter clearing method
  kernel-shark-qt: Fix bug in plugin actions execution

 kernel-shark-qt/src/KsMainWindow.cpp       | 46 ++++++++++++----
 kernel-shark-qt/src/KsMainWindow.hpp       |  6 +--
 kernel-shark-qt/src/KsQuickContextMenu.cpp | 63 +++++++---------------
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
 kernel-shark-qt/src/KsTraceViewer.cpp      | 27 +++++++++-
 kernel-shark-qt/src/KsTraceViewer.hpp      |  2 +
 kernel-shark-qt/src/KsUtils.cpp            |  2 +
 kernel-shark-qt/src/libkshark.c            |  3 +-
 8 files changed, 93 insertions(+), 60 deletions(-)

-- 
2.17.1

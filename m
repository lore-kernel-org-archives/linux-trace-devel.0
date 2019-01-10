Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40831 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbfAJNoa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jan 2019 08:44:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id p4so11434247wrt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jan 2019 05:44:29 -0800 (PST)
From: Yordan Karadzhov <ykaradzhov@vmware.com>
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] Cosmetic modifications in KsQuickContextMenu
Date: Thu, 10 Jan 2019 15:44:14 +0200
Message-Id: <20190110134419.20247-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

All modifications to the KsQuickContextMenu done in this series of
patches have been sent already, but as a single patch ([PATCH v2 2/6])
The original patch was divided in order to provide a clean sequence of
distinct changes.

Yordan Karadzhov (5):
  kernel-shark-qt: Remove _deselectAction from KsQuickContextMenu
  kernel-shark-qt: Remove the "Apply to" checkboxes from
    KsQuickContextMenu
  kernel-shark-qt: Rearrange the KsQuickContextMenu menu
  kernel-shark-qt: Add "clear all filters" action to KsQuickContextMenu
  kernel-shark-qt: Add section separator in KsQuickContextMenu

 kernel-shark-qt/src/KsQuickContextMenu.cpp | 63 +++++++---------------
 kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
 2 files changed, 23 insertions(+), 44 deletions(-)

-- 
2.17.1

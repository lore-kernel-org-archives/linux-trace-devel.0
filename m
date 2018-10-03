Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34183 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbeJCPSd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 11:18:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id z25-v6so7103685wmf.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Oct 2018 01:31:11 -0700 (PDT)
From: slavomir.kaslev@gmail.com
To: rostedt@goodmis.org
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] [virt-server] trace-cmd: Fix a typo in VIRT_SERVER
Date: Wed,  3 Oct 2018 11:31:02 +0300
Message-Id: <20181003083102.12785-1-slavomir.kaslev@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

From: Slavomir Kaslev <kaslevs@vmware.com>

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 VIRT-SERVER | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/VIRT-SERVER b/VIRT-SERVER
index b4ce550..1970cec 100644
--- a/VIRT-SERVER
+++ b/VIRT-SERVER
@@ -277,7 +277,7 @@ You can also add host tracing as well.
  # trace-cmd -e kvm -e irq -A Guest1 -e irq -A Guest2 -e irq
 
 The above enables kvm and irq events on the host, and irq events on guests
-Gust1 and Gust2. Notice that this is run as root. In order to enable tracing
+Guest1 and Guest2. Notice that this is run as root. In order to enable tracing
 on the host, root privliges are required.
 
 
-- 
2.17.1

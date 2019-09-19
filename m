Return-Path: <SRS0=Eaid=XO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71489C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 07:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DAA0217D6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Sep 2019 07:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XrvHTGmO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731989AbfISHW4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 03:22:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40020 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731332AbfISHW4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 03:22:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so2632830wmj.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Sep 2019 00:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oA7ulI4DLn0QJQoKpbCDminlOg00/fiVvwXOOJRMb5w=;
        b=XrvHTGmOxWuZAkZuQ5isVm3Mr03NIFWsu4YlFq78iV/zwn873rmvTA6afSE4Up60Aj
         x0Zdq7oacjOBf6ypqLdRBlSVrufXidQV9l9rSId0n7GPTV0Ep583pHj/Xu56z4xwgW3i
         tsI02TrJ0NIUpqdBDHRIWzS3efTStGIHUKVR+F4ldY66xuO/O0L5fByWrjpFelJv8Dgi
         qtSQLnSVJlO0DLKnXvoISOH2hAiN52SBBfVJg3tmvvw6ClENF5045T0WuQ79sNKaztbG
         hwHXcPYJvsSjsYC+aFaCo5Q5A7pWVnpftn3oZeAvTzFuqFP3t7McZg16euBFfJk2O5aX
         D1+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oA7ulI4DLn0QJQoKpbCDminlOg00/fiVvwXOOJRMb5w=;
        b=NtzdvYZBn5Fhog9Pmm7QjRw7A6TsevmIH8S3z98UV6KAMeS8Sbvg1mfWv85I75fhOT
         TNb0JoCi079iSBG1vKPhZKlpLfcbKYdayiiF9ehRL+9L8f8ON3e7XZqBJZc17wLs3ty6
         94kS/uLJe/NypIciF1EzcRslKBSr6bJfpIblAQuzcZQhh8CoyOqkDeUXDkZtLfRbrTDO
         5sqXG9jzcmBZ1esd2egEkwiUAdkDgyFVj2LsQklVU3J8ISM+LqNzmhGmAxICW8u+Jaq6
         fwp8YkKWRArQKMd+funirsjWRHflct/+n8ZGfrYxXsoJ4kSW9Ok6p9l/EQfZ2WV/iXzn
         Z62w==
X-Gm-Message-State: APjAAAWdMOtlh0S8wNJO0UFat94SczqUNsQTT2sglx+vbGa5qv7sMWNT
        xfssbFGhS1hdf2mp7yLekQ8ACtFd
X-Google-Smtp-Source: APXvYqwJfrZQ2wGcF3p5TYHkdzwdVUaiuoneaY24bC/QJ05VrHtGGD7vHt+sb/Twre3f7we3H5cIJw==
X-Received: by 2002:a1c:9ec9:: with SMTP id h192mr1540450wme.105.1568877774521;
        Thu, 19 Sep 2019 00:22:54 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u25sm3579074wml.4.2019.09.19.00.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 00:22:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Always show the true PID of the entry in the Context menu
Date:   Thu, 19 Sep 2019 10:22:30 +0300
Message-Id: <20190919072230.24945-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All data fields of the kshark_entry object can be modified by plugins
(including the  Process Id). This is usually done in order to modify
the way some events are visualized. However, the Context menu should
always show the true (unmodified) value of the PID.

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Fixing: 4828dc763 (kernel-shark-qt: Add centralized context menu for View and Graph widgets)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsQuickContextMenu.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsQuickContextMenu.cpp b/kernel-shark/src/KsQuickContextMenu.cpp
index 728ecbd..a84444e 100644
--- a/kernel-shark/src/KsQuickContextMenu.cpp
+++ b/kernel-shark/src/KsQuickContextMenu.cpp
@@ -142,7 +142,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 			descr = "Remove [";
 			descr += taskName;
 			descr += "-";
-			descr += QString("%1").arg(_data->rows()[_row]->pid);
+			descr += QString("%1").arg(pid);
 			descr += "] plot";
 			lamAddAction(&_removeTaskPlotAction,
 				     &KsQuickContextMenu::_removeTaskPlot);
@@ -150,7 +150,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
 			descr = "Add [";
 			descr += taskName;
 			descr += "-";
-			descr += QString("%1").arg(_data->rows()[_row]->pid);
+			descr += QString("%1").arg(pid);
 			descr += "] plot";
 			lamAddAction(&_addTaskPlotAction,
 				     &KsQuickContextMenu::_addTaskPlot);
-- 
2.20.1


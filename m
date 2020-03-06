Return-Path: <SRS0=llO+=4X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB88C10DCE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 09:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 844942084E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  6 Mar 2020 09:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtwFUReN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCFJ3K (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 04:29:10 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45689 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgCFJ3K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 04:29:10 -0500
Received: by mail-lj1-f194.google.com with SMTP id e18so1440715ljn.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 06 Mar 2020 01:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DMhtUGr7tke+xOCWcyyh0GI7SgcnKywwl8pMXlkNUlE=;
        b=WtwFUReNJMx3VTOR7kTp6VW948ie5c+DShTkT1mRyfLCetET+42sF6kK18uGKiNRbj
         1ZCeNt8pvYdEANE7ppz5o5tQyJqeQmc+X4uXVdoTGe17Hn41lMnBZxA7i4/RFvEI+Kv9
         PwzrqD8Ctko/KpmcPsGT0VJnqdqBHnwMRij7DhmPaCLZzKybSMcXYWybVTxtaK8d2w6B
         Xe9sGAlmLjY4HCTdGWloOmHIiEvSq34sHIYviGwGJ11NnCojIEed/j2YLFLh5h8vC2pJ
         oas+MOIfbTiA+mFfMMLTVlNHNd4YiWIl6meha471/ZvjJjMLbshLJn/q4lvhWw1RViv8
         D6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DMhtUGr7tke+xOCWcyyh0GI7SgcnKywwl8pMXlkNUlE=;
        b=TMJeDyUSdWKtdRqF/+RxU6IXpY2pdxaw9i33kldCV8JzXkAuGNboZO/Z/ac2oyCDLU
         PlVXE68TmqYJDU65a6ZYXzh3sG4Ecx8eGzf0UcKlC2MmyiGbH9SdWijmN6y24E5rSEK9
         6DLTSpOzAp8EjnhzVSTjOtl4pNG4cWuXSk9dUlmv4y1UZk2ykM5wkGrTUBMLX7eB/WP2
         CPGdeWvSENLDNPnLW5Er9vE4Lfq73zS/i5baKz/2e6QJmlWocuRfF1oRyTbAM9o2iLKe
         YduJOuYh7a1ctalpihtVTUgWALSvv3mvZjYAP6ESksJjvHV0SazPXax1zJSlPC8UXhY/
         hpVw==
X-Gm-Message-State: ANhLgQ2mD59ZPIaXNFk5wTp1k5Ffk75RWN3p7nMd0C2Fe40Vpgs5LWJ+
        jgsPiqfAyS/qiq3AlK6Sh6dqmJea
X-Google-Smtp-Source: ADFU+vv4hL48XwJBdCVPl9A6WA8/2WBiBjI/slTjKYEzMDDm+7mB0nv2eu4EE5XWlVJjRo+oBVqw1g==
X-Received: by 2002:a2e:978d:: with SMTP id y13mr1353549lji.287.1583486948194;
        Fri, 06 Mar 2020 01:29:08 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm16750159ljh.11.2020.03.06.01.29.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 01:29:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] KernelShark2.0: Use libtracefs APIs to access tracefs
Date:   Fri,  6 Mar 2020 11:29:02 +0200
Message-Id: <20200306092902.48786-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306092902.48786-1-tz.stoyanov@gmail.com>
References: <20200306092902.48786-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

KernelShark uses trace-cmd APIs to access tracefs. Now those
APIs are moved to libtracefs:
 tracecmd_get_tracing_dir() -> tracefs_get_tracing_dir()
 tracecmd_local_events() -> tracefs_local_events()
 tracecmd_local_plugins() -> tracefs_tracers()

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/libkshark-tepdata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index ed61f76..8678e12 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -19,6 +19,7 @@
 
 // trace-cmd
 #include "trace-cmd/trace-cmd.h"
+#include "tracefs/tracefs.h"
 
 // KernelShark
 #include "libkshark-plugin.h"
@@ -1066,7 +1067,7 @@ int kshark_tep_init_local(struct kshark_data_stream *stream)
 	if (!tep_handle)
 		return -EFAULT;
 
-	tep_handle->tep = tracecmd_local_events(tracecmd_get_tracing_dir());
+	tep_handle->tep = tracefs_local_events(tracefs_get_tracing_dir());
 	if (!tep_handle->tep)
 		goto fail;
 
@@ -1233,5 +1234,5 @@ int kshark_tep_get_event_fields(struct kshark_data_stream *stream,
 /** Get an array of available tracer plugins. */
 char **kshark_tracecmd_local_plugins()
 {
-	return tracecmd_local_plugins(tracecmd_get_tracing_dir());
+	return tracefs_tracers(tracefs_get_tracing_dir());
 }
-- 
2.24.1


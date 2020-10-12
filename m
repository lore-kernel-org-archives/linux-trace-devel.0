Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C91EC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B7A42087E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 14:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="peN2l/0Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388261AbgJLNgK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388143AbgJLNgJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:36:09 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD3EC0613D0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f21so17185622wml.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9LG53zTXZaEA60v6ax0/6GIy63pdMNWl+hS8o3zo4k=;
        b=peN2l/0QLUM8jdD2M4D35kZbK4D4JjqQ6eHhfty7kQZ4fMvQ/OGIFd0Xlc4YcNRNYj
         jAtD4S1POzZbx1+zpt8Y/iElWaWtEHo2gYckRcuDJ+NsiTQZcY3oBH70oeH4bCkisr9A
         B7yFoROezH86jwit9IptJgFApMK+Ct8Sk8bz6umIRxNwTjLIcaguDsG3aRr3u9nZOiWr
         b1XU0qeNEIXUSj4+/luXKeFNA59bgUJ2eOWek2JC3LK3OMqwtbsCBr0WMXuOlBU6d8A/
         iEvv7MCd+tC91KoUCnO63c7rNmdv3H77iyiG4Dtuu8oBJ8Ozi+hdngNsukshg5CdF7fS
         holQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9LG53zTXZaEA60v6ax0/6GIy63pdMNWl+hS8o3zo4k=;
        b=EhDdhFl8BkA5jIkiNTiMD7TVH6vOVOQZaFETq74eG3YhPQXSjwNDY6ZGRSdN/lUQHS
         1MOlTDiBKblnW1qH2ZYoCRKxj37B4NoLJMBalSmAPYYM8lJB73IcXQiYWhoKYTz6nTuQ
         LgfWoRkMub/w8l9189DQ4tysBxHg5i/GYopPq/5E4C5wEza5NeTET3Z8+OiIB6y16RvQ
         JMQCWZsKJQQo7EyNVUthixP3q6XtqznM8cIDYTbLigXoruMJEiZ94qduFLUoji60+i5b
         9P6pNNeIGYw5zChW1HwzJTNU+GQF9SVGHRRWksCsZ7QpPidCmaA5ZYuHfJITwFpNQ6O0
         FgqQ==
X-Gm-Message-State: AOAM5324bbiSqel/NbAadvvSjh4M3WfYEqaqJ7ogj/2Y/vCTrmBZcW/F
        BT9/jmGwknhvnyIibl9faXU=
X-Google-Smtp-Source: ABdhPJwUtXgwtgMyuLjK31crhzBE4CQLkt6+Er8hg6mmZSHihaY+1GossHf4zv5mKG5+bJL+2k6rug==
X-Received: by 2002:a1c:2cc4:: with SMTP id s187mr10650598wms.36.1602509768096;
        Mon, 12 Oct 2020 06:36:08 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:07 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 05/20] kernel-shark: Add stream_id to kshark_entry
Date:   Mon, 12 Oct 2020 16:35:08 +0300
Message-Id: <20201012133523.469040-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

kshark_entry contains all information from one trace record, needed
in order to visualize the time-series of trace records. Here we
reorganize data fields to kshark_entry in order to make room for
the unique identifier of the Data stream this entry belongs to.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c |  2 +-
 src/libkshark.h | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index 52aacd30..92e2450c 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -489,7 +489,7 @@ static inline void unset_event_filter_flag(struct kshark_context *kshark_ctx,
 	e->visible &= ~event_mask;
 }
 
-static void set_all_visible(uint16_t *v) {
+static void set_all_visible(uint8_t *v) {
 	/*  Keep the original value of the PLUGIN_UNTOUCHED bit flag. */
 	*v |= 0xFF & ~KS_PLUGIN_UNTOUCHED_MASK;
 }
diff --git a/src/libkshark.h b/src/libkshark.h
index 1165c512..fe0ba7f2 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: LGPL-2.1 */
 
 /*
- * Copyright (C) 2017 VMware Inc, Yordan Karadzhov <y.karadz@gmail.com>
+ * Copyright (C) 2017 VMware Inc, Yordan Karadzhov (VMware) <y.karadz@gmail.com>
  */
 
  /**
@@ -49,7 +49,10 @@ struct kshark_entry {
 	 * kshark_filter_masks to check the level of visibility/invisibility
 	 * of the entry.
 	 */
-	uint16_t	visible;
+	uint8_t		visible;
+
+	/** Data stream identifier. */
+	int8_t		stream_id;
 
 	/** The CPU core of the record. */
 	int16_t		cpu;
@@ -57,7 +60,7 @@ struct kshark_entry {
 	/** The PID of the task the record was generated. */
 	int32_t		pid;
 
-	/** Unique Id ot the trace event type. */
+	/** Unique Id of the trace event type. */
 	int32_t		event_id;
 
 	/** The offset into the trace file, used to find the record. */
@@ -319,6 +322,9 @@ struct kshark_data_stream {
 	struct kshark_data_stream_interface	interface;
 };
 
+/** Hard-coded maximum number of data stream. */
+#define KS_MAX_NUM_STREAMS	127
+
 /** Size of the task's hash table. */
 #define KS_TASK_HASH_SHIFT 16
 #define KS_TASK_HASH_SIZE (1 << KS_TASK_HASH_SHIFT)
-- 
2.25.1


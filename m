Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE21BC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7DCA60D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236657AbhG1NdD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236610AbhG1Nc7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:32:59 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D9FC06179B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id oz16so4624597ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b2KhL1Upy3VmA3yPrpUpN3SU5lWmmfnTJs4wcWJbi/4=;
        b=awoARoyt7hvx+GpVUUdkNY8oI14Zgx3i+3f2bnkAmcSUqlizi8U3f+7xmlueLfXZ6h
         Qz1K3u+mGs3T3cHwXJiOk7rNMbKBiK4qVuhYWYg/F+vCyULasNlqElzHB3SHKQDkjJ73
         lZmXpPjq2cVYbkrbxfyV159EJmQsa/AdL2czW4axRhGtKZNut5/v/q1zuWa5YEALSx35
         6ha6nx4C4ItogZMFT0uviquP0Vy5hpl3zquCyKAw484+B9aC8k+A+M91oDMFcaEgXk1N
         Xnl0ECioMMT8RNA+XGPvyefCwWn5FkQpeU0azvirkcWR9r0YFGQwNFxrWWMbbE3Tj0HX
         AFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b2KhL1Upy3VmA3yPrpUpN3SU5lWmmfnTJs4wcWJbi/4=;
        b=YytnKOz27hopgLWxekvAb9l62YG3b9r6Y6D24XYMQMM2y5onWfmJ4HotawCoRXfNQ8
         9vLyGFCWRB2gLer4xgAAKhTy5cuHvuV35llvvpv7tnxObS/qwy+gffHyZ9e6IJ2fb89/
         pbeMeDgCwFkNsLx7yjyAvXbWNFwp/FBOyjqi/PPfaoQ+AqtXrZmHxP1Nnwn0XwyTbvzX
         Yo5kZQczoTBZ20V8fc+Fa2y4KYKiB9WHRjkjrWD2aksWCegV8BlNaQ1MIQLgESJsRSXF
         P+7e1JsRX7mnndeZS4ulOl3xMzbYiw+5ja4YRimlAFcu7m9oiEv0NLpGx3q8bQ3RojA7
         5YGw==
X-Gm-Message-State: AOAM532936TAYq605Tis6Btgih+YlOhcXvsgVQRjMevWB3yMTJU3ssy7
        K7MeB4WGMtFIjqQcAWnl3ns=
X-Google-Smtp-Source: ABdhPJy2ktsEaBLbt67ULfImLcIl0O6yxvPoLWBJ3wEAMeP8lkJFcYq0BtD5nvDbJCMa14eIJy2i9w==
X-Received: by 2002:a17:906:4d94:: with SMTP id s20mr15915579eju.152.1627479176025;
        Wed, 28 Jul 2021 06:32:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 04/87] trace-cmd library: Fixed a memory leak on input handler close
Date:   Wed, 28 Jul 2021 16:31:27 +0300
Message-Id: <20210728133250.234140-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When an input hanlder to a trace file is closed with tracecmd_close(),
the list with buffers is not freed. This leads to a memory leak. Added
logic to free that list.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index d5ffafd7..f94a0073 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3482,7 +3482,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
-	int cpu;
+	int i;
 
 	if (!handle)
 		return;
@@ -3495,21 +3495,21 @@ void tracecmd_close(struct tracecmd_input *handle)
 	if (--handle->ref)
 		return;
 
-	for (cpu = 0; cpu < handle->cpus; cpu++) {
+	for (i = 0; i < handle->cpus; i++) {
 		/* The tracecmd_peek_data may have cached a record */
-		free_next(handle, cpu);
-		free_page(handle, cpu);
-		if (handle->cpu_data && handle->cpu_data[cpu].kbuf) {
-			kbuffer_free(handle->cpu_data[cpu].kbuf);
-			if (handle->cpu_data[cpu].page_map)
-				free_page_map(handle->cpu_data[cpu].page_map);
-
-			if (handle->cpu_data[cpu].page_cnt)
+		free_next(handle, i);
+		free_page(handle, i);
+		if (handle->cpu_data && handle->cpu_data[i].kbuf) {
+			kbuffer_free(handle->cpu_data[i].kbuf);
+			if (handle->cpu_data[i].page_map)
+				free_page_map(handle->cpu_data[i].page_map);
+
+			if (handle->cpu_data[i].page_cnt)
 				tracecmd_warning("%d pages still allocated on cpu %d%s",
-						 handle->cpu_data[cpu].page_cnt, cpu,
-						 show_records(handle->cpu_data[cpu].pages,
-							      handle->cpu_data[cpu].nr_pages));
-			free(handle->cpu_data[cpu].pages);
+						 handle->cpu_data[i].page_cnt, i,
+						 show_records(handle->cpu_data[i].pages,
+							      handle->cpu_data[i].nr_pages));
+			free(handle->cpu_data[i].pages);
 		}
 	}
 
@@ -3520,6 +3520,11 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->version);
 	close(handle->fd);
 
+	for (i = 0; i < handle->nr_buffers; i++)
+		free(handle->buffers[i].name);
+
+	free(handle->buffers);
+
 	tracecmd_free_hooks(handle->hooks);
 	handle->hooks = NULL;
 
-- 
2.31.1


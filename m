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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658FBC4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404F661054
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbhG2FKK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbhG2FKJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:09 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F040CC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:06 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id nd39so8462272ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=otAzU6cU3J4e1+T0g9Y8ReUchZ4/dph0iJyK91g2foI=;
        b=ZBsUz07gVp6Q8gXB48FWQquoV8Jd+0RBekwtPc/kLKy0uppKYj1v5BepfCfo0Ba1Gy
         gaMLZZxboa88cw2/ezCeythLCkzLJbq/GTgJ+Ic8Ck5RnQDSIij3eRhsR/uPLtRwOoBY
         CvIerDApJjlzQKrkK1NfQpfoo/oyJ9K79QDxKcEl+oNGT91TrXiyJWy2CyyZK37/c66y
         rClLSH5OS0lPM+Qan/pbwFoTn/jVcIUtWcUgEwduZYh5CkzKerBG41kGYlldzQ2zNLhw
         Z790vRzBEjjC7YoFVPcDKpuO2wmH/5XzMBg3rtmgL22W/EHd+8+GABepfNy5xicJGEpu
         Ckng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=otAzU6cU3J4e1+T0g9Y8ReUchZ4/dph0iJyK91g2foI=;
        b=P2A/nkkdKQgrSujWomMvXmHnacf/60efAB9EOXbm1S+v0pJsIoGOcRRMaO4BYyOlZS
         qaHNnRCue6lkWPmfG+CP58L8F6utgmWjjWkg2MrKbde4C+cXAVQhiLWqcanBO+2VgJ6W
         HQIAmPosf+xk2DAV/YXwhgFz7FmsxO7m39QAAbHdMFEifACmUOh6H1SFMMfvpCx6bDVV
         DYorjgYvc5d6kO07YBq1zP4gBc+vb821NgCmhYuU0BEL6tFBhaGDz4n3IAKxgkjY1kvr
         bbCwG5l7z3mxLxI9DCM77RA0LdqybbOAuxi0jvHfb+rBIPDylDfS6XMLyAYUN+mCESsj
         ipAA==
X-Gm-Message-State: AOAM530THmJ57rMW5IXoN48Bm5diDgFg/9PZYGUwrs6N+etov7dMocFF
        x1IkIwmKHzYJk9QihN/WEtMRc+P62Ocskg==
X-Google-Smtp-Source: ABdhPJw0hAF06eeGbD9Cjq9aOxq1ujjNLMDU/OoX1RTQl0cNaNyScbB+nSbZRbiF3DLRuO4Vy9GuUg==
X-Received: by 2002:a17:906:2bd3:: with SMTP id n19mr2960424ejg.232.1627535405630;
        Wed, 28 Jul 2021 22:10:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/87] trace-cmd library: Fixed a memory leak on input handler close
Date:   Thu, 29 Jul 2021 08:08:36 +0300
Message-Id: <20210729050959.12263-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 9253bc37..af11cbc6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3483,7 +3483,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
  */
 void tracecmd_close(struct tracecmd_input *handle)
 {
-	int cpu;
+	int i;
 
 	if (!handle)
 		return;
@@ -3496,21 +3496,21 @@ void tracecmd_close(struct tracecmd_input *handle)
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
 
@@ -3521,6 +3521,11 @@ void tracecmd_close(struct tracecmd_input *handle)
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


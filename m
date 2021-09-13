Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA0FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 759E360F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbhIMM3f (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240002AbhIMM3d (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:33 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE42C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:17 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id x6so14386362wrv.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MyWIX5tRJya1zLsqCa6QH1jp9vXldsg4aBN46KmC+xg=;
        b=FHCAGCINTJlDQiO8/L2uHdnWhtmVQKJv58e7X3AQtyGOc36xgz9s3Yv5fvGHq262mj
         Zv1H28Rw0E4kZdhlx7EmBXV1puPQVSj53iMtI34VbcHTO9PUoF0p4QRPzcvVsHP45O1U
         x1l+fqNgUV16azWgPaj+kPC4HJ0aHL1KFjB33lfegNaemTABglSrAmu2FKixqK4uTwqV
         P7jm84RvD2KDKB7NPdXHoIL7LA6K0l6WBtGr6Fvv9KbR+YsPL3UK2k+FZZZEBdpmSvY8
         Jui//iJCg7USqVidIjoKzoSsmN8ei9/TQcTd4ywUaqQRRe57EeQmVmfnaa8eVoaYZxAI
         kQXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MyWIX5tRJya1zLsqCa6QH1jp9vXldsg4aBN46KmC+xg=;
        b=Bn3CiRPTrgpsg98VkZgBfMS+85v2AYk6PJ4MSc7j4fYbjKr05bycwanZcUQKRFGs6Y
         Y2AQsRp1gzWNDAGSamxsghd+wmf8IK2oXArrH9LVZwEFbNwHnYTJeRwxkHUt/6e3aEPe
         2kdqCs+cia91r0Cq/o/bjsB6fPnm+h3U4PGYQtTI6nJLDsLTK3v0j4DCyt7PtCJXJssn
         PXPawE8mNMmGilmD+zwxyvVYQ3zduup+kXBN72QgWOQELn+DLsafVWnte6uR1vp1t0i0
         s9JcXQoCBk6BSsdZgl2s1yNfWBogbKLosPOSeHRO4QPuN3tDueRzBodYXvc9L42pHh/o
         VrJQ==
X-Gm-Message-State: AOAM530yz/miG2887cG+CIKRA85XuJHHFQhIW+IbcBijoZdbGLs9pybz
        greBKnG+1Wc9vO4v8uRilpW+08tnn2k=
X-Google-Smtp-Source: ABdhPJzaVtJn1IriRIjjFkFuyAa79TYCIzrmqap5Mco7DRGKSX5nWyWgXKcqI9VQA4Zp15LQKjYVbw==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr12396282wro.418.1631536096166;
        Mon, 13 Sep 2021 05:28:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 15/21] trace-cmd library: Track maximum CPUs count in input handler
Date:   Mon, 13 Sep 2021 15:27:53 +0300
Message-Id: <20210913122759.3672494-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This clean up is needed for the design of the next trace file version,
where only CPUs with trace data could be stored in the file. Each trace
instance may have its own CPU count, depending on collected traces.
As the main input handler is used by the top trace instance, the
CPU count there is for the top trace instance and may differ with cpu
counts of the other instances. Added a new "max_cpu" member of the input
handler, that tracks the maximum CPU count of all instances, recorded in
the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index cb8b9f14..dc82d3ea 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -125,6 +125,7 @@ struct tracecmd_input {
 	int			long_size;
 	int			page_size;
 	int			page_map_size;
+	int			max_cpu;
 	int			cpus;
 	int			ref;
 	int			nr_buffers;	/* buffer instances */
@@ -838,6 +839,7 @@ static int read_cpus(struct tracecmd_input *handle)
 		return -1;
 
 	handle->cpus = cpus;
+	handle->max_cpu = cpus;
 	tep_set_cpus(handle->pevent, handle->cpus);
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 
@@ -2794,6 +2796,8 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_CPUCOUNT:
 			cpus = *(int *)buf;
 			handle->cpus = tep_read_number(handle->pevent, &cpus, 4);
+			handle->max_cpu = handle->cpus;
+			tep_set_cpus(handle->pevent, handle->cpus);
 			break;
 		case TRACECMD_OPTION_PROCMAPS:
 			if (buf[size-1] == '\0')
@@ -4074,7 +4078,7 @@ int tracecmd_page_size(struct tracecmd_input *handle)
  */
 int tracecmd_cpus(struct tracecmd_input *handle)
 {
-	return handle->cpus;
+	return handle->max_cpu;
 }
 
 /**
-- 
2.31.1


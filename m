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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52840C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:12:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F40A764FD7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Mar 2021 12:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhCJMLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 07:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhCJMLi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 07:11:38 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C43C061760
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Mar 2021 04:11:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x9so27640527edd.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 10 Mar 2021 04:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OfQdui0iiIy7h2f9jkisiMGAvpM75WS5lXKla6De/G4=;
        b=CpwoqGerAUPiiyQ5S5eZ6Gr2kgSW6YfO/LN8WVF7gesoU4tJre/zIm6D/I/jC8mKS1
         e+52nj54b/OgTAF7ObfyGz8Vz0zlNams2eBc87g5yCPZVHR1bvcFANBaRsWNE95tQats
         TlPYwgPkaBlpfcsvWAbbJYTFeW3uXJL/kNsg5f6ge377HSAg8ui1Z/5W73joQvY6peyy
         oqUKM28/J28uynwnQL/oBm12kdIMGTLPdeX6WhYl1+WJ4akCjGEZ9srTYvx5bySXKc51
         SiSRXFzerJ60c/nVa7Bv+KGal2TWJYQfKkwv1l20QXAjvtMvH1iyg46LpS4hESwKpiQ/
         BNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OfQdui0iiIy7h2f9jkisiMGAvpM75WS5lXKla6De/G4=;
        b=qp/wIxSPH6PLKVluqvczTCLBN01TFJ550aJI2bk4zcl4FYZPngemrqf8s/LSjQ5zhe
         UneHKhG9BGYcz50SgLVyZzkQ9jkMdTrcfLoJ+J/+qWoa9e2BO2Q0S2FKcj9ByTA4wlSW
         FFBBRTuX/B3etNVe8Z8muvRi0S2tejPfp/UPOO0yz/R8grzKunMd15tU8PzFxPqQLlBa
         vlxQ9tVkyE8yg9i0vfA/5zPh2vUDT2BjHT/26xl+dGxV8gDcU8ZYrt3kCNXMzTYnZj9R
         PINbPG7PGnfXmuyV8Fc2HqQgqo96xhnEn2WPiNxbWJ8CI2ZGWRt6BVoZs3jEy2Vv7uVi
         je7Q==
X-Gm-Message-State: AOAM531NcfCJmau3tJN7KHdeoJ+NWb8Lh8OLYh1RKd3Cw9buA9CkmAU2
        p1Narwa2wrRP3wmwZYjpzZM=
X-Google-Smtp-Source: ABdhPJxc/vJvQjBD4B5Wl5XEJs2isrJsfuBmKiarB7wSQooKXNimswo5r2wuieZXzFG6pFmk+ST94w==
X-Received: by 2002:a05:6402:1649:: with SMTP id s9mr2860128edx.177.1615378296762;
        Wed, 10 Mar 2021 04:11:36 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n16sm9346803edr.42.2021.03.10.04.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 04:11:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark v2: Change the logic for opening trace-cmd files
Date:   Wed, 10 Mar 2021 14:11:35 +0200
Message-Id: <20210310121135.1620453-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

The logic for opening a trace file by trace-cmd library has changed.
Any timestamp corrections, found in the trace file metadata are applied
automatically. The old APIs, used by KernelShark for pairing trace files
from the same host-guest traceing session and adjusting timestamps are
now obsolete and should not be used.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/libkshark-tepdata.c | 49 -----------------------------------------
 1 file changed, 49 deletions(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index d29e98b..4e76ef2 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1206,49 +1206,6 @@ static void kshark_tep_init_methods(struct kshark_generic_stream_interface *inte
 	interface->load_matrix = tepdata_load_matrix;
 }
 
-/** Find a host stream from the same tracing session, that has guest information */
-static struct tracecmd_input *
-kshark_tep_find_merge_peer(struct kshark_context *kshark_ctx,
-			   struct tracecmd_input *handle)
-{
-	struct tracecmd_input *peer_handle = NULL;
-	struct kshark_data_stream *peer_stream;
-	unsigned long long trace_id;
-	int *stream_ids = NULL;
-	int ret;
-	int i;
-
-	trace_id = tracecmd_get_traceid(handle);
-	if (!trace_id)
-		goto out;
-
-	stream_ids = kshark_all_streams(kshark_ctx);
-	if (!stream_ids)
-		goto out;
-
-	for (i = 0; i < kshark_ctx->n_streams - 1; i++) {
-		peer_stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
-		if (!peer_stream || !kshark_is_tep(peer_stream))
-			continue;
-
-		peer_handle = kshark_get_tep_input(peer_stream);
-		if (!peer_handle)
-			continue;
-
-		ret = tracecmd_get_guest_cpumap(peer_handle, trace_id,
-						NULL, NULL, NULL);
-		if (!ret)
-			break;
-	}
-
-	if (i == kshark_ctx->n_streams)
-		peer_handle = NULL;
-
-out:
-	free(stream_ids);
-	return peer_handle;
-}
-
 /** A list of built in default plugins for FTRACE (trace-cmd) data. */
 const char *tep_plugin_names[] = {
 	"sched_events",
@@ -1574,7 +1531,6 @@ bool kshark_tep_check_data(const char *file_name)
 int kshark_tep_init_input(struct kshark_data_stream *stream)
 {
 	struct kshark_context *kshark_ctx = NULL;
-	struct tracecmd_input *merge_peer;
 	struct tracecmd_input *input;
 
 	if (!kshark_instance(&kshark_ctx) || !init_thread_seq())
@@ -1591,11 +1547,6 @@ int kshark_tep_init_input(struct kshark_data_stream *stream)
 	if (!input)
 		return -EEXIST;
 
-	/* Find a merge peer from the same tracing session. */
-	merge_peer = kshark_tep_find_merge_peer(kshark_ctx, input);
-	if (merge_peer)
-		tracecmd_pair_peer(input, merge_peer);
-
 	/* Read the tracing data from the file. */
 	if (tracecmd_init_data(input) < 0)
 		goto fail;
-- 
2.29.2


Return-Path: <SRS0=rOCb=DQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68D0FC433DF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15746222C3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kIFr1x9m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388434AbgJIOD4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgJIOD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:56 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8DBC0613D2
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:54 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id p13so9467023edi.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LuWI5OYUpaxcK/xa13D9xGH5yJE6XU+Hn8eS+RLDayg=;
        b=kIFr1x9mrDBDKAIXDMDcf38PrioMpSUEsC8u1alesAeggPCUTFDAP1CE5FtRfSiPpR
         NDyofUrSxMs8AQJOoRzVjVi1ZhkPTWscuRr/DcR2OokA+tPnH4D7AnsEKhkZOzPpqJIS
         ntu4cJtcMU25BcMqxsUmMxotyNyUxRgDHrffoGw++E5eYL3gXcF153wjqNjIhTIQfTvC
         o1DOQ6wob0V0LHX6pgsx06++Xv8CmKrqpqsBx9E468QLrb6DCwWJILhjJ+5mbbqH8A5P
         EtTbKLekD10+QlZIgTBPFqW+VxV4rcGbjn11XnvcTxYu4+g1bbOpPuEap1mEMWYSd87y
         petw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LuWI5OYUpaxcK/xa13D9xGH5yJE6XU+Hn8eS+RLDayg=;
        b=l7RLrDM0H3r35xV2GBKhb80rglFzdEP6xIVx9lQSoqKnXc+QGHbDTwMhMJ1BbF2COx
         UyV/gM+UFwV81O0qu7hIZtEIqmksYQzWE82qccx//lI3hQwWyotUye78R6Y5srATGTjR
         ojjED6B4Rd4HXEM6Vm61b45o396T/vwdHv46BzCmBHO8usJepD4Vs5EuaSsgrEksb1x0
         JfUssDChhL2+STm+eO2XzHVHYaYWkW+BMPvXD6WfecQreUoe49uO5YSkxiSQ8Px8u6HF
         em4fuynKcXiJkBkk4VhQp0czTnqUI0dgbb6fAw9h+OhBmsPQeqFHwoTpsPZc08veVD//
         3V8g==
X-Gm-Message-State: AOAM531jSAEj1IvzRrYMgNJaAtxWbwlYpYIUBQuoYxU3+wxkKRutJvXJ
        idwiiLoTAm+trdB06mbYdlw=
X-Google-Smtp-Source: ABdhPJyGgQUxuv+So+9ZLLwgbQisQJg4fM872LDq88QBxZMdKChhj+weovNMfcdQE2oLumkmH0WBDg==
X-Received: by 2002:a05:6402:14cd:: with SMTP id f13mr14326492edx.75.1602252233428;
        Fri, 09 Oct 2020 07:03:53 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 07/10] trace-cmd: Add host / guest role in timestamp synchronization context
Date:   Fri,  9 Oct 2020 17:03:35 +0300
Message-Id: <20201009140338.25260-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new parameter in timestamp synchronization context, holding the
current role in the timestamp synchronization process - host or guest.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-tsync-local.h | 1 +
 lib/trace-cmd/trace-timesync.c            | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index b79b102c..1af52a12 100644
--- a/lib/trace-cmd/include/trace-tsync-local.h
+++ b/lib/trace-cmd/include/trace-tsync-local.h
@@ -11,6 +11,7 @@
 struct clock_sync_context {
 	void				*proto_data;	/* time sync protocol specific data */
 	bool				is_server;	/* server side time sync role */
+	bool				is_guest;	/* guest or host time sync role */
 	struct tracefs_instance		*instance;	/* ftrace buffer, used for time sync events */
 
 	/* Arrays with calculated time offsets at given time */
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 807fb6f5..10ab82f0 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -293,7 +293,7 @@ clock_synch_delete_instance(struct tracefs_instance *inst)
 	tracefs_instance_free(inst);
 }
 
-static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
+static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
 {
 	struct clock_sync_context *clock = NULL;
 	struct tsync_proto *protocol;
@@ -308,8 +308,11 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
 	clock = calloc(1, sizeof(struct clock_sync_context));
 	if (!clock)
 		return -1;
-
-	clock->is_server = server;
+	clock->is_guest = guest;
+	if (clock->is_guest)
+		clock->is_server = true;
+	else
+		clock->is_server = false;
 	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
 			       &clock->local_port, &clock->remote_cid,
 			       &clock->remote_port))
-- 
2.26.2


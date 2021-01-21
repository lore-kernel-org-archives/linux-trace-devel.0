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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DF2C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 317C8221F7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbhAUHq7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbhAUHqu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:46:50 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A00C061793
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:07 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id a1so734310wrq.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nswyThKLN9CSj5N5XKRVl6p5SammQACUOtZ/xPnYjYI=;
        b=jxvwmtIJvmtYk0uMW0nCrNrw5B63jY1iww41pDuS1v9JruBSgDwbxNgKAMr7+IFJpY
         q6tcdZIgAuN5HzcVqVoLfA4F7VEQAjcwfd567/a0ykiZ4kjzqG/Q0ASrQG1J6TAAv7b8
         CL33gVeEWcRv1OwhQStu2DyOu7j+eR1voRV4uSkqj0GlALzGGZw09FtW018YC1Vvatbh
         9gLM9/xUCrIu98V3NGfI0421fOLG5gDRvhvh709bNUaX1RFVPcV9m9MCaAEZgz3dl9xY
         6u0NKDR89v+iyPC2tHHxokPO+4oxQwnjNPAYxTe9gDNUIAPnn19bK5p72bxgSjqeaNyO
         dRDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nswyThKLN9CSj5N5XKRVl6p5SammQACUOtZ/xPnYjYI=;
        b=MEB0LfENeg5Dci6jHs0HFAAGx1BJezUcvdR9417JiBdeCyqLJQNkOmULhrGjGwc+qP
         OEqwww6Cw4FwL2MfHJPIPkwN6zlqmWJAmmwyS78oh2hgLrGKowJ9EUQ63F6sFwKkoaVR
         wbW5Qeg3DGzR8WFee8qOf5utXAqxwWShcpWjxnUzK31YV+XowsEhN+dLNfHp8svEV82H
         J8b6iWhMbMCtP+uhP27mhvfz5l/FVhZi8r8+Cm4Y58IPjumsKSqzygdzABaUrbblptwH
         TYAi7Ac6TJpJiz86HLHNQfUjPO+20QmbyJqhWXKr+brYnRyu8oKyZiWNF1YgYr+witDn
         KIeg==
X-Gm-Message-State: AOAM532dg7qRHw/CvuAbADPsgCntmUruYrZZv3wxOTtAIRB+B7Q/XNp9
        fvMsfko53nEd/FCg9m6GGyY=
X-Google-Smtp-Source: ABdhPJxynYLdfD7W3pkOYMucQVBgqBpW7CA9rA6VS2J9L9SPbnwDuxXPbPJ57uu1Dw/WLJ+GF1Zp6g==
X-Received: by 2002:a5d:4243:: with SMTP id s3mr12785130wrr.31.1611215105846;
        Wed, 20 Jan 2021 23:45:05 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 06/15] trace-cmd: Add host / guest role in timestamp synchronization context
Date:   Thu, 21 Jan 2021 09:44:47 +0200
Message-Id: <20210121074456.157658-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-timesync.c            | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/trace-tsync-local.h b/lib/trace-cmd/include/trace-tsync-local.h
index a99725e2..1dea054c 100644
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
index def703f6..f3cc2da6 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -296,7 +296,7 @@ clock_synch_delete_instance(struct tracefs_instance *inst)
 	tracefs_instance_free(inst);
 }
 
-static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
+static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
 {
 	struct clock_sync_context *clock = NULL;
 	struct tsync_proto *protocol;
@@ -311,8 +311,9 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
 	clock = calloc(1, sizeof(struct clock_sync_context));
 	if (!clock)
 		return -1;
+	clock->is_guest = guest;
+	clock->is_server = clock->is_guest;
 
-	clock->is_server = server;
 	if (get_vsocket_params(tsync->msg_handle->fd, &clock->local_cid,
 			       &clock->local_port, &clock->remote_cid,
 			       &clock->remote_port))
-- 
2.29.2


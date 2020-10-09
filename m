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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94429C433E7
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480BA222C4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Oct 2020 14:03:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mgLUI8FZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgJIOD5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Oct 2020 10:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387416AbgJIOD4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Oct 2020 10:03:56 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E811C0613D5
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Oct 2020 07:03:56 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p15so13237502ejm.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Oct 2020 07:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xTepxL7zWXwNOSHTVl8Wl3ZjVMbnCa1UtuCYvEN7BSQ=;
        b=mgLUI8FZ4FJBqYHwsIJ4M+atPiYbpj6+rmSduN7wOeNsj4E6O05uFaaAq+YTv3b55U
         2oyvxI1nyvAuXQuOXaUjVy/Cf1SH9tgPvZbIFiEt+7yOV2SBZAwMjVp3Wo+xbCkKtkHn
         Hg7HUTCjk8dn4aFhN+sM3UGK3ZiLevrWkDB+AjOY1ZBp019BKotp9YkGGZYVskcrmDco
         k52Px+56On/E/W1uV4sau30DtLdh2MxAKCrOhZM/YY9Fzhm9ycgTEIiRGaN0GuqL8NxU
         qFm5yKrBK9Nt55/c2Hyw31Ne2yiphdv+LkZTzYbv306mooayLAjPAgW0F0t7uXKQxSg9
         UmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xTepxL7zWXwNOSHTVl8Wl3ZjVMbnCa1UtuCYvEN7BSQ=;
        b=a/tmoqxyyrCW10sJDBe0uNG7dtw8ZbAsCUZdaEiCV15KEkiSsIQl7JQJkGD0IypmsS
         wW7TTTl1Z5JKbHc7mCPP4DetKeh9e2HdzF8wAYltCruI+2iY9qvEVqjJrqMwLHapLNym
         FuI1F7DcD+/ptAuvmJuKPgCFj5kmrVSKkLut1HzPlfmOyQb4k0qvcS9VSz+TPTvVnVDj
         gWXypKJQR8+5eqXqPq+pVN+flqhQVKfsMdmkGVvfu5NdhQp0MtBGjSwG00t/UzBKySoU
         /ST54aWu906Y0WL5Y0mzu/KEoDXrAuI8SJi88iI87f7dQGTkZLtw0T3BXvLAEnHgauSl
         +fsQ==
X-Gm-Message-State: AOAM530e0Yf9gGHIANwofhxG5nDQUtOnSkRmtokW0wbwnQ7dI8c92iA9
        IMq6PmJe054yK2Sjwe1WlvzXrYN9KzoTTQuu
X-Google-Smtp-Source: ABdhPJxhVeOPH55g4bf1xg9EFpk5azSsF35wveT7t5zW5FRePe+gDafhjCebUDro+NViOinuIFrQNA==
X-Received: by 2002:a17:906:b104:: with SMTP id u4mr14000558ejy.121.1602252235086;
        Fri, 09 Oct 2020 07:03:55 -0700 (PDT)
Received: from localhost.localdomain ([151.251.253.218])
        by smtp.gmail.com with ESMTPSA id ck19sm6362483ejb.99.2020.10.09.07.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 07:03:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v24 08/10] trace-cmd: Add guest CPU count PID in tracecmd_time_sync struct
Date:   Fri,  9 Oct 2020 17:03:36 +0300
Message-Id: <20201009140338.25260-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009140338.25260-1-tz.stoyanov@gmail.com>
References: <20201009140338.25260-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_time_sync struct holds the timestamp synchronization
context, used by the timestamp synchronization plugins. Guest CPU count and
PID of the host task, running the guest, is important information which
may be needed by the plugins.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h | 4 ++++
 tracecmd/trace-tsync.c        | 7 ++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f1068c49..48ed4bc0 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -457,6 +457,10 @@ struct tracecmd_time_sync {
 	char				*clock_str;
 	struct tracecmd_msg_handle	*msg_handle;
 	void				*context;
+
+	int				guest_pid;
+	int				vcpu_count;
+
 };
 
 void tracecmd_tsync_init(void);
diff --git a/tracecmd/trace-tsync.c b/tracecmd/trace-tsync.c
index 051b1003..27718172 100644
--- a/tracecmd/trace-tsync.c
+++ b/tracecmd/trace-tsync.c
@@ -77,6 +77,7 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 {
 	struct tracecmd_msg_handle *msg_handle = NULL;
 	cpu_set_t *pin_mask = NULL;
+	struct trace_guest *guest;
 	pthread_attr_t attrib;
 	size_t mask_size = 0;
 	int ret;
@@ -84,7 +85,11 @@ int tracecmd_host_tsync(struct buffer_instance *instance,
 
 	if (!instance->tsync.sync_proto)
 		return -1;
-
+	guest = get_guest_by_cid(instance->cid);
+	if (guest == NULL)
+		return -1;
+	instance->tsync.guest_pid = guest->pid;
+	instance->tsync.vcpu_count = guest->cpu_max;
 	fd = trace_open_vsock(instance->cid, tsync_port);
 	if (fd < 0) {
 		ret = -1;
-- 
2.26.2


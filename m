Return-Path: <SRS0=entZ=EE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAFC8C55178
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 917E52076B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHqNwyiy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgJ2LSb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727517AbgJ2LS2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:28 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93D8C0613D3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k10so981763wrw.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MqxGgrpZYfQSn1TJE5oKSGtG4OzwEvpheqILMhjdA4E=;
        b=eHqNwyiyyA1fIKwmgrvLG1KsBfn3vBQleqCX36Md2hEl4oweX0QP18RnWwQxdw8mp7
         yUHHS2HBLTof21NYWpGwhY3DkzXGbrTlWwWq3udTZrWranMPc2h3dbqPnZ1bDLn0xB0V
         Bg4bmLtICYkp0ZYKTpHSJVoIzMQlSIVh/vzMhZGVhjRWKmqbqtcStKzjU9dVtX1lDucc
         TUNkU7Oe6HSPQ6zM2WwOphhy/6ueiREPRFoJi/cbFMil8DIfeIquz0gVxsSfRy0rIqCA
         B1P/C3kU3iP4iN+U7XbyFuUWDHtDPVP8YUt46XVoLPlr5/f6DUyS1rZ0urwRRBu9eW3S
         xRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MqxGgrpZYfQSn1TJE5oKSGtG4OzwEvpheqILMhjdA4E=;
        b=s7DfOJsdXzB2BHvSZgQhKazl79QxwNN8O+4Jl1oJehj5LXINZlJbm5wd4TvvIKFN6P
         A6t31Y6TT5rVz3wB3IjY6sWBXxhHW5Vpp+E5s/MvXViXMVDTRbh4KNjZESK016JLr/Eb
         LwfBjxSsREg2dM+t4RQ7wx7Ek188MiN+qDtmQkTR3RjtakVdO+0LvyE5HhIsakRFxN7V
         STY0SFSgmZosN9GuFviqT574WilI9I4iIu6xLfgcs3L94nM+D8CsMB0KIkjbs5w9bJvH
         JLB3mCo2AA/mX2tsgOE0QcGp4q7EV8htLmqdrKY23LX+48DbIvFl9VdntsNG1vYilxc3
         j7EA==
X-Gm-Message-State: AOAM532oYxdliOcK8KyMkxHerpTNGtdXhT+fnCidYxVkmkruRLe6AC6/
        xs/eXM3QEG1J0IFXBi1UkKM3+JEdLIndxLcT
X-Google-Smtp-Source: ABdhPJxD1FofchFf/sqDajvLl7WJ4C+YIL7duuyqNONLsHw+y2XomCimnJjCARsX5aY0jKFw/aBOQA==
X-Received: by 2002:adf:9e08:: with SMTP id u8mr4766171wre.282.1603970306679;
        Thu, 29 Oct 2020 04:18:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 07/16] trace-cmd: Add host / guest role in timestamp synchronization context
Date:   Thu, 29 Oct 2020 13:18:07 +0200
Message-Id: <20201029111816.247241-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
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
index 33add609..793737e8 100644
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
index d461392b..12e00686 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -283,7 +283,7 @@ clock_synch_delete_instance(struct tracefs_instance *inst)
 	tracefs_instance_free(inst);
 }
 
-static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
+static int clock_context_init(struct tracecmd_time_sync *tsync, bool guest)
 {
 	struct clock_sync_context *clock = NULL;
 	struct tsync_proto *protocol;
@@ -298,8 +298,11 @@ static int clock_context_init(struct tracecmd_time_sync *tsync, bool server)
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


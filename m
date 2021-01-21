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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2E2C433DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29DA6238EC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Jan 2021 07:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbhAUHrg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 02:47:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbhAUHrB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 02:47:01 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C60EC061799
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:12 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id m4so726350wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 23:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KAch633jbKKZzuaBgUWOLuw1zMVNfMNzOt2D49kCjgQ=;
        b=u0kziTCaKGeOp0ARClWADJV/uC7dgm1uFRRS56ZOBnqydWoyhj+ZztTheZN0sZUsYB
         WUhAJD1uusFFOMLBeMCWBnLScxbeFxNv1b10ApiWerojh4TkZMJMpGWl1CWx+H01YY/n
         n7gj88kH6Q7ZGMX2QcMdnTbC7kdY3GRbrm2Kc3yQGiEjTiizbzyhr+/Lh/Be0Cdv3km0
         d5xgx8YM2FuTPctFaiBGbbKDEN7SeHYaLwawqhk4lrn6ypIi1OB6D0y2/GILl9cV+OQY
         xnNWMpTf+2TLmqxiTvD7YBwRhl7yKrN0uaNAXo+Ymau1ub7YaogmlPqnti0tmCa9dhHy
         6mCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KAch633jbKKZzuaBgUWOLuw1zMVNfMNzOt2D49kCjgQ=;
        b=EtN1jx8bKu18a1bCLT+P5ZWXRfKsJu9wXV/Dd3qYbWSQX2xfKJZm0F+O0iWvm0vlZ0
         KqkVmLJRYeyr4TaqOxR+r4M+VqUM+OW/FzsstFwRY0Iru7U0JGRVFPyNcHhTWvCtAbep
         1bW/OlfWMSiQ5Yil92ONWU5LEtWaEiXexBfJwxq8NLnZBIY4hb5Fq6WTgTQqoH87K4r4
         +W2y/HrP/QFYmoKS4HKxwJAbvB/X04wNJJoSxDzJg6vjc0LXEzeJOyrbSDCV17tqs4HK
         H8KQ1gkcN0dUHPZjFh84aZIx6Lc3n7Ph9/YgD+UTbkJ3m04OVcX7CABrAdQFYFs6KUOU
         Sepw==
X-Gm-Message-State: AOAM532PclaMMLOqMnFz9JhbhKgTaitoWtV2AINm4uKErlAbVTveJcU5
        27dxGfnggkCkLQoxxa1H9s0=
X-Google-Smtp-Source: ABdhPJy1KeMfXc5LzVpBdxXlYqbCfA/KE3l+JSH3lvbSeJZgfPY85wUt2zYvBHNMO5wtF3PeCR4l3g==
X-Received: by 2002:a5d:4d86:: with SMTP id b6mr12837953wru.152.1611215111397;
        Wed, 20 Jan 2021 23:45:11 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm6788474wmj.32.2021.01.20.23.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 23:45:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v26 11/15] trace-cmd: Define a macro for packed structures
Date:   Thu, 21 Jan 2021 09:44:52 +0200
Message-Id: <20210121074456.157658-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074456.157658-1-tz.stoyanov@gmail.com>
References: <20210121074456.157658-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Defined a new macro
 #define __packed __attribute__((packed))
used for packing the structures, to make the code look cleaner.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 ++
 lib/trace-cmd/trace-msg.c               | 14 +++++++-------
 lib/trace-cmd/trace-timesync.c          |  2 +-
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 0cd27441..d265e4c8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -12,6 +12,8 @@
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
+#define __packed __attribute__((packed))
+
 /* trace.dat file format version */
 #define FILE_VERSION 6
 
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index e0cdf677..8d2ed38d 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -57,11 +57,11 @@ struct tracecmd_msg_tinit {
 	be32 cpus;
 	be32 page_size;
 	be32 opt_num;
-} __attribute__((packed));
+} __packed;
 
 struct tracecmd_msg_rinit {
 	be32 cpus;
-} __attribute__((packed));
+} __packed;
 
 #define TRACE_REQ_PARAM_SIZE  (2 * sizeof(int))
 enum trace_req_params {
@@ -79,7 +79,7 @@ struct tracecmd_msg_trace_req {
 	be32 flags;
 	be32 argc;
 	u64 trace_id;
-} __attribute__((packed));
+} __packed;
 
 struct tracecmd_msg_trace_resp {
 	be32 flags;
@@ -88,18 +88,18 @@ struct tracecmd_msg_trace_resp {
 	u64 trace_id;
 	char tsync_proto_name[TRACECMD_TSYNC_PNAME_LENGTH];
 	be32 tsync_port;
-} __attribute__((packed));
+} __packed;
 
 struct tracecmd_msg_tsync {
 	char sync_protocol_name[TRACECMD_TSYNC_PNAME_LENGTH];
 	be32 sync_msg_id;
-} __attribute__((packed));
+} __packed;
 
 struct tracecmd_msg_header {
 	be32	size;
 	be32	cmd;
 	be32	cmd_size;
-} __attribute__((packed));
+} __packed;
 
 #define MSG_MAP								\
 	C(CLOSE,	0,	0),					\
@@ -148,7 +148,7 @@ struct tracecmd_msg {
 		struct tracecmd_msg_tsync	tsync;
 	};
 	char					*buf;
-} __attribute__((packed));
+} __packed;
 
 static inline int msg_buf_len(struct tracecmd_msg *msg)
 {
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 994a935a..8371a141 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -41,7 +41,7 @@ struct tsync_proto {
 
 struct tsync_probe_request_msg {
 	be16	cpu;
-} __attribute__((packed));
+} __packed;
 
 static struct tsync_proto *tsync_proto_list;
 
-- 
2.29.2


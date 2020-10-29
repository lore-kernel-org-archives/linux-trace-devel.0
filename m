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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A404FC5DF9E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DDA2207BC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Oct 2020 11:18:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fuMKC109"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbgJ2LSg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Oct 2020 07:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727621AbgJ2LSe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Oct 2020 07:18:34 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A859BC0613D3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:33 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id p22so937227wmg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 29 Oct 2020 04:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CrF6yHbWdBAZ3vEh5nItNh2gtt2NyruwnkyWmNi7ILU=;
        b=fuMKC109k5FiyYnCzJDEetcyGggA7zeWAjSOmfU1zYROt7xh/HrF43qiDwiINO5kkh
         fXnzvcQ59L9hRCPjDSXEgxfLg3YFj0Gx1NcKYYcIsSPUW5IZY6JAeWfVFJaPsNx9lizo
         UbVv5lrmFkXBHNHraJH/t/5n/h1HARS2iCKmUTBQQvlMJGqtJTR2QFJDDK28e3cUd9a8
         GHZJ6yiQ5DtvuYTymIL85iBy5JkBb4T5vE9o03gqfNw3LI/eZaw+KNdkCaEpnCVEqMWW
         VhfrqCipkocKToWRXFZQdlQZ+Ix9jsBWjHOOhfHtD2DEOHnb7y4h+wsh07z2r13FKDkE
         J/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CrF6yHbWdBAZ3vEh5nItNh2gtt2NyruwnkyWmNi7ILU=;
        b=S7ScrPqVepAuqVDaTlRQIsMeSej96F09idX6nCFLpOMZ9DHwvxbW/zNMAwdppkVfNE
         S/9EqwnwTSO0DG1kLf2GhhofZl5KiZQm8hVgL8W1nlZ9e+BYoIv5XBL3XSjZnaCFs1YK
         n7QyB+aKW/2UyTy5ffGtYffwTykFnwJgTxwb7vQ7TuZTeCir8Pu4/GqmUK9UH0Ah54+x
         1ZI0Rln19KJPQCNfR/Md4wWILoTiheP2v1iq831QrFPUJTCYaL25M6k621xLnVJCv8g/
         n6BeDFCXkxw08Vi7dXGYBdOjfxgvmjX7KSNQPlMyCwI4JjkYBQd03AIWo5U9tj3ie2/J
         7lMA==
X-Gm-Message-State: AOAM531sUJ5LgNd4/oUmLduk8pnMK/EY7MYBdBBY9XyuL21Q4hRqsM9m
        ldJXYxXcABezijpkVnfSUqg=
X-Google-Smtp-Source: ABdhPJyBGFCXp5UnnzKoCCo5Qncacu1cZ3wTf75Y0nJAb/XMqcc+//qwpE3sizqIbgfGrPNyu1ZSYg==
X-Received: by 2002:a7b:cb8d:: with SMTP id m13mr3748524wmi.59.1603970312456;
        Thu, 29 Oct 2020 04:18:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a199sm4308067wmd.8.2020.10.29.04.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 04:18:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v25 12/16] trace-cmd: Define a macro for packed structures
Date:   Thu, 29 Oct 2020 13:18:12 +0200
Message-Id: <20201029111816.247241-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201029111816.247241-1-tz.stoyanov@gmail.com>
References: <20201029111816.247241-1-tz.stoyanov@gmail.com>
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
index 95dce66c..19f7add8 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -9,6 +9,8 @@
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
+#define __packed __attribute__((packed))
+
 /* trace.dat file format version */
 #define FILE_VERSION 6
 
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 59ff33c8..905ae281 100644
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
index 676a9482..40d50fd5 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -41,7 +41,7 @@ struct tsync_proto {
 
 struct tsync_probe_request_msg {
 	be16	cpu;
-} __attribute__((packed));
+} __packed;
 
 static struct tsync_proto *tsync_proto_list;
 
-- 
2.26.2


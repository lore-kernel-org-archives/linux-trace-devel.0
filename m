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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1B4C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51CA5610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhEJGRv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:50 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF5CC061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id zg3so22730102ejb.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TgrEkpK0n5ohS6Kr+I4Byc4/t1KCKAcwzKJLo6TD8vA=;
        b=Fnz1wFaWMzCOanLn5KMXpNEG3MG1V2+gpOub+efjhUnDi+J7boa/W6f3AgZNBnN3Vo
         0IbB08M1jN18TIifz59kNH4axRc8fGETssrFMveJeFMZRDFVLuy4PRWvqRB4RKV3i9JI
         ALhM9j6iznggJwofMla941ldQYtNfdLCrj3RTw92lgw7QECpbwuPMNM/nybT0bMmki6Q
         /U6MTx0LGrvtHLu8ZldY3OTBJ+wBZeHUu4KzStWgZszotqyeyD3rlLY18VBOylfyx6d/
         C8NnzM9yGucPyhxeXATcSH83wdBa9gHqwXFbG9Rc/LqCyHOdRShVm64VS0pTmXn3qWOr
         uZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TgrEkpK0n5ohS6Kr+I4Byc4/t1KCKAcwzKJLo6TD8vA=;
        b=leMJPTn/c1UEVsz0OgxHWZbdDP4p+6qC21qSyA9YEAMNIXCX39qfAPIRo3voFIepF+
         AVF3UGZC+H5XkGPmBFv1RjuMFyswsSmpsZ9qNP8fJ+F7m/6QjV+4Sn4rKeW5LkRVUdcU
         f7RjfPdU/xcFrxmcLRueDWQNH404pqAtbBPidKYwP+o9jBFo6YxH8AeUt905D11jDB//
         1J+a+20+75SQ+xYW+eXgkm4x8H/e0OS+p8gh5/h+MsPOojWrrf7sbcOU8XmxOhRyAdwf
         zMXqqGLMvCTwen+2r++IE1tg/Qf5uIWNTlTaBpTh+c/nSTxJxAD8GIyDKVpwWX+M82zE
         EZXA==
X-Gm-Message-State: AOAM533tSkJTEA4/38UYUDqq3qbJnVpV1SH8GEOcWxNBBkNCJ007xxSp
        pvM9KUWiET39/3i60kMCozkfN1czkwuTkQ==
X-Google-Smtp-Source: ABdhPJzO5FsAkFjH7pj804WAIB5ooeKpDwdY2gFnqd5trnASq3eHHUnr9oEImEaDwe8RKnUT0XVi3Q==
X-Received: by 2002:a17:907:7882:: with SMTP id ku2mr23699467ejc.346.1620627404130;
        Sun, 09 May 2021 23:16:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/21] trace-cmd: Add APIs for library initialization and free
Date:   Mon, 10 May 2021 09:16:21 +0300
Message-Id: <20210510061636.1794357-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd library has no APIs for initialization and free of the
whole library. Added these new APIs:
 tracecmd_lib_init()
 tracecmd_lib_free()
and call them in trace-cmd main function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  3 +++
 lib/trace-cmd/trace-util.c                        |  9 +++++++++
 tracecmd/trace-cmd.c                              | 11 ++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6a211333..e410a6f1 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -29,6 +29,9 @@
 
 struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
 
+int tracecmd_lib_init(void);
+void tracecmd_lib_free(void);
+
 int *tracecmd_add_id(int *list, int id, int len);
 
 enum {
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index a6fc64c8..3ef10eae 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -589,3 +589,12 @@ bool tracecmd_is_version_supported(unsigned int version)
 		return true;
 	return false;
 }
+
+int tracecmd_lib_init(void)
+{
+	return 0;
+}
+
+void tracecmd_lib_free(void)
+{
+}
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7376c5a5..aad8e0a7 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -116,15 +116,20 @@ int main (int argc, char **argv)
 	if (argc < 2)
 		trace_usage(argc, argv);
 
+	tracecmd_lib_init();
+
 	for (i = 0; i < ARRAY_SIZE(commands); ++i) {
 		if (strcmp(argv[1], commands[i].name) == 0 ){
 			commands[i].run(argc, argv);
-			goto out;
+			break;
 		}
 	}
 
+	tracecmd_lib_free();
+
 	/* No valid command found, show help */
-	trace_usage(argc, argv);
-out:
+	if (i == ARRAY_SIZE(commands))
+		trace_usage(argc, argv);
+
 	exit(0);
 }
-- 
2.31.1


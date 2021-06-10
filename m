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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FAAC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B082A613FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFJLgo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJLgo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:44 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA8DC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id v206-20020a1cded70000b02901a586d3fa23so6198518wmg.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2G0CILf23KT9a1hgIdunlhYcwh2NDqtDLL7z1ixvlIw=;
        b=RSSME0LnG6yecone1S4rHimrInP7gyMWdWxxIBTd+N5ITTo9fZW/nTKTh9aasUil34
         aMtRu1WRtQuGiRu1yi6QhWHYM9wlSNyGFmkMx3ZsJznx3v2WBqSxBKN95ZvHZtDvbU76
         /j7BdMfRl2SxbDiblfuFj6YqbRO6CTyMELluHIvWNoCTLUqK72rFcZUY51WBPR5DoMzC
         0y5XdqrZ4FyRhukGx2PRVp9T0yaHDRJIpC5SqsMxJFN4NdYYH/YM7Uqdo7f2iV4kT9Yi
         Fb3DUcuymeq842jgxwVMGs6Sg3+gB+QLNcNqvEXV43IqQSTerap5SOIHHxU6PFbN1S3L
         BMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2G0CILf23KT9a1hgIdunlhYcwh2NDqtDLL7z1ixvlIw=;
        b=dLTB9/JWaSKr/5wwwr0uIFJXLWQ4w33QO44/szJJDSkOqztovJvtQwqZ1JIXTmDf5a
         i+jbPFPr5UP1k+HT+vERjUhxB4k1NPlJ+ZK1z4Dek517JPfyMGcj6Fv0ZPc9ntMEwfUV
         0jlum0cnrgbRIxtL6XYZVpuiHYWA7F327KornRRZ/sVRtONjN3ZmzAdIbnC5H6HAmXfA
         NrmAv3Owt0ylXVY/KM5oo0rqiLl16ncfD/qSiSHS0ba+sI9R8vvN2YCwZyN9JBhXaLjK
         +Q5znUBNN0LRVnSNUJyCaVF8T8XZ1ozWnyYT1Q4cA+6DJOR6tXv8bSnLXQ0m91JYSYju
         IpWw==
X-Gm-Message-State: AOAM533fOa+uZ8Q2VsR02Kk1YC+Z5WB2SJHz0OdFNPS0Dnnj9xZ1PV8v
        xvUnXxnJGViAitC9bNgBxEQ=
X-Google-Smtp-Source: ABdhPJyuk9jgH75bp5a5JGPvrHz7Ms8BCJvui8UtpWnmNf79EvUWaKMc/xi05n4saKyalnN+1x+j6Q==
X-Received: by 2002:a7b:ca44:: with SMTP id m4mr4580435wml.52.1623324874700;
        Thu, 10 Jun 2021 04:34:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 06/40] trace-cmd: Add APIs for library initialization and free
Date:   Thu, 10 Jun 2021 14:33:52 +0300
Message-Id: <20210610113426.257931-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index 01b12c47..be8b3c48 100644
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
index b0c98c72..61054ad2 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -624,3 +624,12 @@ bool tracecmd_is_version_supported(unsigned int version)
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
index 00cdaa37..71c8f6d6 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -142,15 +142,20 @@ int main (int argc, char **argv)
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


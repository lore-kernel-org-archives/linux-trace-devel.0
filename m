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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C5EC48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88EF161352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhFNHwm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhFNHwm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:42 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA696C061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:39 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id c10so15025158eja.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2G0CILf23KT9a1hgIdunlhYcwh2NDqtDLL7z1ixvlIw=;
        b=BgszJMdOXI9TWHx6C+RFfz5ANOBl59lke5w+pxtbG6aPZazrH34xbSsVUf7A7tTQCF
         BdUvgCYnXzzq2dlS/2PN7CfaSP2ZIJY9ryd5qdXwTHgRM5x6gXLaiXzAwMRe3itYApst
         08VH21/YhNNIr/JUTmpS5RYL0ewDlIghR0AiZgV/42PhFARSCpbbonRoMs5xs+6pPsPz
         ED5Z37XjQkXWY+u8N3Tvhs03xXxEchdCe80CYYJyIrMogYd/dzKQqEVcUeSIoP1ftLy/
         k6JWuwWf4RQR/bapzHj+qxrxnBlfqc+CYPo+nHsJDetmcGpJa0RY/XdIBkdIfrYKdKsj
         xZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2G0CILf23KT9a1hgIdunlhYcwh2NDqtDLL7z1ixvlIw=;
        b=P/3oULEr1fPXMG+J9/OwRT2V/ABmws70GyAIotuvttlcXSBmfF/slfXMA1LkIUk3zP
         3hA8oznPAKE9cf9Lt7X7nQ9NaUaGFbgNYxVktCyo3b0fDiZeqvEiNSlGQ29bX0LwWINd
         Dkw85Hh2avWAKJfz8v55PQxuSQpbIUS9w6w7zDkM7ExoHhbcSWwCxzHMT54Is0piDoIy
         aQHWpliNBuBM5IQMDrvfFHx3YbopAeCIXUy5T0tR5VSjVRF4PuZo8ry9BfFSjNt9Nh8L
         E05zLxGQ40LfSwdkeAIifriDFQos+eAgz4YtaNlDRugPXtFL3AirCOVORQHw3444p0Sr
         nvfQ==
X-Gm-Message-State: AOAM53297tn0Xr9EG77dL++ZyJBtNcmNqb12bc2FUl5C6TLj6nFc+DfW
        nZxF/GfPz0to1i7P7SO3PdI=
X-Google-Smtp-Source: ABdhPJw0t7h9Tsiw3Vx+wKJbKpVhA4XA3bmxtlxugKd66T8DxWVNnmwtTRKssXG/3ersxYAif+o2cA==
X-Received: by 2002:a17:906:3888:: with SMTP id q8mr13969007ejd.15.1623657037751;
        Mon, 14 Jun 2021 00:50:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 06/45] trace-cmd: Add APIs for library initialization and free
Date:   Mon, 14 Jun 2021 10:49:50 +0300
Message-Id: <20210614075029.598048-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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


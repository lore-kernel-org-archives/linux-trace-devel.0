Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F335C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2056D611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhETDVc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhETDVc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:32 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2F8C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:10 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id s22so22733982ejv.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PQUYB1qHIWalGZLN0HLBYN4T8dtYe86QUofDMP/GfVo=;
        b=CBP2F1GH/144cIg334+dCmhdBXkWn9MQjOg1/jurvtpVWd9q7659P9G4f27vrXBoCT
         FNlPTlhCQrom35jCxyVX1QSg3K3kEtKay5sY2fMKuykxbF3WOI0kKiBzDW96+Pj9qI5b
         GzARPULoemixDD1BCaVEgJo9dL2P9EWh5cecwkekeyUyX5NfRvPtmh1UY31R/ebqacd+
         xcR3bfWNwJscq6KN3fcrZA81BD1gkxFZLCZZKWIILm/ECThQJ1pZX3GXJxR5HwKgmvwD
         iUljmdTZpjW/2zCrnhpgW+Gr8H44b+xUVvToGOP+ZHo8yqdN1au8dg4IXg6PV1f/s9FI
         UjmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PQUYB1qHIWalGZLN0HLBYN4T8dtYe86QUofDMP/GfVo=;
        b=bBmX8nYl5Njl/UTBclJxLJzvC/KIpYolbgExeRjVp+LUGkA6s7H8kwz8Ehf2MaKn5g
         RXai56SrUA+Le2EzTkn2Dg/mUMyzPSWu377WoDCYKskJ6DecerTXr+RSo34prG/s+jd9
         NEO8ruKJI6mvruZYNKJIT4RwoGvkNWYOz+eB5m4EcEc7/pCxo48Wzk/Ozuq/EBDrURus
         69Xmv2E9DwrYKzf+7WwMykvVUl9wnxcZfhpJM4uEe/zcIOMHmSN4TGndifWvb7ADdvfR
         JSIqR0RWLkDRMonFpZh9zPEFq06S7+tmgq3i+/6T6yEfoat3TSFcCvurbicdEeUwszEE
         o7FQ==
X-Gm-Message-State: AOAM532WPhX6Wvo5otcA4C0Eij/CLgpjFZUSpk1axASKwN2n20+xySIr
        ko+J+tgGFkYt3mTzJ+KcjVw=
X-Google-Smtp-Source: ABdhPJxTs/kd3UA94Gl71Scf72zHSzL342zNeZPZLXjJ4+iTXyrHfZ1Fu9U+H4f+acmBWdACyODXZQ==
X-Received: by 2002:a17:906:bb0e:: with SMTP id jz14mr2394865ejb.285.1621480809014;
        Wed, 19 May 2021 20:20:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/29] trace-cmd: Add APIs for library initialization and free
Date:   Thu, 20 May 2021 06:19:36 +0300
Message-Id: <20210520031959.346165-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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


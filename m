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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372FBC43470
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06274613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhELGjp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhELGjo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:44 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E465C061761
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:32 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id f24so33314576ejc.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TgrEkpK0n5ohS6Kr+I4Byc4/t1KCKAcwzKJLo6TD8vA=;
        b=k9QGHgpi5eRQSvm6g49vW1v5f03PpfKwlX5ucbERAzxM4YoOlCHaAnlaGLpxSEhY6D
         nzH1Be5+Kqp4zNrE63k1E7i3x3VNUfbcZbzwWsPx9mV3Im4M9kUph5G4ZTC9NenPrQ1T
         Gs/7eXSFcRBuTCYDq9R3TyPEhZrk/dlM0JurffoxQoB5DxYbFgFGF8rDkO3/8BgHMKA0
         PCZ9fOgu5tPzJjVoqRXnh6ZGS8f8/BAhuo3RimjD+SwYGI9wFmCCizPRkcnCSr4wboQU
         ehBxE1wuT9DLRRqABmWPeTAOpTBiuTnJErieSnuDmW0SDlcbtQOQsmSdMCVQfM/RCYXt
         vEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TgrEkpK0n5ohS6Kr+I4Byc4/t1KCKAcwzKJLo6TD8vA=;
        b=Fl2/Ftv1nv/VElvuFXH/2eM4LuWmWds19dqKtN3Np4dSqGlGcQTLqUt6oi0vibPrX1
         WG4Cm72O04CaAnCB9Ymlbj0OpLQlZyU97TUMSEilbG+M2gH7Ur0QVWQXAe9pjGa8YSJC
         55Z+KOoMcG/fEEgjtyyw62jJLfhXs6qJP1CFWL1KB1Vr6WrIlmvh4jpvfc5zPBqiWK2h
         lUj1/5MOl+5QKIJEZLQjdDid7Fl6QyKjJU0DRn77ZiEAOJBaenk4AVvSKH1d0nD3LPSo
         BOXLifhlZ1EuLV9sAi38ec5pr0qNsKTDBHnPPsaFW5lK4RFDBveH+9BCrylIRuzdeMU4
         Q3cg==
X-Gm-Message-State: AOAM531aIVGOQe2zMPtCvvtgQp5/46zZ7wCEhS5pdrwI8GtqKQVY64Ng
        eGZlyQwK9YbpJD436KIHE0c=
X-Google-Smtp-Source: ABdhPJznGmqDQTtpXBJ5yzuxaEfPw7FR9IS2O2K88etdDrQFdt6KDIq5jZEmcCYRdLAMzUSdOqLQBQ==
X-Received: by 2002:a17:906:3458:: with SMTP id d24mr36777318ejb.54.1620801511588;
        Tue, 11 May 2021 23:38:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 06/25] trace-cmd: Add APIs for library initialization and free
Date:   Wed, 12 May 2021 09:38:04 +0300
Message-Id: <20210512063823.324610-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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


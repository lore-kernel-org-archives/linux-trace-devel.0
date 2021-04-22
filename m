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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35F86C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06FE761168
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhDVHjm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230513AbhDVHjk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:39:40 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DD8C06138D
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:06 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id e7so52142909edu.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tD3InqFDJAvnvwkS08RU2E21b/WPtaCtRWIudRAYOnc=;
        b=dfD2IZ6Qxo0NA6b7jIvnurkD+iAlKXqi/PPkKXjTY6aCEEssRJqKIcTTBg1Q/j9DN9
         ZkOsh4h8W2Zp7YP5+vzzJ8c0o03HfDlCOxpdAdZbA24kPJ5aQGFX5/1km0K/jD5CHsrn
         xXSzeYSc5wz9DRgwig1EbcV5jIvCoPXBcr125iVjhpgIR5JbS787E6YTrDnqi7ubGKyw
         Takt7NxONCQ0gTK+qdY7myR4g/hUm1auvU+aWxaBUVgbvXQCrIeuySFHRXj4whALd8Vv
         mxaohOZWtYz4nBMFY+UMMHY1zut8KbSZhrkj6/gm/ax9r74013QkFFJmKbVahoSHwEOT
         TLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tD3InqFDJAvnvwkS08RU2E21b/WPtaCtRWIudRAYOnc=;
        b=skw8H/vi5yd5HBs5IVqbteSTGMhxzgDucnGFlzo1YDfxCFXoWrodGJ4U6+Vwgg8fGq
         YtXN4s3sTK9Uoc+wytV6W+dKDCjgf+G0obpD8U6X5DZx9CN4argvOtPUS0WSCwFjau+H
         bmXUKLZmbuGhXMQjjSrvA7P6IEV5Evlmyc2CN9Rvwa2pqitIzwm990uzEzVFweK6uiQp
         Q6w9pxYlW52JJZj26KObPfcw0PCwkf3wn/SehoN7T2eccVf7QqIQWgVCF1FufxOYC0aR
         FcoqO/6/sz513gvrSueR1kCbfsk2BJREn1KEgxDgruITT8xzC+QB9HOWUFaR2ldsPsOW
         mRHw==
X-Gm-Message-State: AOAM531LIltF6H0iyU7ycD6bh6AMYOWmECSwrXGY5mUJjnKfXu3sXFI6
        FUtsjIdEu5wOhx79jC7cfhjQR9swBOWm2g==
X-Google-Smtp-Source: ABdhPJzqdtKrkoX770FI0hi4Xi228bWwhHliwlyPAlPiboRXKU+tpRzmtodVf5fmlj/o54ckNJuESA==
X-Received: by 2002:aa7:dac5:: with SMTP id x5mr2098730eds.286.1619077144946;
        Thu, 22 Apr 2021 00:39:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s5sm1253692ejq.52.2021.04.22.00.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:39:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/10] trace-cmd: Add APIs for library initialization and free
Date:   Thu, 22 Apr 2021 10:38:53 +0300
Message-Id: <20210422073902.484953-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422073902.484953-1-tz.stoyanov@gmail.com>
References: <20210422073902.484953-1-tz.stoyanov@gmail.com>
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
index def01b68..5d35b197 100644
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
2.30.2


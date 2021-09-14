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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0733C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B2B1610F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbhINNQJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233235AbhINNQI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:08 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8AFC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:51 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 192-20020a1c04c9000000b002f7a4ab0a49so1978482wme.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DyXosnBNVez1kJvwW8Z59R0UfU/8CDxTC6gV2dbJ+wA=;
        b=dAUyF/0DwZ6XmTQ7LyjatNtaaxiN9EoR1OvAIl4IbKX49iflLcCA31vm/VrRd8+hFD
         UWvF5FYjVvdicb5W/FzFmGUdsgsohG9SBA14PJoJ9uguLgM0EQq3Gj5fXIKJOe74kuy6
         SH1AeXy82hAp8jn4oReIHCEeM/P/dLBLZ7N08R3RoXoFriIvhi6o0AEwndhA0QJoDF9Z
         c5Y1SnBHg/pfWwGhwsK6AuKbbLhRhQtTq85bybDRGMqK5iGz1RizqpVFsQjQlD1FN2oD
         2brpZouNwOVGDmpjKoWgTJm47xJLtgQyNHFS0ICHfCDIk4CmPUnhDar9luo4gjicVmKL
         M1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DyXosnBNVez1kJvwW8Z59R0UfU/8CDxTC6gV2dbJ+wA=;
        b=T1BqnQdxM23IRq2o5ELtBkPRjp2yuvXlkPdhRHYB4mwRL6Cf40nM1ggumX27tqagt0
         GhpJfiJfoesrkEYoQYWCGKmU+StMF9zqL+AloJNbBO8PXOzWLfjgaiis0nl8bAcRO1of
         nE7XGNk7U4/eB2+isDWXO5D2hL79mHw1H/qhAjesXQHRmCC09io2I1sywryWogy3RRXP
         eCLbKrLoBSJk/I8hyLu5Jk/3wUJUPsPN5fxgTv9SgSGyvsfNNBIG1KTmLkIb6vyQm77X
         zp0LTglEoW+S9s/qQWTUdVO9gord1LSIxZjwgiutzogZDGbcX7haUBXr95qpwiUKSm0q
         bb2A==
X-Gm-Message-State: AOAM532US1aq8Wu956kXIyyvbtXQGooXguIjSsXdS5CwEfZkQJU5rzmq
        Fm7IB18UOZPLRipUPdzcaqjqkbLexBw=
X-Google-Smtp-Source: ABdhPJyYWgDNjIhpHgkkI78wFl3G0Wj4TqHJVylgpRgCd1AxDymvwUTVA/7BSVJvxhzuQOCKg0Ls2Q==
X-Received: by 2002:a05:600c:2259:: with SMTP id a25mr2162618wmm.133.1631625289863;
        Tue, 14 Sep 2021 06:14:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 09/25] trace-cmd record: Append trace options after the trace data are written
Date:   Tue, 14 Sep 2021 16:14:22 +0300
Message-Id: <20210914131438.3965484-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the CPU trace metadata is saved in a trace
option. As this metadata has file offsets, which depend on the CPU trace
data, the option must be written in the file after the CPU trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 35d9ee5f..879acb7c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4449,6 +4449,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)
 		die("failed to write CPU data");
+	if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+		tracecmd_write_options(handle);
+
 	tracecmd_output_close(handle);
 
 	for (i = 0; i < cpu_count; i++)
@@ -4597,7 +4600,8 @@ static void record_data(struct common_record_context *ctx)
 				append_buffer(handle, instance, temp_files);
 			}
 		}
-
+		if (tracecmd_get_out_file_version(handle) >= FILE_VERSION_SECTIONS)
+			tracecmd_write_options(handle);
 		free(temp_files);
 	}
 	if (!handle)
-- 
2.31.1


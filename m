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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAC8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C080611AE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhETDVZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbhETDVZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:25 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ED6C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:04 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id gb17so4920024ejc.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0C6D0NjdPESwV62T7kxwWiilnywFWC5ZrocmTLNRsC4=;
        b=cxs4R6o3NU/8XjqhYJlMCtjkJhav2rY69OD+4+Vi5A2aVdFwsjDcBbsaG0ynz157Ig
         a+i9+Ui11nFh31GqueZawP9Z2IV11K+NxVLnKFK8E1/NQcAvuRkscCXaIPvd+7jKkHaw
         MlHYNRfTGUEmO8AaTfn/tpL8oaP1WvBZVW7Lpwr28jGZTempABROHtVCOBHfiPnxXqAN
         qAP4S3Bf7qn96Y3XmqPKx1G955QTBIowIOLAa2xP/O7CA12plyXI5NtRj4CYEvq0FqQW
         7tv8y6OtgNb0z0seNU1mtgVk0efJ4XNbZAgE5q5khHgw3wIXnfqYs504rMFI3/qgXvFJ
         Yz7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0C6D0NjdPESwV62T7kxwWiilnywFWC5ZrocmTLNRsC4=;
        b=IbWOEX2a0yVaOWHRpHPKnw4qC5sIlJqq5ZBSbFo1My5MNJWS572SbenDUhuEVe2s8+
         zlHBCW5lk1nOlqofiI4B3EFvjmdflGRpizyNjWY6dIsmKeg0FShVcwfoZbRcDFSA1nJy
         SGp6Wx/rvErCqBwaXBydBTDW/2xbEnl1WBcVZGWkUdxxRqQLbIafJDkbN0ykTDKAccA4
         t/c0bVP+fgqm4BN398jHOrJAyQy4/MFqF5Kt6waou3j2ZyKWufgX5sW5dVONvmWE2Si4
         aCrbixGlrEoneYvTuKWx9v2Rb9xH30vVIbpY0/Pn5gS1q1iznqN6U/q9xn4W5JCQ6Q9N
         RszA==
X-Gm-Message-State: AOAM530jLRF/T96Y+sR3HMM34o2k56R+CVyG7OvVdqG5MzH+yRBxs/AJ
        7mKFnqQVO0vprzSUREy0ToU=
X-Google-Smtp-Source: ABdhPJwDADZ4O+2UZLpP9Rjm8lvktLYom+d5s2Rtf7nBf4C4EUorokHnxtRSKpuraMq17FSgI22nXw==
X-Received: by 2002:a17:906:914d:: with SMTP id y13mr2404741ejw.489.1621480803112;
        Wed, 19 May 2021 20:20:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 01/29] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Thu, 20 May 2021 06:19:31 +0300
Message-Id: <20210520031959.346165-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Remove these unused private trace-cmd library APIs:
  tracecmd_create_file()
  tracecmd_create_file_glob()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  6 ----
 lib/trace-cmd/trace-output.c                  | 29 -------------------
 2 files changed, 35 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 42e739fa..8ec33ea2 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -263,12 +263,6 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *tracecmd_create_file(const char *output_file,
-					     int cpus, char * const *cpu_data_files);
-struct tracecmd_output *
-tracecmd_create_file_glob(const char *output_file,
-			  int cpus, char * const *cpu_data_files,
-			  struct tracecmd_event_list *event_globs);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
 			       struct tracecmd_event_list *list);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a4a1eecc..9231c319 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1614,35 +1614,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	return NULL;
 }
 
-struct tracecmd_output *
-tracecmd_create_file_glob(const char *output_file,
-			  int cpus, char * const *cpu_data_files,
-			  struct tracecmd_event_list *list)
-{
-	struct tracecmd_output *handle;
-
-	handle = create_file(output_file, NULL, NULL, NULL, list);
-	if (!handle)
-		return NULL;
-
-	if (tracecmd_write_cmdlines(handle))
-		return NULL;
-
-	if (tracecmd_append_cpu_data(handle, cpus, cpu_data_files) < 0) {
-		tracecmd_output_close(handle);
-		return NULL;
-	}
-
-	return handle;
-}
-
-struct tracecmd_output *tracecmd_create_file(const char *output_file,
-					     int cpus, char * const *cpu_data_files)
-{
-	return tracecmd_create_file_glob(output_file, cpus,
-					 cpu_data_files, &all_event_list);
-}
-
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
 	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
-- 
2.31.1


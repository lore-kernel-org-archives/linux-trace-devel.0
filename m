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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66EACC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277F9613BA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhELGjm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhELGjg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D017C06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:28 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id l7so25742162edb.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0C6D0NjdPESwV62T7kxwWiilnywFWC5ZrocmTLNRsC4=;
        b=FRIO3pJvmFNoBVgmcWnsuKsVZ6cHQNPUCEsLPP5XN4fQwQJ5aCKf6O53c3HX7fwIyF
         yPt04cK6eVleBfC1EUM4rZgi6ThiN+WLeX6ia8hkb3QQJCwD8C1qs4AIOM3vCHn7CqkX
         VRNiqE//sSLRZSBg61S3SeooJmq9QsROOfMVlQWwCXIW560hguULFvEBgi7R5Ry0jayZ
         ta6L7yPlKzXpNwXV2QC1rvudzPRVRwGwK9DZfPieb5d5mmEiOeXKNPnvRUCN2E2WGT3C
         6KNUG3p4N7SwUGMLMRTGB0aTskPjXJk8oPZjp+6eLCYtm3v52ZIrrTxcfPfmhtWBptqB
         P9fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0C6D0NjdPESwV62T7kxwWiilnywFWC5ZrocmTLNRsC4=;
        b=QtrHhguVpdPKvAyJVDtiyhlewXIelq4vUQOppVqO7jAjZ2tmATYL0VK4Jc5Ca7xhva
         NjkqdL7FNucg+iJbPAAkRo1145ijXUXUp9VJxbVeINxF7hBWmc9x5QTiqCzbzesvyiHX
         nBbj65tgOEoxfiUyhatmpQ/XGau4fe0gQopZx+7lBLXje0SNCs+p1n3cJ4HEHa3yZ1ds
         nnsjrvNTjuappBxScaJUK3WT+2wivyFr3GxNZ7SRgwe1hlJdmqPgNdmmjmzGEihg5oJF
         MYKg97gl4Elm6hDxHcCUCr1C6lB3Y8ynriXudsBNodPLZcReVMv+ndGlIFSFBOOBdRQi
         haFg==
X-Gm-Message-State: AOAM5328rK7uaqjV/PVn42cQg7faN3SOrw+iLYAMsisIgMeUJ6QfUa/L
        iq3mnKNL9F2HdPh7zIEir40=
X-Google-Smtp-Source: ABdhPJx31c5tX8JRLoJt74kXPGXRqiWms8V3mU85EBcrijChVJ92QqWKvyD/rLY1q0a3sKsoi5ndlw==
X-Received: by 2002:a05:6402:50d2:: with SMTP id h18mr6498654edb.10.1620801506840;
        Tue, 11 May 2021 23:38:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 01/25] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Wed, 12 May 2021 09:37:59 +0300
Message-Id: <20210512063823.324610-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B24DAC43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA396144E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhD2ECJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 00:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhD2ECJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 00:02:09 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D3EC06138B
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:23 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r9so97790641ejj.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K42z27jvf+Tkl8yK1wvpfyDoi543AlzEeQPwOCKc/vU=;
        b=KP9j6ClU2N8z08PA8wcTSPQh002UEQnBTA2mEiig5DPxMjYc2bZaWyfLNhCluGEHhp
         NvD89SsfP1d7wX4UKOKv0dqU/q+uYTjJtb425Y2UTSdwC1SaYOfY2X6+fcZ5hyjpDngO
         Wqir/KjeJlIX30HEu/rKehV4zSdUfSBpRPl9YonVr0a4+rrFixyc982KBQpiDW17sNbf
         Y5lhR18mf3RCA3eVfEeNK8mxEh+RVYhI9Vx/js9y1s79GsTluB/Gkt+iO0vUgSoe6z6s
         wr3eUy7RBpWuIPjH1rrbSj+fR4Cx58Au7vvxAV9/TwLE63u+8oiIihbQFrtn+Hs0ITI6
         kMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K42z27jvf+Tkl8yK1wvpfyDoi543AlzEeQPwOCKc/vU=;
        b=TXhlwAJDr8x8g1Dp1NL/s/gw8kGqoBY5MWxG2CUP6L/KAmHp4ufHXPwyLxpgRXnyiT
         0V8ekMqU0c5yN5LtwYsx0JwNlUdeSa9mAOXV2u77V4vACmEt+0g0J1BiOiq5SlFMcjYL
         WaTdbQuNhRBjm0yfQgAeMO+33DgkwSdHUVCORvkVQtVX0evYaRLmwTLfaiqu+zmoKauQ
         A4XNZoItKDoAZbJ45f7JmfM7f7+Az6xosLfob6C6ArvH3RfqxgiXQeMe4Hcw77oefpZO
         CReZt0W9APD4Zkp5e5S2mlT3Fm5l+3CFH35Aqnf6lVao5nx0bF+ZiBjV+bhHuvpoLb0T
         5q5w==
X-Gm-Message-State: AOAM531FbsPKogeMEiWXhxomnCoqPUhqH9xbUrw+TkO6BCFSfS3zbCtw
        zN3xeiO0Eyf7H/Y6yh/DKxQ=
X-Google-Smtp-Source: ABdhPJw3AwvZSORUGsv15OSnAoy4nSDgk8o/UmwHGe5wTR57bQMnoXm6ZoSX92tgtEyA3ahRMSCTjA==
X-Received: by 2002:a17:906:2504:: with SMTP id i4mr32528511ejb.297.1619668882191;
        Wed, 28 Apr 2021 21:01:22 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1040740ejl.38.2021.04.28.21.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 21:01:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/7] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Thu, 29 Apr 2021 07:01:13 +0300
Message-Id: <20210429040119.843617-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210429040119.843617-1-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
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
2.30.2


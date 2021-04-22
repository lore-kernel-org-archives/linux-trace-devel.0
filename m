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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6F1C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A4F06142F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbhDVHSE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhDVHSB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:18:01 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D22C06138B
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n2so67184259ejy.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8YVdYqziQ/wiPAKmwlAWhU4cNGPXtR9cr+8I1AZrYl0=;
        b=tBMxjTK8RSNXnpu0AwBVNzbLgQtkb9LlORn20UwpUqtuaJ13+SW9lxJfr0Nx9bDFPi
         r1oCbm/7jw+uHvafdkoXbuUKpIhvIxAb531UPrH8QVu6F/dQ3OfEIAgNXpCbnZzIpKNx
         6vB5kGdXvYjjsyHc9EmU4KiId0Bof4vZ+3jOwWo/lX/iW9QlK8FzHnsxHcR4pPGamCIS
         dHP6HDAPCQBJVndgv7gzXJhcqLtKGwCsYH0vfM/zrefi4qenDc8lzUTOPK3lMqvWqmAz
         j6boKZ1SB7kseqAqIUqmgo2pX0OIrKezSAYeuZ5NmN8EQHWY/kaLH6vQs37mDru3L6dM
         rHxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8YVdYqziQ/wiPAKmwlAWhU4cNGPXtR9cr+8I1AZrYl0=;
        b=WKYDzTnvbbplIxNldeqC4CI0Q3ZQCcptv791i5aelwAy8MMHIe7WLxY4RHy1OrHacA
         ZhMdue/HR5ftryYhCYY/K4SV2av78B7DJAOZt070WgeipqjHp63e3ctGglfXaulzELbN
         04UFOlS51fmDvniB2X2Ea++dD2jW0aM5vjbrZGndvKMAa9P2vf1zG74JRfO98xJxzr87
         b/PcyuUI8W063EUfNtknrzJlPCKQjJnMWlfkXlIoR+jtML09d1783stCJk8faoCYpp7S
         JSoTWKOjmoKQsdSjRAbGbBreDEr+BTPwsuOMZt1CF0D9KF1judR5GI93/tOWVVbwvgio
         1AwA==
X-Gm-Message-State: AOAM533vmL9aZhAeRIHSPL6mBx5D16esRPZ+1isNV2EF3L9RzEuvuzoX
        LB6Px36tDIGlT9oFIzGzfVY=
X-Google-Smtp-Source: ABdhPJw3p/wnr9qCIdxoIJsbiptqzAwUC6DPzwXpI3ZYmPpKcvBHS6y0m4mdGBQGJRfjghhDms65zQ==
X-Received: by 2002:a17:906:6d01:: with SMTP id m1mr1887710ejr.501.1619075845390;
        Thu, 22 Apr 2021 00:17:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/6] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Thu, 22 Apr 2021 10:17:16 +0300
Message-Id: <20210422071718.483383-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422071718.483383-1-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
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
index fa5b8880..29e56271 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -267,12 +267,6 @@ struct tracecmd_option;
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
index dab07392..f36718f1 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1631,35 +1631,6 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
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


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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6E8C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD7B7610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhEJGRp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhEJGRp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:45 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EB0C061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id l4so22697660ejc.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0C6D0NjdPESwV62T7kxwWiilnywFWC5ZrocmTLNRsC4=;
        b=hJVkk80zpK6g6eldPd5byQ8j3rpaQU+qU1njU9uUhp2z5f3H4/cC4Ul+sleebc8y37
         h5EEfiRtC6VL5TWOaMXC/4hwwilPhtUtTAhuOPawc0qQh+vKV3UhvpTowg1RqYiB9s7Z
         7xWdXZhOcmeH2pUWx5bzjTI/gs2UuW8M7P1obH/0oJTuqwfQlQsl+4Hmn86hliFtxHMB
         hIC/eaohZohIqdrjn4j0He44YFyDK0ehE/E2xDMunRK4GQm0LiGf4QhP3QUMNHGAEQeS
         y5dCAAzgr91y5MJXExoUHvzNPglxSNQTH5aQZH9pdopXwY/4/oxYv/4gCmaCqS0lbXb5
         ue+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0C6D0NjdPESwV62T7kxwWiilnywFWC5ZrocmTLNRsC4=;
        b=SlNfE9TqphH4hIzEHYrAsSVPuqkayIRJVLt7z9J/4yCehyUkseCdP5vlAgkhQBl5sF
         snq/Ojo1lbeuYYl4CGWUHAAFKjokqXGW/ZZcQTvEj13sNo8h1+AignsJ6Vmk8w7p0Q6D
         no1swTfCxTw+8Y0QwpbKU/N/LbMCGSxkt70LFoAfNKuzGXHWWoNOqOrcWf1fK8EvL2Id
         J3Y7hkOLmuwrjtEaeQueCqu+UWImaUoGgOd5uGOatA6wkOqyRo6YBwMXSOoOEdIJI4Qu
         CWDd5ZXEplxNhrwWEfF+sVhaGhl4tCZsGetokAJ4td/S9qxB4oGmoQFVNSWKs2lVetZ4
         pJTw==
X-Gm-Message-State: AOAM533mJL+4pEWvC7pgWZ9WvYJw1Vgf5wA26EBVGEYxxgWSV0/jq13i
        FNQ3a3xgMTSNYprJ/M3f378=
X-Google-Smtp-Source: ABdhPJzvcuggvEyml1M3+RsxzVPi7Pas35KpvEZCKp7IeKu4I2v7wX867o9yVas3gcbYo6njttWI9w==
X-Received: by 2002:a17:906:b7d8:: with SMTP id fy24mr644516ejb.543.1620627399007;
        Sun, 09 May 2021 23:16:39 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/21] trace-cmd library: Remove unused private APIs for creating trace files
Date:   Mon, 10 May 2021 09:16:16 +0300
Message-Id: <20210510061636.1794357-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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


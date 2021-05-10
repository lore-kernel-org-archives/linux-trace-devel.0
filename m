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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02068C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA447613CD
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:17:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhEJGSE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhEJGSE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:18:04 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC36C061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:58 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id j26so13633209edf.9
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rXJhXzYqm/Tz1lc6WWXfpJFcr8KdDbgvsKgBLpz6mPo=;
        b=FbB0T3cdc1S0mA2qv1JLoS9GMkR14rczPrsaGdCgqqkEwmAZZwQJw+f7Ul/inTfFat
         8o5+PNKlKWUHdiOamCQgbW7FTKGw0AEQQ5sGyKeD7N7yyH2XvSC1HUymYoeGYjMCtob4
         G9g+7R2nXgy2mS9hRCkUxX8uhiZLGhP0wrLe0WfJL2cIgBasluajRqOqcI6CEdk34alm
         Lu9TZEfQurZZ4WxGgkbV5MwQX7Qwude+HSRY3FCvYvMwp6QUo67l3mbbQKiHVm/WJLFf
         oO1oWRBVtuoYQIcMyhLV78F6HGev/W8FNdLsOY4c6Y3UsBJ0NXIMvhok3z3OrxFmOFBs
         z8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rXJhXzYqm/Tz1lc6WWXfpJFcr8KdDbgvsKgBLpz6mPo=;
        b=M4FB+tAcbXkhpapqIkenEZP6Z76KeZ9o722J5ovthACBr02mfhYjFhgZRqRqwwLM8d
         TpdiVHG1r68rflDOxKqRaYpMZGXvU28gcukr3MqHVGxrpsgBK/90pthUKWATwI6saNVX
         d6zHe6ZFFUoko0Pf53FE0QW9Z0WudMyaZH/eisL3NluE8bHmE5TgKEbs0YoPD7VIVkwD
         FdtHlFRUzmzjV0KjCR2vYqsxyWuM4O6CcDuGmJeOpbyFxEGqqUkdBNqBdkKbWhmvo+sY
         nCN0TZo6SSHtQF1S/Kph0sLu9JgTJgCgU51gMsbesttcMs8sSm+Puw5800aiJR/ebrw7
         5GMQ==
X-Gm-Message-State: AOAM530cIkTJO4qA8fj7NhUyjGp2jTrHshhiwVSDAxk2f/SttHYa8Tas
        UFhSjcAJoufNc3tYB8a2cew=
X-Google-Smtp-Source: ABdhPJzihua5sdFbGySffnpbkIoOBIcdZMps5Cv6Moc7z6LSRyqu1CDhNDBJaaI1iQZFWkh/pFgX1A==
X-Received: by 2002:a05:6402:4251:: with SMTP id g17mr26955621edb.205.1620627417570;
        Sun, 09 May 2021 23:16:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 20/21] trace-cmd library: Track the offset in the option section in the trace file
Date:   Mon, 10 May 2021 09:16:35 +0300
Message-Id: <20210510061636.1794357-21-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading / writing trace file, store the offset of the option
section in the file. A new internal API is added, to get the offset of
the option section from an input file handler:
 tracecmd_get_options_offset()

These changes are needed for compression of the option section from
the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 lib/trace-cmd/trace-input.c                       | 11 +++++++++++
 lib/trace-cmd/trace-output.c                      |  2 ++
 3 files changed, 14 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index d7488346..a9b66736 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -239,6 +239,7 @@ tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
 int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
 				     const char **name, const char **version);
+size_t tracecmd_get_options_offset(struct tracecmd_input *handle);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8ec9173b..a16c438c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -157,6 +157,7 @@ struct tracecmd_input {
 	size_t			header_files_start;
 	size_t			ftrace_files_start;
 	size_t			event_files_start;
+	size_t			options_start;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2759,6 +2760,7 @@ static int handle_options(struct tracecmd_input *handle)
 
 	/* By default, use usecs, unless told otherwise */
 	handle->flags |= TRACECMD_FL_IN_USECS;
+	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
 		if (do_read_check(handle, &option, 2))
@@ -4215,6 +4217,15 @@ bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle)
 	return handle->use_trace_clock;
 }
 
+/**
+ * tracecmd_get_options_offset - get offset of the options sections in the file
+ * @handle: input handle for the trace.dat file
+ */
+size_t tracecmd_get_options_offset(struct tracecmd_input *handle)
+{
+	return handle->options_start;
+}
+
 /**
  * tracecmd_get_show_data_func - return the show data func
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 57b11493..1bd2351f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -66,6 +66,7 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+	size_t			options_start;
 
 	bool			do_compress;
 	struct tracecmd_compression *compress;
@@ -1854,6 +1855,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_file_version(ihandle);
+	handle->options_start = tracecmd_get_options_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.31.1


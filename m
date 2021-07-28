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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B9C7C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BE2260FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhG1Ndq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236694AbhG1Ndp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:45 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2FBC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:43 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id v21so4688380ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aO8MwHzXRT0gTSrkCt7x2ynyStEgIZPbb4tHSK0fqMw=;
        b=A6P8DCuYYFR8Btl+rTxFWV5fNN0STd2wqsrN/uwqS7KC7bGjW3AYeTm4vKd8LshZXi
         AUPdky8cqbThg73xTFgB54Cx/vBFb0ABowiBPbcVy5A0Krj60/CA61TyxURQa63IpmVW
         8y/ABBzn3BGuJvUsB01Jz3mWN41mwFEMocywL9QEL/ln+idaZj8nqH6lT6TJPhlg5Pdi
         KeHJ5uoeEhw1FG8atK+SLz6CF94T7BsS3ezJpBxLhUgfKsoxIexnud3/e3YZrF7z6JWH
         l+z4CeEQHp2B59ROR1ubR5DU88PYsT5TIT532Os8yNDkvjF9InLXEn3PqyE9/vKM+oEM
         4E7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aO8MwHzXRT0gTSrkCt7x2ynyStEgIZPbb4tHSK0fqMw=;
        b=sGFgqrNbLZ9faUh4woLpaYdrhwY2v8eHmha4cZ7z26U+Z7LkuTH6j8rlchAylquaYW
         0VNaSfkOgxXicgP5zyJZVKRkoWlnpW8HwLWouZnWpnnYoU6kfZ+pyllOq8MLNqTyr4EH
         P/5mjkpbK3umH3PONOrcjiZwj3BJUxQzVufzgwKnPWYlUDMZD97TTljNmBftBtHxm46o
         4pbLX3bjm3v0Nk9lFrT3CaWk6dQnhegrSSqqexPEwLD/1rYgPhcS5SyZHiYro5XfpkJK
         r6f/1y+zVtcCTzK0LjVB8NogiZWDZEuV4DaHuVnPmBsgqCfnuUxe9HEehsHRVF2POR2U
         xFqg==
X-Gm-Message-State: AOAM533ZDHvle6vLbKgxm9WMCmvJNCYvAEUzHwHCEwJHrBuiPAtcNZra
        dzbtPOzMnHtREQObWoWy9semFn6Ls2h8NQ==
X-Google-Smtp-Source: ABdhPJxZh+HUJzrfCSeWDikXQphCvZF0ekLSykGZoYqMQXC3F1OXYLdhzjTGBCmlCzGgCFqbxURT4w==
X-Received: by 2002:a17:906:14c8:: with SMTP id y8mr21009616ejc.475.1627479221939;
        Wed, 28 Jul 2021 06:33:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 49/87] trace-cmd library: Handle the extended DONE option
Date:   Wed, 28 Jul 2021 16:32:12 +0300
Message-Id: <20210728133250.234140-50-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7 the DONE option is extended to store the offset
in the file to the next options section. This way a list of options
sections can be stored in the file. Added logic to recursively read all
option sections from the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h |  2 +-
 lib/trace-cmd/trace-input.c             | 31 +++++++++++++++++++++++++
 lib/trace-cmd/trace-output.c            |  2 +-
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 0474a81d..0291b8de 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -64,6 +64,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
-
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f23c76a3..795ed9e1 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -178,6 +178,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2916,6 +2917,30 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
 	return lib;
 }
 
+__hidden unsigned long long get_last_option_offset(struct tracecmd_input *handle)
+{
+	return handle->options_last_offset;
+}
+
+static int handle_option_done(struct tracecmd_input *handle, char *buf, int size)
+{
+	unsigned long long offset;
+
+	if (size < 8)
+		return -1;
+	offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if (offset >= size)
+		handle->options_last_offset = offset - size;
+	offset = tep_read_number(handle->pevent, buf, 8);
+	if (!offset)
+		return 0;
+
+	if (lseek64(handle->fd, offset, SEEK_SET) == (off_t)-1)
+		return -1;
+
+	return handle_options(handle);
+}
+
 #define save_read_number(R, C)							\
 	do {									\
 		if ((C) > size)							\
@@ -3160,6 +3185,12 @@ static int handle_options(struct tracecmd_input *handle)
 				break;
 			add_section(handle, option, -1, tep_read_number(handle->pevent, buf, 8), 0);
 			break;
+		case TRACECMD_OPTION_DONE:
+			if (comperss)
+				in_uncompress_reset(handle);
+			ret = handle_option_done(handle, buf, size);
+			free(buf);
+			return ret;
 		default:
 			tracecmd_warning("unknown option %d", option);
 			break;
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 0c6fcc6d..d0e9b4a6 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2409,7 +2409,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.31.1


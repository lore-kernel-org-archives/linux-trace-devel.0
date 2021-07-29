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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D004C4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79A6360FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbhG2FKy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbhG2FKx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:53 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC62C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:50 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id p21so6365861edi.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T+XzZoHWC601U8xdKHAVzheaoUYwBuWFTJ3gxmL76WY=;
        b=rPxuDicPGTAw7JsuLOzWuEZYHo4RHnty/5f+BjMAxcHjFWU9tYygu8v///8HVe5oai
         1o7sRORk1MLX8CI0TbdOMeLVZMxOoJcslR3y2ZdoNMmrwE5xn9mNJ+ajWzlQEkVcVfL3
         b+vMR8Az/GX9Jw+6J0kxJnxtNY78HvC+qo9s8zu2WyPK6bLWpJgKvxsTdXUDQ1dPk7nl
         DDjhTgvi71yHHOLC7eFgU5mMyPe9A1jrZNnpHVjDar2Rq+DGOQljYoVhBSK77rElRrzu
         aM97/0IVV3S5Gt4Wv/skXcR0SFvK0TsL9GXecuVWIRVKqBEo9XHLyDkQmuDr42iYRsWa
         8bJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T+XzZoHWC601U8xdKHAVzheaoUYwBuWFTJ3gxmL76WY=;
        b=rUy0C1GSTd2xL8RIa0xR2u75cInelJ8YZssXXdDCepvqe8jHEoitWv01+BFDroyvmh
         sXpzRFiTMakiN6lOFUYiEETan2W9xpmnLrYIIFb88fZ1TXF5kMqOxQ7iVglxoE78zyxH
         B5Qh88RLN2nJQ/lHGzWLCJTJXl/+jXh1dv/3Jt6SqkQWlYhR3Cp48Zdx+jPpmmuUJWHY
         alIdF4GWdYxNwaG5McEQndTyuxSg4C4Gw8vqXaQNfxilFVHSz9wTXi2Sk8FE7FnLDkrp
         mR0c8ZXJ31HJoIHZP0wKd8VSk0pRFX5t7JSClZ9E1c+66AbfylcNprsrpoQFj0oIyuwq
         pebA==
X-Gm-Message-State: AOAM533jpyDqGwasu852ewF9kaYpxkhB4t4TVRCAy/3/RizQGiChHI+n
        MgApmDIYMSN93tKZsXZoiz8=
X-Google-Smtp-Source: ABdhPJwDXwFu6FQCq69Y8jNKnVrqPt53PAtSyizYaOeT/IRPjk/LLPXLlymFDRJJHE9SbH57DtcuCw==
X-Received: by 2002:aa7:c74b:: with SMTP id c11mr3964320eds.353.1627535449092;
        Wed, 28 Jul 2021 22:10:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 49/87] trace-cmd library: Handle the extended DONE option
Date:   Thu, 29 Jul 2021 08:09:21 +0300
Message-Id: <20210729050959.12263-50-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/include/trace-cmd-local.h |  1 +
 lib/trace-cmd/trace-input.c             | 31 +++++++++++++++++++++++++
 lib/trace-cmd/trace-output.c            |  2 +-
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index e54ba7e1..0291b8de 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -64,5 +64,6 @@ struct cpu_data_source {
 int out_write_cpu_data(struct tracecmd_output *handle, int cpus,
 		       struct cpu_data_source *data, const char *buff_name);
 off64_t msg_lseek(struct tracecmd_msg_handle *msg_handle, off_t offset, int whence);
+unsigned long long get_last_option_offset(struct tracecmd_input *handle);
 
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 57ae535a..9ab20d64 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -178,6 +178,7 @@ struct tracecmd_input {
 	struct file_section	*sections;
 	bool			options_init;
 	unsigned long long	options_start;
+	unsigned long long	options_last_offset;
 	size_t			total_file_size;
 
 	/* For custom profilers. */
@@ -2915,6 +2916,30 @@ tracecmd_search_task_map(struct tracecmd_input *handle,
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
@@ -3159,6 +3184,12 @@ static int handle_options(struct tracecmd_input *handle)
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
index 87bbcf39..01c1a4f5 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2413,7 +2413,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
-	handle->options_start = tracecmd_get_options_offset(ihandle);
+	handle->options_start = get_last_option_offset(ihandle);
 	list_head_init(&handle->options);
 	list_head_init(&handle->buffers);
 
-- 
2.31.1


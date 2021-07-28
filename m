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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8410EC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FEA560EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236209AbhG1NeU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbhG1NeU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:34:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA811C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:17 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id v21so4691448ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sW7c+fGeJsfDrhFqR/7e9cZ/zdYuZVy10oegAQYI2vg=;
        b=Q6sxOtb/ZmOW9pD1nCuKnNAPjMDUBRTqmGRLx90eN4N4yLd5GIEfHL9uhXSTbS4o9k
         csAmsqnjJbyCOmm3yPwRcjNC3JrmOgqBPOBUzBagC6kMnxCEhm1ZPAHPKF2se2j0r61J
         1GVC32Pp3F3MigYgyKK01d8AvT0lxxbHtX6ifQfjcEg8tp9x7NbV2WK7mfvlK7CAzDyL
         kRj0/y732RJ1VbtB4GVbnuxTPEMzvNWgIiXpMIYLb1HytjezJjtoRH1uxxcxG8Ul188z
         JmsSMPNyUtVeQXRY+DHiqnRCdzSuuDe81xGzBqCi6Aad+YmStyW60hkt2uE/n8XaP6GW
         berQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sW7c+fGeJsfDrhFqR/7e9cZ/zdYuZVy10oegAQYI2vg=;
        b=qdGScll+X2DKWm+8gtKCImp3pXRxnVazO7haNImShmHpxr9paAqjHNfrr7GHhKv9Tm
         CaC7UrFv7I/ryCpWyRSklK3HMSxiUGie50mjvHCgIgS4oozvzhLiXggbr4oVWiSZ7qHB
         Kuy8ZhTFdGdOe1/+MHvdSIAfIbX96VgwnXpf+pKrcHOljuEFmwrvTOdSNGbDZwwbbSRO
         L9HdArn2NGhcWetBPVHhuCX+tETlUoAPO8EB0Kmm2g/+1zqTvP2yff93QSExnY24YKj7
         2H8U3UrgHRcyMNQ+IVMJ3gxCf0OQpvn6UStnnGMIosgUtmS3pcCJ6ueMFjxr+kcRb2HB
         ggUQ==
X-Gm-Message-State: AOAM5301AMRI0luYkjtVOhfyrPo148+kc1OTBrXKQKNZj8Cjn+2PoJBZ
        DE+a4bAtO5q5oef2PUwwjwVXcSIwcSG9Nw==
X-Google-Smtp-Source: ABdhPJx6qgYdzzhnyFwsu9ZBU1hJ26EqFA3+v4/I0JsXz6QscM9uCChDgYmV1bccOHZE/QBwd96HWg==
X-Received: by 2002:a17:906:c0d1:: with SMTP id bn17mr17060766ejb.511.1627479256434;
        Wed, 28 Jul 2021 06:34:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.34.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:34:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 78/87] tarce-cmd library: New API to copy options between trace files
Date:   Wed, 28 Jul 2021 16:32:41 +0300
Message-Id: <20210728133250.234140-79-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new library API is introduced, to copy options between trace files:
	tracecmd_copy_options()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |   3 +
 lib/trace-cmd/include/trace-cmd-local.h       |   2 +
 lib/trace-cmd/trace-input.c                   | 140 ++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  28 ++++
 4 files changed, 173 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 58c17fe5..8b730d1a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -185,6 +185,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  enum tracecmd_file_states end_state);
 int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
+int tracecmd_copy_options(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
@@ -331,6 +333,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
+unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 60520b07..eb9d6de4 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -52,6 +52,8 @@ void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
 void out_set_file_state(struct tracecmd_output *handle, int new_state);
+int out_save_options_offset(struct tracecmd_output *handle,
+			    unsigned long long start);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5345e327..0bf13e42 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4859,6 +4859,146 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 	return tracecmd_write_buffer_info(out_handle);
 }
 
+static int copy_options_recursive(struct tracecmd_input *in_handle,
+				  struct tracecmd_output *out_handle)
+{
+	unsigned short id, flags = 0;
+	unsigned short option, en2;
+	unsigned long long next;
+	unsigned int size, en4;
+	bool skip;
+
+	for (;;) {
+		if (do_read_check(in_handle, &option, 2))
+			return -1;
+		en2 = tep_read_number(in_handle->pevent, &option, 2);
+
+		if (en2 == TRACECMD_OPTION_DONE) {
+			if (in_handle->file_version < 7)
+				return 0;
+		}
+		/* next 4 bytes is the size of the option */
+		if (do_read_check(in_handle, &size, 4))
+			return -1;
+		en4 = tep_read_number(in_handle->pevent, &size, 4);
+		if (en2 == TRACECMD_OPTION_DONE) {
+			/* option done v7 */
+			if (en4 < 8)
+				return -1;
+			if (read8(in_handle, &next))
+				return -1;
+			if (!next)
+				break;
+			if (do_lseek(in_handle, next, SEEK_SET) == (off64_t)-1)
+				return -1;
+			if (read_section_header(in_handle, &id, &flags, NULL, NULL))
+				return -1;
+			if (id != TRACECMD_OPTION_DONE)
+				return -1;
+			if (flags & TRACECMD_SEC_FL_COMPRESS && in_uncompress_block(in_handle))
+				return -1;
+			return copy_options_recursive(in_handle, out_handle);
+		}
+		/* Do not copy these, as they have file specific offsets */
+		switch (en2) {
+		case TRACECMD_OPTION_BUFFER:
+		case TRACECMD_OPTION_BUFFER_LAT:
+		case TRACECMD_OPTION_HEADER_INFO:
+		case TRACECMD_OPTION_FTRACE_EVENTS:
+		case TRACECMD_OPTION_EVENT_FORMATS:
+		case TRACECMD_OPTION_KALLSYMS:
+		case TRACECMD_OPTION_PRINTK:
+		case TRACECMD_OPTION_CMDLINES:
+			skip = true;
+			break;
+		default:
+			skip = false;
+			break;
+		}
+		if (skip) {
+			do_lseek(in_handle, en4, SEEK_CUR);
+			continue;
+		}
+		if (do_write_check(out_handle, &option, 2))
+			return -1;
+		if (do_write_check(out_handle, &size, 4))
+			return -1;
+		if (read_copy_data(in_handle, en4, out_handle))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int copy_options(struct tracecmd_input *in_handle, struct tracecmd_output *out_handle)
+{
+	unsigned long long offset, start;
+	unsigned short id, en2, flags = 0;
+	int tmp;
+
+	if (in_handle->file_version >= 7) {
+		if (read_section_header(in_handle, &id, &flags, NULL, NULL))
+			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS && in_uncompress_block(in_handle))
+			return -1;
+	}
+	start = tracecmd_get_out_file_offset(out_handle);
+	if (tracecmd_get_out_file_version(out_handle) < 7) {
+		if (do_write_check(out_handle, "options  ", 10))
+			return -1;
+	}
+
+	offset = out_write_section_header(out_handle, TRACECMD_OPTION_DONE, "options", 0, false);
+
+	if (copy_options_recursive(in_handle, out_handle))
+		goto error;
+
+	id = TRACECMD_OPTION_DONE;
+	en2 = tep_read_number(in_handle->pevent, &id, 2);
+	if (do_write_check(out_handle, &en2, 2))
+		goto error;
+	if (tracecmd_get_out_file_version(out_handle) < 7) {
+		out_save_options_offset(out_handle, start);
+	} else {
+		tmp = 8;
+		if (do_write_check(out_handle, &tmp, 4))
+			goto error;
+		out_save_options_offset(out_handle, start);
+		start = 0;
+		if (do_write_check(out_handle, &start, 8))
+			goto error;
+	}
+	out_update_section_header(out_handle, offset);
+	if (flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(in_handle);
+	in_handle->file_state = TRACECMD_FILE_OPTIONS;
+	out_set_file_state(out_handle, in_handle->file_state);
+	/* Append local options */
+	return tracecmd_append_options(out_handle);
+
+error:
+	if (flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(in_handle);
+	return 0;
+}
+
+int tracecmd_copy_options(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle)
+{
+	if (!check_out_state(out_handle, TRACECMD_FILE_OPTIONS))
+		return -1;
+
+	if (!in_handle->options_start)
+		return 0;
+	if (lseek64(in_handle->fd, in_handle->options_start, SEEK_SET) == (off64_t)-1)
+		return -1;
+	if (copy_options(in_handle, out_handle) < 0)
+		return -1;
+	return 0;
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 835f8ac5..f45ff25b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2513,6 +2513,30 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
+__hidden int out_save_options_offset(struct tracecmd_output *handle, unsigned long long start)
+{
+	unsigned long long new, en8;
+
+	if (handle->file_version < 7) {
+		handle->options_start = start;
+	} else {
+		/* Append to the previous options section, if any */
+		if (!handle->options_start)
+			return -1;
+		new = do_lseek(handle, 0, SEEK_CUR);
+		if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
+			return -1;
+
+		en8 = convert_endian_8(handle, start);
+		if (do_write_check(handle, &en8, 8))
+			return -1;
+		handle->options_start = new;
+		if (do_lseek(handle, new, SEEK_SET) == (off64_t)-1)
+			return -1;
+	}
+	return 0;
+}
+
 /**
  * tracecmd_get_out_file_version - return the trace.dat file version
  * @handle: output handle for the trace.dat file
@@ -2522,3 +2546,7 @@ unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
 	return handle->file_version;
 }
 
+unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle)
+{
+	return do_lseek(handle, 0, SEEK_CUR);
+}
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A5C0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:03:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbhLJLGf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240201AbhLJLGf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:06:35 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC15C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:00 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id o20so29032150eds.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:03:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7rqYF6aHQKCvS6x4RVbvZdQcMLi15kRixrY/ZelD0qs=;
        b=PmEZNVWCQD13PB1hckAxXARGB81MpxL6iRf+vAV3024+/ZYXgJspcF+gOzotjACyEy
         UP5hZ3zym9KleU/CJ9MSaQ0cQLvnZMkfEfHiFqNSHR18I1Rs4dm8YJAbhM7sUmviqN0w
         rwcnUL9roRTAw0oCNnh6GBfuGcVu/3XBiu7toK3zxaiPbAcXliU4cVkVDTexnVQq97cN
         PgwHZAV2W8CjmLpjBIMY97JEqhMUueHwoumzRZZKUtNDLq8D0iraD5FqT+t7XwMIOu5n
         bIcI6/fGhh1VIctnp/p+ZfgIaN3H0ehXQFN75xoDlAR9tnnnbuYpbveW6J2jG4tWRBHv
         DKQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7rqYF6aHQKCvS6x4RVbvZdQcMLi15kRixrY/ZelD0qs=;
        b=yhwn2ho8OUybtVSvGFEd8sr+XRSGxmso8eXcWsW8pc2TPbMZShEXnhSbRtL/bp33Mo
         7N/YT+Gn5puItENuPxmjUtep9v1z0cupzaYgj3rGCKdLXvx7h7pk90u+jARee7CxpJRG
         dRn75BmFeQof9CukPC/BksWdMZz0C2gHhPLzi1zA9K04d7JRS2A5E1zb86pm0VNyl0qO
         UeKOyGnp2OxVpZ26a2Ijq71zjGbjyi8tNCYW9Ffgy9cffeHyXVidevnxK60FG6GhM6wt
         h7DEM/hwvZa8LiW0x8LTvNm06at3+OSHs3r2YecY/RmUWgcj9Cy6GVJiB3zP1UrY8C4F
         aHkQ==
X-Gm-Message-State: AOAM533oLrJmxAorf2zPnCm8uLlcN1IqSF1hQ2XAS0IACrlsb66STpZs
        Ocj+kmBtVyiJ11m4AZbgaWdNLWaDq3c=
X-Google-Smtp-Source: ABdhPJyuS+XIuyfTSCc4Mk/6sPcXaLsU22cdCXB7kkfNR/bxRm8+akyvnMOwyh7lUwY/+VIxywld3A==
X-Received: by 2002:a17:907:96a9:: with SMTP id hd41mr23607032ejc.413.1639134178687;
        Fri, 10 Dec 2021 03:02:58 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id sg39sm1275269ejc.66.2021.12.10.03.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:02:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 5/9] trace-cmd library: New API to copy options between trace files
Date:   Fri, 10 Dec 2021 13:02:45 +0200
Message-Id: <20211210110249.98583-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110249.98583-1-tz.stoyanov@gmail.com>
References: <20211210110249.98583-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c                  |  30 ++++
 4 files changed, 175 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index cde33553..9012ebd9 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -192,6 +192,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  enum tracecmd_file_states end_state);
 int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
+int tracecmd_copy_options(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
@@ -337,6 +339,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    const char *name, int cpus, char * const *cpu_data_files);
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
 unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
+unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 4154e76e..85420fb1 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -53,6 +53,8 @@ void out_compression_reset(struct tracecmd_output *handle, bool compress);
 bool out_check_compression(struct tracecmd_output *handle);
 
 void out_set_file_state(struct tracecmd_output *handle, int new_state);
+int out_save_options_offset(struct tracecmd_output *handle,
+			    unsigned long long start);
 unsigned long long out_copy_fd_compress(struct tracecmd_output *handle,
 					int fd, unsigned long long max,
 					unsigned long long *write_size);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 61a3a4b9..ae3eea3d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4970,6 +4970,146 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
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
+		if (en2 == TRACECMD_OPTION_DONE && !HAS_SECTIONS(in_handle))
+			return 0;
+
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
+		case TRACECMD_OPTION_BUFFER_TEXT:
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
+	if (HAS_SECTIONS(in_handle)) {
+		if (read_section_header(in_handle, &id, &flags, NULL, NULL))
+			return -1;
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS && in_uncompress_block(in_handle))
+			return -1;
+	}
+	start = tracecmd_get_out_file_offset(out_handle);
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
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
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
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
+	if (!check_in_state(in_handle, TRACECMD_FILE_OPTIONS) ||
+	    !check_out_state(out_handle, TRACECMD_FILE_OPTIONS))
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
index be747c61..464ab693 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2605,6 +2605,31 @@ __hidden bool out_check_compression(struct tracecmd_output *handle)
 	return (handle->compress != NULL);
 }
 
+__hidden int out_save_options_offset(struct tracecmd_output *handle, unsigned long long start)
+{
+	unsigned long long new, en8;
+
+	if (HAS_SECTIONS(handle)) {
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
+	} else {
+		handle->options_start = start;
+	}
+
+	return 0;
+}
+
 /**
  * tracecmd_get_out_file_version - return the trace.dat file version
  * @handle: output handle for the trace.dat file
@@ -2613,3 +2638,8 @@ unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
 {
 	return handle->file_version;
 }
+
+unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle)
+{
+	return do_lseek(handle, 0, SEEK_CUR);
+}
-- 
2.33.1


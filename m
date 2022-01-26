Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700A9C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiAZJwH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiAZJwG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:52:06 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F011CC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:05 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id p7so2708516edc.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/WVeK5dUptswPcuIyqXNbzB0yKJX8gcjkxbih/4K/ls=;
        b=H9yq1TZkb2SdhvXx06fiEUlwDGPNkCN8FRwMpHXzU5UR/X+HStSdN8usoz/VnRItod
         GymI+efEd6VBOjzqtr/20CAKaTWFAiT93PJ4zCNrjJUPfTGIWw9e1slZxKludS9YahwZ
         UxNc+Iw6rU2maXdKgCJzcNLudu3CzudNnoy4Eazwf4H+JcYjBuN3UU5pM3an4YAAWtYp
         kLHr7PlzbsMM/3UfOGNAUJullaM/DMUYDHxdAzv5/sKclQujAKAEMyClWSV8J+cOc9LP
         0k7z1KKA6DaIJwgTBPbpLcbnTFA6oTIauS6OKJx7MpnFMqqqD5FYSNZ3aol0fYO9/HUH
         oKuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/WVeK5dUptswPcuIyqXNbzB0yKJX8gcjkxbih/4K/ls=;
        b=afv0Y12MQUIrONIssS/9HOBTjLkmDaCyZEevOfyFWLWuBFybGBihXx318y1z+z4/IG
         UpFIxxSDXmFAqVsYPNFIKZIZH4PitpfoWqTB8gzmEI7z1/6H12oHNG9crIb2FVqTMmKQ
         4cch78/+1AvaUKpQ/CPw4AdX6nhKJ9k/7zr/L7wSwhx65aSuZ8PKidBliKup5Chz/Wdf
         fz1MADYHIGJA4y6Knf9/liNBXntJ2z9WQgE4PztG4gq4C38DsB5MnFhbh7ALhvW5TAxy
         NIaZdKqmnc29OhXGjiQKYrJl6aJO5GZeQUjWnINy1AIqaaQPvd72bdzAE2450SYYkiSA
         Ac8Q==
X-Gm-Message-State: AOAM532PeU4swEzgr78IOy1mKMJqFbYocmYqfsqzym0NW9BnVV14kG8c
        4VTA4cjc8xqEmUdp1e8xorrEr8yWLxo=
X-Google-Smtp-Source: ABdhPJxxQ1eF2eK/K6Y2lmleGGRqorkaPtplGmnF1bpHLrF0NL93qlQNqUTPbyJEtZGIvaHtBuujvA==
X-Received: by 2002:a50:ec09:: with SMTP id g9mr23949082edr.198.1643190724562;
        Wed, 26 Jan 2022 01:52:04 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id v15sm9529823edq.35.2022.01.26.01.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:52:04 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 5/9] trace-cmd library: New API to copy options between trace files
Date:   Wed, 26 Jan 2022 11:51:50 +0200
Message-Id: <20220126095154.570700-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095154.570700-1-tz.stoyanov@gmail.com>
References: <20220126095154.570700-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c                   | 158 ++++++++++++++++++
 lib/trace-cmd/trace-output.c                  |  32 ++++
 4 files changed, 195 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 07430d37..98b1864e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -197,6 +197,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  enum tracecmd_file_states end_state);
 int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
 			       struct tracecmd_output *out_handle);
+int tracecmd_copy_options(struct tracecmd_input *in_handle,
+			  struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
@@ -342,6 +344,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
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
index 5f2b9d85..2af3ecc0 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5023,6 +5023,164 @@ int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
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
+
+		en2 = tep_read_number(in_handle->pevent, &option, 2);
+
+		if (en2 == TRACECMD_OPTION_DONE && !HAS_SECTIONS(in_handle))
+			return 0;
+
+		/* next 4 bytes is the size of the option */
+		if (do_read_check(in_handle, &size, 4))
+			return -1;
+
+		en4 = tep_read_number(in_handle->pevent, &size, 4);
+		if (en2 == TRACECMD_OPTION_DONE) {
+			/* option done v7 */
+			if (en4 < 8)
+				return -1;
+
+			if (read8(in_handle, &next))
+				return -1;
+
+			if (!next)
+				break;
+
+			if (do_lseek(in_handle, next, SEEK_SET) == (off64_t)-1)
+				return -1;
+
+			if (read_section_header(in_handle, &id, &flags, NULL, NULL))
+				return -1;
+
+			if (id != TRACECMD_OPTION_DONE)
+				return -1;
+
+			if (flags & TRACECMD_SEC_FL_COMPRESS && in_uncompress_block(in_handle))
+				return -1;
+
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
+
+		if (do_write_check(out_handle, &size, 4))
+			return -1;
+
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
+
+		if (id != TRACECMD_OPTION_DONE)
+			return -1;
+
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
+
+	if (tracecmd_get_out_file_version(out_handle) < FILE_VERSION_SECTIONS) {
+		out_save_options_offset(out_handle, start);
+	} else {
+		tmp = 8;
+		if (do_write_check(out_handle, &tmp, 4))
+			goto error;
+
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
+
+	if (lseek64(in_handle->fd, in_handle->options_start, SEEK_SET) == (off64_t)-1)
+		return -1;
+
+	if (copy_options(in_handle, out_handle) < 0)
+		return -1;
+
+	return 0;
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 164c66a8..a8c4d7d9 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2646,6 +2646,33 @@ __hidden bool out_check_compression(struct tracecmd_output *handle)
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
+
+		new = do_lseek(handle, 0, SEEK_CUR);
+		if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
+			return -1;
+
+		en8 = convert_endian_8(handle, start);
+		if (do_write_check(handle, &en8, 8))
+			return -1;
+
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
@@ -2654,3 +2681,8 @@ unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
 {
 	return handle->file_version;
 }
+
+unsigned long long tracecmd_get_out_file_offset(struct tracecmd_output *handle)
+{
+	return do_lseek(handle, 0, SEEK_CUR);
+}
-- 
2.34.1


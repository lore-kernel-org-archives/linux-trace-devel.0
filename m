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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0818FC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4F18611C2
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 04:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDHE27 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 00:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhDHE26 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 00:28:58 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32682C061760
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 21:28:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id y124-20020a1c32820000b029010c93864955so2173847wmy.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Apr 2021 21:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDNDnOsKjEtO5AN8JCv1B3wIszTCSTd68fryt1dorH4=;
        b=YAsOTHJuwUR/JKvqKjSomqxZAupqj8Aqsg3diN3HE056BWVDzj+jq63LA5h3jOObkF
         5ZsPedYiNEqZu3BksuzhBPk4ozwo1j5ghVW+MK/9u2I3cEfOwOEYrqpVBbseuJna2NsR
         Oti8a2BxIFR0Vq+sTG0pqcereP00vyHBKqylK2ygq5VpOXvGYywq9N8lxE6O21Fv78FQ
         8QTQuAnVrFbmF8b7hjMHYAC8h0nDG67MzFgTtNWWMfyvnQQGMQI65obWIHEnj1PTb6O6
         OMgWZjwf11+ymGaZcFo3C06kB4b9O5LO2XFAgRVRKwR3SRBDsvdDXYgn0eR0RgYmn7FK
         G+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDNDnOsKjEtO5AN8JCv1B3wIszTCSTd68fryt1dorH4=;
        b=r4R5OA3MXGDvdzDaXtamnKIv2cQjB249E8dRwWSoNfDEZyPiKocFSn7F26+rdMg+ZR
         gWROMkXId5mPtGGnk/Cwlps8c3438gelBRDQ4uBbsh5iMreagHh+n8RNSbmQ0+pUyLiw
         jMA5c3+RSQ5agllWipfaXQRbSYmpUzTKHiIEsgX95uw6nlsVg7U+U0fwrc77azRgGeuD
         ZrVZSO1PAB5TpIynQoF/Hg7ppeECV0H4gqJZu8VBoTnTKDg52fkQu5BMQrGRrjERiDj/
         xLWzvrv504VJ7AmRNrQrxgGKWtQrzl7O5YQUI0dDk6Ph/rK8lUSlgsy1jzUYUaE6R2w2
         lJ5w==
X-Gm-Message-State: AOAM530gs7lAk07X088ankqwFMN8Yf1Aruyy6UzgOkkDUVpbgbHZbVa/
        tfX+Q7+hhxC562eQvNheidHboup+ysQvJg==
X-Google-Smtp-Source: ABdhPJyLftkkoq0YnAypn79A+iqvYBoSEeAbGmNa+dHqPIo5TpeX4XWR4rM/MaqYmsC/WVw21psznQ==
X-Received: by 2002:a05:600c:414d:: with SMTP id h13mr6129220wmm.170.1617856124761;
        Wed, 07 Apr 2021 21:28:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z15sm13476373wrw.38.2021.04.07.21.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 21:28:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] trace-cmd: Implement warning() in the library
Date:   Thu,  8 Apr 2021 07:28:43 +0300
Message-Id: <20210408042843.3112349-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The warning() function is used in a lot of places in the trace-cmd
library, but there is no implementation. The function is implemented in
the trace-cmd application. There is also a weak implementation in
traceevent library, which is specific to that library.
Implemented a new tracecmd_lib_warning(), specific to the trace-cmd
library and replaced all warning() calls with the new function in the
library. The new function is implemented as weak, so it can be
overridden by the application.
The tracecm_lib_warning() uses tep_vwarning() from libtraceevent for
printing the warning, which is also a weak function and can be
overridden by the application.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Depends on "[PATCH v2] libtraceevent: Add tep_warning()"
 https://lore.kernel.org/linux-trace-devel/20210408042623.3112002-1-tz.stoyanov@gmail.com/

 v3 changes:
  - Use tep_vwarning() for printing the warning message.

 lib/trace-cmd/include/trace-cmd-local.h |  2 +-
 lib/trace-cmd/trace-hooks.c             |  5 +-
 lib/trace-cmd/trace-input.c             | 38 +++++-----
 lib/trace-cmd/trace-msg.c               | 14 ++--
 lib/trace-cmd/trace-output.c            | 94 ++++++++++++-------------
 lib/trace-cmd/trace-plugin.c            | 15 ++--
 lib/trace-cmd/trace-recorder.c          |  9 +--
 lib/trace-cmd/trace-timesync.c          |  3 +-
 lib/trace-cmd/trace-util.c              | 26 +++----
 python/ctracecmd.i                      |  2 +-
 tracecmd/include/trace-local.h          |  2 +
 11 files changed, 106 insertions(+), 104 deletions(-)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 376aff11..ce6aba0b 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -10,7 +10,7 @@
 #include "trace-cmd-private.h"
 
 /* Can be overridden */
-void warning(const char *fmt, ...);
+void tracecmd_lib_warning(const char *fmt, ...);
 void tracecmd_lib_fatal(const char *fmt, ...);
 
 /* trace.dat file format version */
diff --git a/lib/trace-cmd/trace-hooks.c b/lib/trace-cmd/trace-hooks.c
index 2dadf616..b11875e4 100644
--- a/lib/trace-cmd/trace-hooks.c
+++ b/lib/trace-cmd/trace-hooks.c
@@ -9,6 +9,7 @@
 #include <ctype.h>
 
 #include "trace-cmd-private.h"
+#include "trace-cmd-local.h"
 #include "event-utils.h"
 
 struct hook_list *tracecmd_create_event_hook(const char *arg)
@@ -132,7 +133,7 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
 				hook->stack = 1;
 				break;
 			default:
-				warning("unknown flag %c\n", flags[i]);
+				tracecmd_lib_warning("unknown flag %c\n", flags[i]);
 			}
 		}
 	}
@@ -149,7 +150,7 @@ struct hook_list *tracecmd_create_event_hook(const char *arg)
 	return hook;
 
 invalid_tok:
-	warning("Invalid hook format '%s'", arg);
+	tracecmd_lib_warning("Invalid hook format '%s'", arg);
 	return NULL;
 }
 
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 7b25e92c..7156bf7c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -430,7 +430,7 @@ static int regex_event_buf(const char *file, int size, regex_t *epreg)
 
 	buf = malloc(size + 1);
 	if (!buf) {
-		warning("Insufficient memory");
+		tracecmd_lib_warning("Insufficient memory");
 		return 0;
 	}
 
@@ -440,7 +440,7 @@ static int regex_event_buf(const char *file, int size, regex_t *epreg)
 	/* get the name from the first line */
 	line = strtok(buf, "\n");
 	if (!line) {
-		warning("No newline found in '%s'", buf);
+		tracecmd_lib_warning("No newline found in '%s'", buf);
 		return 0;
 	}
 	/* skip name if it is there */
@@ -543,13 +543,13 @@ static int make_preg_files(const char *regex, regex_t *system,
 
 	ret = regcomp(system, sstr, REG_ICASE|REG_NOSUB);
 	if (ret) {
-		warning("Bad regular expression '%s'", sstr);
+		tracecmd_lib_warning("Bad regular expression '%s'", sstr);
 		goto out;
 	}
 
 	ret = regcomp(event, estr, REG_ICASE|REG_NOSUB);
 	if (ret) {
-		warning("Bad regular expression '%s'", estr);
+		tracecmd_lib_warning("Bad regular expression '%s'", estr);
 		goto out;
 	}
 
@@ -1340,14 +1340,14 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 
 	/* FIXME: handle header page */
 	if (tep_get_header_timestamp_size(pevent) != 8) {
-		warning("expected a long long type for timestamp");
+		tracecmd_lib_warning("expected a long long type for timestamp");
 		return -1;
 	}
 
 	kbuffer_load_subbuffer(kbuf, ptr);
 	if (kbuffer_subbuffer_size(kbuf) > handle->page_size) {
-		warning("bad page read, with size of %d",
-		    kbuffer_subbuffer_size(kbuf));
+		tracecmd_lib_warning("bad page read, with size of %d",
+				     kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
 	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
@@ -2782,7 +2782,7 @@ static int handle_options(struct tracecmd_input *handle)
 								  buf + 8, 8);
 			break;
 		default:
-			warning("unknown option %d", option);
+			tracecmd_lib_warning("unknown option %d", option);
 			break;
 		}
 
@@ -2925,7 +2925,7 @@ static int read_cpu_data(struct tracecmd_input *handle)
 		read8(handle, &ignore); /* size */
 		if (ignore != 0) {
 			if (!once) {
-				warning("ignored CPU data not zero size");
+				tracecmd_lib_warning("ignored CPU data not zero size");
 				once++;
 			}
 		}
@@ -3057,7 +3057,7 @@ int tracecmd_init_data(struct tracecmd_input *handle)
 		 */
 		if (read_and_parse_trace_clock(handle, pevent) < 0) {
 			char clock[] = "[local]";
-			warning("File has trace_clock bug, using local clock");
+			tracecmd_lib_warning("File has trace_clock bug, using local clock");
 			tracecmd_parse_trace_clock(handle, clock, 8);
 		}
 	}
@@ -3455,7 +3455,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 		return;
 
 	if (handle->ref <= 0) {
-		warning("tracecmd: bad ref count on handle\n");
+		tracecmd_lib_warning("tracecmd: bad ref count on handle\n");
 		return;
 	}
 
@@ -3472,10 +3472,10 @@ void tracecmd_close(struct tracecmd_input *handle)
 				free_page_map(handle->cpu_data[cpu].page_map);
 
 			if (handle->cpu_data[cpu].page_cnt)
-				warning("%d pages still allocated on cpu %d%s",
-					handle->cpu_data[cpu].page_cnt,
-					cpu, show_records(handle->cpu_data[cpu].pages,
-							  handle->cpu_data[cpu].nr_pages));
+				tracecmd_lib_warning("%d pages still allocated on cpu %d%s",
+						     handle->cpu_data[cpu].page_cnt,
+						     cpu, show_records(handle->cpu_data[cpu].pages,
+								       handle->cpu_data[cpu].nr_pages));
 			free(handle->cpu_data[cpu].pages);
 		}
 	}
@@ -3953,8 +3953,8 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 
 	ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
 	if (ret < 0) {
-		warning("could not seek to buffer %s offset %ld\n",
-			buffer->name, buffer->offset);
+		tracecmd_lib_warning("could not seek to buffer %s offset %ld\n",
+				     buffer->name, buffer->offset);
 		goto error;
 	}
 
@@ -3967,13 +3967,13 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	if (!ret)
 		ret = read_cpu_data(new_handle);
 	if (ret < 0) {
-		warning("failed to read sub buffer %s\n", buffer->name);
+		tracecmd_lib_warning("failed to read sub buffer %s\n", buffer->name);
 		goto error;
 	}
 
 	ret = lseek64(handle->fd, offset, SEEK_SET);
 	if (ret < 0) {
-		warning("could not seek to back to offset %ld\n", offset);
+		tracecmd_lib_warning("could not seek to back to offset %ld\n", offset);
 		goto error;
 	}
 
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index bd8b4843..597b0c11 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -408,8 +408,8 @@ void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle)
 
 static void error_operation(struct tracecmd_msg *msg)
 {
-	warning("Message: cmd=%d size=%d\n",
-		ntohl(msg->hdr.cmd), ntohl(msg->hdr.size));
+	tracecmd_lib_warning("Message: cmd=%d size=%d\n",
+			     ntohl(msg->hdr.cmd), ntohl(msg->hdr.size));
 }
 
 /*
@@ -439,7 +439,7 @@ static int tracecmd_msg_wait_for_msg(int fd, struct tracecmd_msg *msg)
 	ret = tracecmd_msg_recv_wait(fd, msg);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
-			warning("Connection timed out\n");
+			tracecmd_lib_warning("Connection timed out\n");
 		return ret;
 	}
 
@@ -590,7 +590,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 	if (ret < 0) {
 		if (ret == -ETIMEDOUT)
-			warning("Connection timed out\n");
+			tracecmd_lib_warning("Connection timed out\n");
 		return ret;
 	}
 
@@ -754,9 +754,9 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 		ret = tracecmd_msg_recv_wait(msg_handle->fd, &msg);
 		if (ret < 0) {
 			if (ret == -ETIMEDOUT)
-				warning("Connection timed out\n");
+				tracecmd_lib_warning("Connection timed out\n");
 			else
-				warning("reading client");
+				tracecmd_lib_warning("reading client");
 			return ret;
 		}
 
@@ -779,7 +779,7 @@ int tracecmd_msg_read_data(struct tracecmd_msg_handle *msg_handle, int ofd)
 			if (s < 0) {
 				if (errno == EINTR)
 					continue;
-				warning("writing to file");
+				tracecmd_lib_warning("writing to file");
 				ret = -errno;
 				goto error;
 			}
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ea6d1ba3..5fb6f38f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -197,7 +197,7 @@ static unsigned long get_size(const char *file)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		warning("Can't read '%s'", file);
+		tracecmd_lib_warning("Can't read '%s'", file);
 		return 0; /* Caller will fail with zero */
 	}
 	size = get_size_fd(fd);
@@ -232,7 +232,7 @@ static tsize_t copy_file(struct tracecmd_output *handle,
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		warning("Can't read '%s'", file);
+		tracecmd_lib_warning("Can't read '%s'", file);
 		return 0;
 	}
 	size = copy_file_fd(handle, fd);
@@ -293,7 +293,7 @@ int tracecmd_ftrace_enable(int set)
 
 	fd = open(path, O_WRONLY);
 	if (fd < 0) {
-		warning("Can't %s ftrace", set ? "enable" : "disable");
+		tracecmd_lib_warning("Can't %s ftrace", set ? "enable" : "disable");
 		return EIO;
 	}
 
@@ -340,8 +340,8 @@ static int read_header_files(struct tracecmd_output *handle)
 	int ret;
 
 	if (check_out_state(handle, TRACECMD_FILE_HEADERS) < 0) {
-		warning("Cannot read header files, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot read header files, unexpected state 0x%X",
+				     handle->file_state);
 		return -1;
 	}
 
@@ -367,7 +367,7 @@ static int read_header_files(struct tracecmd_output *handle)
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
-		warning("can't read '%s'", path);
+		tracecmd_lib_warning("can't read '%s'", path);
 		return -1;
 	}
 
@@ -382,8 +382,8 @@ static int read_header_files(struct tracecmd_output *handle)
 	check_size = copy_file_fd(handle, fd);
 	close(fd);
 	if (size != check_size) {
-		warning("wrong size for '%s' size=%lld read=%lld",
-			path, size, check_size);
+		tracecmd_lib_warning("wrong size for '%s' size=%lld read=%lld",
+				     path, size, check_size);
 		errno = EINVAL;
 		return -1;
 	}
@@ -395,7 +395,7 @@ static int read_header_files(struct tracecmd_output *handle)
 
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
-		warning("can't read '%s'", path);
+		tracecmd_lib_warning("can't read '%s'", path);
 		return -1;
 	}
 
@@ -409,7 +409,7 @@ static int read_header_files(struct tracecmd_output *handle)
 	check_size = copy_file_fd(handle, fd);
 	close(fd);
 	if (size != check_size) {
-		warning("wrong size for '%s'", path);
+		tracecmd_lib_warning("wrong size for '%s'", path);
 		return -1;
 	}
 	put_tracing_file(path);
@@ -453,7 +453,7 @@ static int copy_event_system(struct tracecmd_output *handle,
 				return -1;
 			check_size = copy_file(handle, format);
 			if (size != check_size) {
-				warning("error in size of file '%s'", format);
+				tracecmd_lib_warning("error in size of file '%s'", format);
 				return -1;
 			}
 		}
@@ -509,7 +509,7 @@ static void add_list_event_system(struct list_event_system **systems,
 	}
 	return;
  err_mem:
-	warning("Insufficient memory");
+	tracecmd_lib_warning("Insufficient memory");
 }
 
 static void free_list_events(struct list_event_system *list)
@@ -643,7 +643,7 @@ create_event_list_item(struct tracecmd_output *handle,
 	free(str);
 	return;
  err_mem:
-	warning("Insufficient memory");
+	tracecmd_lib_warning("Insufficient memory");
 }
 
 static int read_ftrace_files(struct tracecmd_output *handle)
@@ -653,8 +653,8 @@ static int read_ftrace_files(struct tracecmd_output *handle)
 	int ret;
 
 	if (check_out_state(handle, TRACECMD_FILE_FTRACE_EVENTS) < 0) {
-		warning("Cannot read ftrace files, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot read ftrace files, unexpected state 0x%X",
+				     handle->file_state);
 		return -1;
 	}
 
@@ -694,8 +694,8 @@ static int read_event_files(struct tracecmd_output *handle,
 	int ret;
 
 	if (check_out_state(handle, TRACECMD_FILE_ALL_EVENTS) < 0) {
-		warning("Cannot read event files, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot read event files, unexpected state 0x%X",
+				     handle->file_state);
 		return -1;
 	}
 	/*
@@ -774,7 +774,7 @@ err:
 	if (fd > 0)
 		close(fd);
 	if (ret)
-		warning("can't set kptr_restrict");
+		tracecmd_lib_warning("can't set kptr_restrict");
 }
 
 static int read_proc_kallsyms(struct tracecmd_output *handle,
@@ -786,8 +786,8 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	int ret;
 
 	if (check_out_state(handle, TRACECMD_FILE_KALLSYMS) < 0) {
-		warning("Cannot read kallsyms, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot read kallsyms, unexpected state 0x%X",
+				     handle->file_state);
 		return -1;
 	}
 
@@ -812,7 +812,7 @@ static int read_proc_kallsyms(struct tracecmd_output *handle,
 	check_size = copy_file(handle, path);
 	if (size != check_size) {
 		errno = EINVAL;
-		warning("error in size of file '%s'", path);
+		tracecmd_lib_warning("error in size of file '%s'", path);
 		set_proc_kptr_restrict(1);
 		return -1;
 	}
@@ -831,8 +831,8 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	int ret;
 
 	if (check_out_state(handle, TRACECMD_FILE_PRINTK) < 0) {
-		warning("Cannot read printk, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot read printk, unexpected state 0x%X",
+				     handle->file_state);
 		return -1;
 	}
 
@@ -856,7 +856,7 @@ static int read_ftrace_printk(struct tracecmd_output *handle)
 	check_size = copy_file(handle, path);
 	if (size != check_size) {
 		errno = EINVAL;
-		warning("error in size of file '%s'", path);
+		tracecmd_lib_warning("error in size of file '%s'", path);
 		goto fail;
 	}
 
@@ -892,7 +892,7 @@ static int save_tracing_file_data(struct tracecmd_output *handle,
 		check_size = copy_file(handle, file);
 		if (size != check_size) {
 			errno = EINVAL;
-			warning("error in size of file '%s'", file);
+			tracecmd_lib_warning("error in size of file '%s'", file);
 			goto out_free;
 		}
 	} else {
@@ -1062,14 +1062,14 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
 	if (size) {
 		data = malloc(size);
 		if (!data) {
-			warning("Insufficient memory");
+			tracecmd_lib_warning("Insufficient memory");
 			return NULL;
 		}
 	}
 
 	option = malloc(sizeof(*option));
 	if (!option) {
-		warning("Could not allocate space for option");
+		tracecmd_lib_warning("Could not allocate space for option");
 		free(data);
 		return NULL;
 	}
@@ -1119,8 +1119,8 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 
 	ret = check_out_state(handle, TRACECMD_FILE_CPU_COUNT);
 	if (ret < 0) {
-		warning("Cannot write CPU count into the file, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot write CPU count into the file, unexpected state 0x%X",
+				     handle->file_state);
 		return ret;
 	}
 	cpus = convert_endian_4(handle, cpus);
@@ -1144,8 +1144,8 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 		return 0;
 	ret = check_out_state(handle, TRACECMD_FILE_OPTIONS);
 	if (ret < 0) {
-		warning("Cannot write options into the file, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot write options into the file, unexpected state 0x%X",
+				     handle->file_state);
 		return ret;
 	}
 
@@ -1238,7 +1238,7 @@ int tracecmd_update_option(struct tracecmd_output *handle,
 	stsize_t ret;
 
 	if (size > option->size) {
-		warning("Can't update option with more data than allocated");
+		tracecmd_lib_warning("Can't update option with more data than allocated");
 		return -1;
 	}
 
@@ -1254,7 +1254,7 @@ int tracecmd_update_option(struct tracecmd_output *handle,
 
 	ret = lseek64(handle->fd, option->offset, SEEK_SET);
 	if (ret == (off64_t)-1) {
-		warning("could not seek to %lld\n", option->offset);
+		tracecmd_lib_warning("could not seek to %lld\n", option->offset);
 		return -1;
 	}
 
@@ -1263,7 +1263,7 @@ int tracecmd_update_option(struct tracecmd_output *handle,
 
 	ret = lseek64(handle->fd, offset, SEEK_SET);
 	if (ret == (off64_t)-1) {
-		warning("could not seek to %lld\n", offset);
+		tracecmd_lib_warning("could not seek to %lld\n", offset);
 		return -1;
 	}
 
@@ -1280,7 +1280,7 @@ tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 
 	buf = malloc(size);
 	if (!buf) {
-		warning("Failed to malloc buffer");
+		tracecmd_lib_warning("Failed to malloc buffer");
 		return NULL;
 	}
 	*(tsize_t *)buf = 0;
@@ -1306,8 +1306,8 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
 
 	ret = check_out_state(handle, TRACECMD_FILE_CMD_LINES);
 	if (ret < 0) {
-		warning("Cannot write command lines into the file, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot write command lines into the file, unexpected state 0x%X",
+				     handle->file_state);
 		return ret;
 	}
 	ret = save_tracing_file_data(handle, "saved_cmdlines");
@@ -1341,8 +1341,8 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 
 	ret = check_out_state(handle, TRACECMD_FILE_CPU_LATENCY);
 	if (ret < 0) {
-		warning("Cannot write latency data into the file, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot write latency data into the file, unexpected state 0x%X",
+				     handle->file_state);
 		goto out_free;
 	}
 
@@ -1424,8 +1424,8 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 	ret = handle->file_state == TRACECMD_FILE_CPU_FLYRECORD ? 0 :
 		check_out_state(handle, TRACECMD_FILE_CPU_FLYRECORD);
 	if (ret < 0) {
-		warning("Cannot write trace data into the file, unexpected state 0x%X",
-			handle->file_state);
+		tracecmd_lib_warning("Cannot write trace data into the file, unexpected state 0x%X",
+				     handle->file_state);
 		goto out_free;
 	}
 
@@ -1467,7 +1467,7 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 		file = cpu_data_files[i];
 		ret = stat(file, &st);
 		if (ret < 0) {
-			warning("can not stat '%s'", file);
+			tracecmd_lib_warning("can not stat '%s'", file);
 			goto out_free;
 		}
 		offsets[i] = offset;
@@ -1492,14 +1492,14 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 				i, (unsigned long long) offsets[i]);
 		offset = lseek64(handle->fd, offsets[i], SEEK_SET);
 		if (offset == (off64_t)-1) {
-			warning("could not seek to %lld\n", offsets[i]);
+			tracecmd_lib_warning("could not seek to %lld\n", offsets[i]);
 			goto out_free;
 		}
 		check_size = copy_file(handle, cpu_data_files[i]);
 		if (check_size != sizes[i]) {
 			errno = EINVAL;
-			warning("did not match size of %lld to %lld",
-			    check_size, sizes[i]);
+			tracecmd_lib_warning("did not match size of %lld to %lld",
+					     check_size, sizes[i]);
 			goto out_free;
 		}
 		if (!tracecmd_get_quiet(handle))
@@ -1548,7 +1548,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 	/* Go to the option data, where will write the offest */
 	ret = lseek64(handle->fd, option->offset, SEEK_SET);
 	if (ret == (off64_t)-1) {
-		warning("could not seek to %lld\n", option->offset);
+		tracecmd_lib_warning("could not seek to %lld\n", option->offset);
 		return -1;
 	}
 
@@ -1558,7 +1558,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 	/* Go back to end of file */
 	ret = lseek64(handle->fd, offset, SEEK_SET);
 	if (ret == (off64_t)-1) {
-		warning("could not seek to %lld\n", offset);
+		tracecmd_lib_warning("could not seek to %lld\n", offset);
 		return -1;
 	}
 
diff --git a/lib/trace-cmd/trace-plugin.c b/lib/trace-cmd/trace-plugin.c
index 92f9edf3..207ce5d9 100644
--- a/lib/trace-cmd/trace-plugin.c
+++ b/lib/trace-cmd/trace-plugin.c
@@ -10,6 +10,7 @@
 #include <libgen.h>
 #include "trace-cmd.h"
 #include "trace-local.h"
+#include "trace-cmd-local.h"
 
 #define LOCAL_PLUGIN_DIR ".local/lib/trace-cmd/plugins/"
 
@@ -107,14 +108,14 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 
 	ret = asprintf(&plugin, "%s/%s", path, file);
 	if (ret < 0) {
-		warning("could not allocate plugin memory\n");
+		tracecmd_lib_warning("could not allocate plugin memory\n");
 		return;
 	}
 
 	handle = dlopen(plugin, RTLD_NOW | RTLD_GLOBAL);
 	if (!handle) {
-		warning("could not load plugin '%s'\n%s\n",
-			plugin, dlerror());
+		tracecmd_lib_warning("could not load plugin '%s'\n%s\n",
+				     plugin, dlerror());
 		goto out_free;
 	}
 
@@ -124,14 +125,14 @@ load_plugin(struct trace_plugin_context *trace, const char *path,
 
 	func = dlsym(handle, TRACECMD_PLUGIN_LOADER_NAME);
 	if (!func) {
-		warning("could not find func '%s' in plugin '%s'\n%s\n",
-			TRACECMD_PLUGIN_LOADER_NAME, plugin, dlerror());
+		tracecmd_lib_warning("could not find func '%s' in plugin '%s'\n%s\n",
+				     TRACECMD_PLUGIN_LOADER_NAME, plugin, dlerror());
 		goto out_free;
 	}
 
 	list = malloc(sizeof(*list));
 	if (!list) {
-		warning("could not allocate plugin memory\n");
+		tracecmd_lib_warning("could not allocate plugin memory\n");
 		goto out_free;
 	}
 
@@ -256,7 +257,7 @@ load_plugins_hook(struct trace_plugin_context *trace, const char *suffix,
 
 	ret = asprintf(&path, "%s/%s", home, LOCAL_PLUGIN_DIR);
 	if (ret < 0) {
-		warning("could not allocate plugin memory\n");
+		tracecmd_lib_warning("could not allocate plugin memory\n");
 		return;
 	}
 
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index c811028a..732aeffa 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -14,6 +14,7 @@
 
 #include "tracefs.h"
 #include "trace-cmd-private.h"
+#include "trace-cmd-local.h"
 #include "event-utils.h"
 
 /* F_GETPIPE_SZ was introduced in 2.6.35, older systems don't have it */
@@ -393,7 +394,7 @@ static long splice_data(struct tracecmd_recorder *recorder)
 		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
 			return 0;
 
-		warning("recorder error in splice input");
+		tracecmd_lib_warning("recorder error in splice input");
 		return -1;
 	} else if (read == 0)
 		return 0;
@@ -403,7 +404,7 @@ static long splice_data(struct tracecmd_recorder *recorder)
 		     read, recorder->fd_flags);
 	if (ret < 0) {
 		if (errno != EAGAIN && errno != EINTR) {
-			warning("recorder error in splice output");
+			tracecmd_lib_warning("recorder error in splice output");
 			return -1;
 		}
 		return total_read;
@@ -451,7 +452,7 @@ static long direct_splice_data(struct tracecmd_recorder *recorder)
 		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
 			return 0;
 
-		warning("recorder error in splice input");
+		tracecmd_lib_warning("recorder error in splice input");
 		return -1;
 	}
 
@@ -473,7 +474,7 @@ static long read_data(struct tracecmd_recorder *recorder)
 		if (errno == EAGAIN || errno == EINTR || errno == ENOTCONN)
 			return 0;
 
-		warning("recorder error in read input");
+		tracecmd_lib_warning("recorder error in read input");
 		return -1;
 	}
 
diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 242f0cef..eb5893ed 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -20,6 +20,7 @@
 #include <pthread.h>
 
 #include "trace-cmd-private.h"
+#include "trace-cmd-local.h"
 #include "tracefs.h"
 #include "event-utils.h"
 #include "trace-tsync-local.h"
@@ -729,7 +730,7 @@ static int tsync_get_sample(struct tracecmd_time_sync *tsync, unsigned int cpu,
 
 	ret = proto->clock_sync_calc(tsync, &offset, &scaling, &timestamp, cpu);
 	if (ret) {
-		warning("Failed to synchronize timestamps with guest");
+		tracecmd_lib_warning("Failed to synchronize timestamps with guest");
 		return -1;
 	}
 	if (!offset || !timestamp || !scaling)
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index db7bead6..0d1ce989 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -20,9 +20,10 @@
 #include <sys/stat.h>
 #include <sys/sysinfo.h>
 #include <time.h>
+#include <traceevent/event-utils.h>
 
 #include "trace-cmd-private.h"
-#include "event-utils.h"
+#include "trace-cmd-local.h"
 
 #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
 #define PROC_STACK_FILE "/proc/sys/kernel/stack_tracer_enabled"
@@ -182,7 +183,7 @@ void tracecmd_parse_ftrace_printk(struct tep_handle *pevent,
 	while (line) {
 		addr_str = strtok_r(line, ":", &fmt);
 		if (!addr_str) {
-			warning("printk format with empty entry");
+			tracecmd_lib_warning("printk format with empty entry");
 			break;
 		}
 		addr = strtoull(addr_str, NULL, 16);
@@ -353,28 +354,23 @@ trace_load_plugins(struct tep_handle *tep, int flags)
 	return list;
 }
 
-static int __vlib_warning(const char *fmt, va_list ap)
+void __weak tracecmd_lib_warning(const char *fmt, ...)
 {
-	int ret = errno;
-
-	if (errno)
-		perror("libtracecmd");
-
-	fprintf(stderr, "  ");
-	vfprintf(stderr, fmt, ap);
-
-	fprintf(stderr, "\n");
+	va_list ap;
 
-	return ret;
+	va_start(ap, fmt);
+	tep_vwarning("libtracecmd", fmt, ap);
+	va_end(ap);
 }
 
+
 void __weak tracecmd_lib_fatal(const char *fmt, ...)
 {
 	int ret;
 	va_list ap;
 
 	va_start(ap, fmt);
-	ret = __vlib_warning(fmt, ap);
+	ret = tep_vwarning("libtracecmd", fmt, ap);
 	va_end(ap);
 
 	if (debug) {
@@ -524,7 +520,7 @@ int tracecmd_count_cpus(void)
 
 	if (!once) {
 		once++;
-		warning("sysconf could not determine number of CPUS");
+		tracecmd_lib_warning("sysconf could not determine number of CPUS");
 	}
 
 	/* Do the hack to figure out # of CPUS */
diff --git a/python/ctracecmd.i b/python/ctracecmd.i
index 5f7181c7..26aee991 100644
--- a/python/ctracecmd.i
+++ b/python/ctracecmd.i
@@ -63,7 +63,7 @@ void warning(const char *fmt, ...)
 		return;
 
 	va_start(ap, fmt);
-	__vwarning(fmt, ap);
+	tep_vwarning("tracecmd", fmt, ap);
 	va_end(ap);
 }
 
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 6a4c5f51..1218de12 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -27,6 +27,8 @@ typedef unsigned long long u64;
 
 struct buffer_instance;
 
+void warning(const char *fmt, ...);
+
 /* for local shared information with trace-cmd executable */
 
 void usage(char **argv);
-- 
2.30.2


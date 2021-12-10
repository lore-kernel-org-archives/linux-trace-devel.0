Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA780C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbhLJK6a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbhLJK6a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:30 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFA9C0617A1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:55 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z5so29157118edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FTxbRE7J2CCNffKyRk83Aq/JpUiUJLQOQTu0Ub5Z5+8=;
        b=Jo616RfOtLuitO/yBgT2E6aigbkdYGvKyjYEH1FPji2smqJSW5B9Zy3iJbnWEwKTGw
         WrXRh/z/7HscQe/NloRbJxhphfuUyf1lLMz49gN0XevX24GmkLiki7g4cAiYnktaPdLR
         7smf0huGJjzYBw2/632RlU5MMUppuEcaEP20jUyIF3jzOLLlf5ni4vR39OijDLEeB1YZ
         YQpPv3QyJ21dvVwPEA/VxyvxS/OToQGtswhe6CYX2/OnoSvYnH+8HFPYLKVf4Ik81QSQ
         u2bAsxifyiPN7MEqlAxdANbr4HYg3EsQ6zRG007vHe08xCv2Qh/YfXD4T00GCDEJjkfK
         g09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FTxbRE7J2CCNffKyRk83Aq/JpUiUJLQOQTu0Ub5Z5+8=;
        b=uoAnKO+P9DYtFc0bcVUue7tj9VQfG4GQc4UlgJGZ3B42oTkrnJ2FcP/4zoHFE6EnBC
         KEgxx6nckp105KjnilTRal+PXjUpFI0lt08I08t0hUE//xjqS6RTkI1uT2PLs9iDLQpl
         h2kFEmUuJWhxqMf2zhs+pY8R5ce3UlL9Qn1ETyRLcQuZCLDwmGeiNx0szvv53ILmOm/m
         Wwtoqlb2O+i+4L3DH8a9el2ur6Pub1GLJAzSu71I/cy3BamldWjpK+zMQM3EMevaqzyo
         FRzosv1F8XVavapjVYt4ZZ5pCy/w/IEQZyW8qDiH/9lr0wvPDnEO284bMD2B9uWb0CQm
         PQkw==
X-Gm-Message-State: AOAM5314kBochx4ea5w6zo9WAnxIhnGa30ku+UQLLmL7hNJzvOOkywb+
        xHPC9zLEtKaMvLCl3a7VthZmaOpa+/k=
X-Google-Smtp-Source: ABdhPJzKhnwDE9C1Rk+u+1uzK3qoXnIZBpz9U2PsNGNvX9h7a9w6tn7YjoljW7iPHKUTI/iKDj7MSA==
X-Received: by 2002:a17:906:9253:: with SMTP id c19mr23833726ejx.63.1639133694036;
        Fri, 10 Dec 2021 02:54:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:54:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 04/25] trace-cmd library: Add strings section in trace file version 7
Date:   Fri, 10 Dec 2021 12:54:27 +0200
Message-Id: <20211210105448.97850-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In the trace file metadata there are various dynamic strings. Collecting
all these strings in a dedicated section in the file simplifies parsing
of the metadata. The string section is added in trace files version 7,
at the end of the file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 +
 lib/trace-cmd/trace-output.c                  | 63 +++++++++++++++++++
 tracecmd/trace-record.c                       |  1 +
 3 files changed, 66 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ed25d879..ed8fbf11 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -138,6 +138,7 @@ enum {
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
 	TRACECMD_OPTION_TSC2NSEC,
+	TRACECMD_OPTION_STRINGS,
 };
 
 enum {
@@ -301,6 +302,7 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle);
 int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
 int tracecmd_write_options(struct tracecmd_output *handle);
+int tracecmd_write_meta_strings(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4d165ac2..ed505db6 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -62,6 +62,8 @@ struct tracecmd_output {
 	bool			quiet;
 	unsigned long		file_state;
 	unsigned long		file_version;
+	unsigned long		strings_p;
+	unsigned long		strings_offs;
 	size_t			options_start;
 	bool			big_endian;
 
@@ -69,6 +71,8 @@ struct tracecmd_output {
 	struct list_head	buffers;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
+	char			*strings;
+
 };
 
 struct list_event {
@@ -85,6 +89,8 @@ struct list_event_system {
 
 #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
 
+static int save_string_section(struct tracecmd_output *handle);
+
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
@@ -127,6 +133,22 @@ static unsigned long long convert_endian_8(struct tracecmd_output *handle,
 	return tep_read_number(handle->pevent, &val, 8);
 }
 
+static long add_string(struct tracecmd_output *handle, const char *string)
+{
+	int size = strlen(string) + 1;
+	int pos = handle->strings_p;
+	char *strings;
+
+	strings = realloc(handle->strings, pos + size);
+	if (!strings)
+		return -1;
+	handle->strings = strings;
+	memcpy(handle->strings + pos, string, size);
+	handle->strings_p += size;
+
+	return handle->strings_offs + pos;
+}
+
 /**
  * tracecmd_set_quiet - Set if to print output to the screen
  * @quiet: If non zero, print no output to the screen
@@ -185,6 +207,7 @@ void tracecmd_output_free(struct tracecmd_output *handle)
 		free(option);
 	}
 
+	free(handle->strings);
 	free(handle->trace_clock);
 	free(handle);
 }
@@ -194,6 +217,11 @@ void tracecmd_output_close(struct tracecmd_output *handle)
 	if (!handle)
 		return;
 
+	if (handle->file_version >= FILE_VERSION_SECTIONS) {
+		/* write strings section */
+		save_string_section(handle);
+	}
+
 	if (handle->fd >= 0) {
 		close(handle->fd);
 		handle->fd = -1;
@@ -332,6 +360,32 @@ int tracecmd_ftrace_enable(int set)
 	return ret;
 }
 
+static int save_string_section(struct tracecmd_output *handle)
+{
+	if (!handle->strings || !handle->strings_p)
+		return 0;
+
+	if (!check_out_state(handle, TRACECMD_OPTION_STRINGS)) {
+		tracecmd_warning("Cannot write strings, unexpected state 0x%X",
+				 handle->file_state);
+		return -1;
+	}
+
+	if (do_write_check(handle, handle->strings, handle->strings_p))
+		goto error;
+
+	handle->strings_offs += handle->strings_p;
+	free(handle->strings);
+	handle->strings = NULL;
+	handle->strings_p = 0;
+	handle->file_state = TRACECMD_OPTION_STRINGS;
+	return 0;
+
+error:
+	return -1;
+}
+
+
 static int read_header_files(struct tracecmd_output *handle)
 {
 	tsize_t size, check_size, endian8;
@@ -1328,6 +1382,15 @@ int tracecmd_write_options(struct tracecmd_output *handle)
 	return 0;
 }
 
+int tracecmd_write_meta_strings(struct tracecmd_output *handle)
+{
+	if (!HAS_SECTIONS(handle))
+		return 0;
+
+	return save_string_section(handle);
+}
+
+
 int tracecmd_append_options(struct tracecmd_output *handle)
 {
 	struct tracecmd_option *options;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 7b2b59bb..f599610e 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4093,6 +4093,7 @@ static void setup_agent(struct buffer_instance *instance,
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
 	tracecmd_write_options(network_handle);
+	tracecmd_write_meta_strings(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
 	instance->network_handle = network_handle;
 }
-- 
2.33.1


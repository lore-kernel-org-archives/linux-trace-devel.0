Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A883FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6CC60FC4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbhJHEP1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEP0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:26 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147F4C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:32 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b8so31166292edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qz3DnBbaKVcB7Hzd0sRLfkmhyCjllO3KWpE9qOE4CPY=;
        b=fxRrJODhb8uLRNTSsfQn4Y9XeSd/ASs8yzlTicrMxnOXYV7EFNb0xhPkBkpHI3CK33
         XGruIas70Sh5jJj0NN3Di66NK9hm0dprHRc/WhqvlQ7VHY6zHaHgCQ3DE/W3/wX2/Qlq
         xalnUe2oqP69tB3Yf6diEdySjE4ri2u314tSB8Iy9fA1pDg32sP+u3wqyt0dsIGW6xwL
         7u00fu9l7KjI/7OGj1P+41odDTK1kkgqrJ7vP3jG8eghN18dbs/z+tD9x+KwFgFj6xGy
         Tn47hjYW0KQtiZk/2Yii510TE4OLs09oAgrihNr0Zd4sfPg/LxuB37aSFgQ96QCZYWyl
         l0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qz3DnBbaKVcB7Hzd0sRLfkmhyCjllO3KWpE9qOE4CPY=;
        b=b0ZNvWvDiCm+Lcc0qRKWn7FLV+jla90s+13iYmoRyoVj4eHpjRdo5cm+y5JUpsBPGI
         7QO5BFzS1/KGldo+Xf+ITIkOdzUdqL+w1swXdNsutWqRi4Ej0s6g3l2P6pGhQ/2ZH7Av
         G3Mm/W4muwhSvVMHBzhivUgL9suHw58FVitfvzyOT1mFdoh7mm5dvB1cyUYZH0cImh6a
         YN/u9bcKMB/m3xdMMH331BhdJuHx/pkORdRGxo3HAbhRRt4k423wRvmmcvI06aRFj2x5
         uBAC0RIvnmrTS1BaCOBu0zsbTnwPK7l6FfymwQ6atX5cK6IY4N7hCDRc7tmxGa38J++3
         LWqA==
X-Gm-Message-State: AOAM531s4Vt1M11EfsSvH7uhJ9R+BY8pklzGzjl897ZUYKrm7E/01ROE
        jkVEkzWkzf/fqqyzqYAV65Jhsr0fQe1dMg==
X-Google-Smtp-Source: ABdhPJwwFRA4QBWX9oy+CECpBkWf4jtMrGiYBW0CnulgGyPPYwzggtiFX9zEcK9m6dxOzYaTw+99Dg==
X-Received: by 2002:a17:907:785a:: with SMTP id lb26mr1230390ejc.77.1633666410700;
        Thu, 07 Oct 2021 21:13:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/10] trace-cmd library: New API to write headers of a trace file
Date:   Fri,  8 Oct 2021 07:13:18 +0300
Message-Id: <20211008041321.973755-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API writes metadata headers in a trace file.
 tracecmd_output_write_headers()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 ++
 lib/trace-cmd/trace-output.c                  | 44 +++++++++++++++++--
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 08ec765f..086e6906 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -276,6 +276,9 @@ int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *t
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 int tracecmd_output_write_init(struct tracecmd_output *handler);
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list);
+
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6e4549f9..f8a16d82 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -684,7 +684,7 @@ static int read_event_files(struct tracecmd_output *handle,
 			break;
 	}
 	/* all events are listed, use a global glob */
-	if (list)
+	if (!event_list || list)
 		event_list = &all_events;
 
 	systems = create_event_list(handle, event_list);
@@ -754,8 +754,7 @@ err:
 		tracecmd_warning("can't set kptr_restrict");
 }
 
-static int read_proc_kallsyms(struct tracecmd_output *handle,
-			      const char *kallsyms)
+static int read_proc_kallsyms(struct tracecmd_output *handle)
 {
 	unsigned int size, check_size, endian4;
 	const char *path = "/proc/kallsyms";
@@ -1083,6 +1082,43 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	return 0;
 }
 
+/**
+ * tracecmd_output_write_headers - Write the trace file headers
+ * @handle: output handler to a trace file.
+ * @list: desired events that will be included in the trace file.
+ *	  It can be NULL for all available events
+ *
+ * These headers are written in the file:
+ *  - header files from the tracing directory
+ *  - ftrace events from the tracing directory
+ *  - event file from the tracing directory - all or only the one from @list
+ *  - kernel symbols from the tracing directory
+ *  - kernel printk strings from the tracing directory
+ *
+ * Returns 0 on success, or -1 in case of an error.
+ */
+int tracecmd_output_write_headers(struct tracecmd_output *handler,
+				  struct tracecmd_event_list *list)
+{
+	if (!handler || handler->file_state < TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	/* Write init data, if not written yet */
+	if (handler->file_state < TRACECMD_FILE_INIT && tracecmd_output_write_init(handler))
+		return -1;
+	if (read_header_files(handler))
+		return -1;
+	if (read_ftrace_files(handler))
+		return -1;
+	if (read_event_files(handler, list))
+		return -1;
+	if (read_proc_kallsyms(handler))
+		return -1;
+	if (read_ftrace_printk(handler))
+		return -1;
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
@@ -1181,7 +1217,7 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (read_event_files(handle, list))
 		goto out_free;
 
-	if (read_proc_kallsyms(handle, kallsyms))
+	if (read_proc_kallsyms(handle))
 		goto out_free;
 
 	if (read_ftrace_printk(handle))
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6AE3C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F9A160F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbhJHEP0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEPZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:25 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5C0C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i20so15143959edj.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aRa2gSP9g5is5oS3zhXj4hYvo2PgF1YJz8fVmoNqysg=;
        b=lfKwLj6TnLiDd2k6RjvrOtplQZKrtytfXTCWtijt28vjRz7bfon58uvF1hy4Ug+Ai5
         87jDm1zcUAS+SbmO6aOF7fCLZa0qeFfpueCxdMTgiwAgWJRFQlU8AqPGdHL51G12JGlT
         Zg/Ahs4CodVB0a7nsR2yiknBon7xgYtS375pw9QEHfpZjQDTa49teNly3gDCN0+i5vVh
         JqL+cExy5/abhFcybKHgzI9UqpuNewb0dfhCFU6/VtSRGiHSlD+RwssUg0vZtdQwfuLS
         GUse7oVCmyeDRsOBQ8rK2XSQMtw44PipF4exmpC1ExBRw3sdshxFm8gpzV+Fs6BjkhA6
         jZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aRa2gSP9g5is5oS3zhXj4hYvo2PgF1YJz8fVmoNqysg=;
        b=zv+rLgtHIp3FgXx1Y5qKhIXfo3oQnGsPEv27zPSDvq5r6hoW9fExLrhHwKBY7/1C1g
         ej/gqni8Z8SCmI8a2l1HsdfPC0aVfVIQC8n631VYGCc/nvBJ8Raqa7qhga/tdLcQEzoR
         oGILs90w4j2QYrGCTrx6tmZnvyuwIX660VxwkSRCwDHP/zk+ZnvQ/6IjRKGbi3lpvde6
         Sydt1EvNpkRftT43NQpVogjPQaXIBoKubjMZpdgkvPOaj0xvOYRPq8+6vC4hnz9lyFuY
         amM7dIZishvxaX1RLeZDki6RIqNc7uZeC3ABvv6CxtIMIdQYDRhExRW3zDa69tKeV1Zq
         fk8w==
X-Gm-Message-State: AOAM531QjU9eOdmJwEWy430HvH9rfeGa7DXc+OuTj2PgZLpwFFx/qvvk
        CCesAifP0vSR7pbF7llhcRI/SyK6KDfrGg==
X-Google-Smtp-Source: ABdhPJzQaqcZ/Fm9OQfjHlsP1GhWvz19Xz+OBzEm717ZD7TGXzet4YbnHVxrLkGaKjcge/oonZIIfQ==
X-Received: by 2002:a17:906:48ce:: with SMTP id d14mr1283783ejt.336.1633666409752;
        Thu, 07 Oct 2021 21:13:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/10] trace-cmd library: New API tracecmd_output_write_init
Date:   Fri,  8 Oct 2021 07:13:17 +0300
Message-Id: <20211008041321.973755-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API writes initial magic bits in a trace file.
 tracecmd_output_write_init()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 54 +++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index da1dbb09..08ec765f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -275,6 +275,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler,
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
 int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
+int tracecmd_output_write_init(struct tracecmd_output *handler);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 7db3729b..6e4549f9 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1029,6 +1029,60 @@ int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct trace
 	return 0;
 }
 
+/**
+ * tracecmd_output_write_init - Write the initial magics in the trace file
+ * @handle: output handler to a trace file.
+ *
+ * This API must be called after all tracecmd_output_set_...() APIs and before writing anything
+ * to the trace file. This initial information is written in the file:
+ *  - initial file magic bytes
+ *  - file version
+ *  - data endian
+ *  - long size
+ *  - page size
+ *  - compression header
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_write_init(struct tracecmd_output *handler)
+{
+	char buf[BUFSIZ];
+	int endian4;
+
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	buf[0] = 23;
+	buf[1] = 8;
+	buf[2] = 68;
+	memcpy(buf + 3, "tracing", 7);
+
+	if (do_write_check(handler, buf, 10))
+		return -1;
+
+	sprintf(buf, "%lu", handler->file_version);
+	if (do_write_check(handler, buf, strlen(buf) + 1))
+		return -1;
+
+	if (handler->big_endian)
+		buf[0] = 1;
+	else
+		buf[0] = 0;
+	if (do_write_check(handler, buf, 1))
+		return -1;
+
+	/* save size of long (this may not be what the kernel is) */
+	buf[0] = sizeof(long);
+	if (do_write_check(handler, buf, 1))
+		return -1;
+
+	endian4 = convert_endian_4(handler, handler->page_size);
+	if (do_write_check(handler, &endian4, 4))
+		return -1;
+	handler->file_state = TRACECMD_FILE_INIT;
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.31.1


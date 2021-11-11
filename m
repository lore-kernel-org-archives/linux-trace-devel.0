Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F9CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91839610A2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhKKPKF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhKKPKF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:05 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3ACC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:16 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x15so25456424edv.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tvq6a/OQ56vcQvBgTJWgo8iKYz9h21O+PziFclMbNMQ=;
        b=TyeaWEp58cmd/309U/xulHahqcpRHQzmKOXioYKuHO1H/mYmhA92uHv18M6V3q1jqo
         DF0XsxQ3GpaGGpQI5spa6AFE7A/SEQT1YJlVUCIfcTCeP9U7BdNXSCGA3y0S5aewsTyN
         nmB+skQbVNcTeQGMHU+JzugjAXV1XrT2KpNKktSIDE98CEIyTIlQLLbtuG/42LckIe8G
         T0RFASrsKNqmUvn2bCeRv+PdlIbelmrBp6wRiaCD/JK3c3ctlgAKE/MUAY/rpiibEAbH
         taAV5RJ28tdizKwer/dMyPBX2GCAlfVIsJHNslTFYHNhy4zKz7SAhfBsJND0ADXgsI3F
         zEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tvq6a/OQ56vcQvBgTJWgo8iKYz9h21O+PziFclMbNMQ=;
        b=6DgT5dnTf34RwxWlHoqIMxhqX7xxLR/ImfEDtlM+8DiDnGTlIL3O5jBqODiaGD8/YA
         3F0Ig2C6pR1ePP+M1QJ3yJEYO29JRJrbuJZo/N43wTSm0ZVkp501FrErrWf3h49JeUM+
         nV+8VzWp84gtlYzKLdIuyM/dogHEi6jcLHK1BHQS+sVicBy1XffHMhVFzozISkRVl6mM
         yo1ymRTgTgIM1eU8/uXQVUBkuZAjxS6Xn4uksEVlFSv55xRxEAzTXkg+YstSnMw8DdX5
         MVySVpk76UVBhmsYhzq1HKU/sHuS/OYn3iA7rvUrCo5pkNnHMzAZlC2m0LQmI4TRgPOh
         EFlQ==
X-Gm-Message-State: AOAM533SdrogVRQ2fHS8CQiCMGYeG0cC10bTrvCMZkXYobcFcl1dMNJR
        yM5RbyqW3iPNhyux55o/iIJKS7Jn0aq8Ow==
X-Google-Smtp-Source: ABdhPJx1In8i+5xFduCERXQGElroOMNZ9Tgpc+Nrsxd+qUJm/UMUIR7vT55ExYMeV2dDbei+Giaqqw==
X-Received: by 2002:a17:907:d94:: with SMTP id go20mr10198269ejc.78.1636643233386;
        Thu, 11 Nov 2021 07:07:13 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e12sm1510598ejs.86.2021.11.11.07.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:07:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/10] trace-cmd library: New API tracecmd_output_write_init
Date:   Thu, 11 Nov 2021 17:07:11 +0200
Message-Id: <20211111150711.86266-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
index 41876195..2a5ce996 100644
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
2.33.1


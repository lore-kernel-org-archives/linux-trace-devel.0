Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC8DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65D3560524
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbhKKPJ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhKKPJ5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:09:57 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2684DC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:08 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id f4so25288376edx.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZLSYG5xkYhVxtFiECSo1k52prJHONQdfcXmfEM5nkWc=;
        b=JCA5Vnrx1lKIqrVHIj7ftJ7urKxWXZ/8KqNThswwfHXH7sVoCaFMWRw4Oker63PNw0
         rdDE47bQ9MikW+ogtVPgTqXMKTzo7RuQajDKDq274NaPB5pLJkVr/5EPwcEq4Ui/4/CU
         ZRU2Z9tLYpprweoMrQvnESJfxYwmT4zRz3TCjS7z5TMCQvokguffwF3/irfOtcCTjHbG
         /VJaS/y5tu9FlW04lf2THheh1H8vaN1oWc+zVJgHJX4u3J71SkXFM7JIcaNiATU1p2uA
         r5e6t7DjJJY7DPLc71Yy2kFDVTlCFWc+6cUCgAHaboDjaD8bRmilXV3m/W2lSw1VBZSw
         C23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZLSYG5xkYhVxtFiECSo1k52prJHONQdfcXmfEM5nkWc=;
        b=pJdbSgrZ0Axkk2kdK85D1sofCQ0R3cyXtG3B4x0zmKj39w8iDb0AM+dYfOa4/Vrq1P
         5m5gCGO8ue2VpmiJfDoiNl3PBI97n1MBhE1F4fp3P31mYE4hz02VCM6MpV8zD3vYX3O5
         Pdtqj7vRoba+mJ3bpZf9u9nYVcaar/ZWYs/IEbwSOuAnBFuGROOsVEt0h24PhPMacZwB
         OsLho3EBc1TB0qgZKHQgJEvVW8+sPryeLc+RlyO2emjcRnP5a3XHIbCCXTOASuyCjk5e
         akPD0RytXdLQgWvRR7chSpnRiVc+aiViS6t58gcMNyJ62mQ5ochQppvOhNWn9jY8Hpf2
         EXlg==
X-Gm-Message-State: AOAM531gQ1kRNn/edLYEwhhc7Y0KJP5PkPEWQEuxH+f8nRgF1/GyiCm7
        rZgEHwFo8saZ7tn6rM04DQf8F1om1Gvswg==
X-Google-Smtp-Source: ABdhPJzCVNZqOT7bBXRzwVN3EdYERk+azn7u9HxjyA6suhO7yUx90IQyVFi0lGWdgNbJ2qsv6E+0SA==
X-Received: by 2002:a17:907:d90:: with SMTP id go16mr10008456ejc.137.1636643226724;
        Thu, 11 Nov 2021 07:07:06 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id hq33sm1695310ejc.119.2021.11.11.07.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:07:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/10] trace-cmd library: New API to inherit parameters from an existing trace file
Date:   Thu, 11 Nov 2021 17:07:05 +0200
Message-Id: <20211111150705.86248-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API initializes previously allocated output handler with
parameters from an input handler to a trace file.
 tracecmd_output_set_from_input()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 33 +++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 23e86107..41876195 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -274,6 +274,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler,
 			    struct tracecmd_msg_handle *msg_handle);
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c654561a..7db3729b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -996,6 +996,39 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *ka
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_from_input - Inherit parameters from an existing trace file
+ * @handle: output handler to a trace file.
+ * @ihandle: input handler to an existing trace file.
+ *
+ * This API copies parameters from input handler @ihandle, associated with an existing trace file,
+ * to the output handler @handle, associated with file that is going to be created.
+ * These parameters are copied:
+ *  - tep handler
+ *  - page size
+ *  - file endian
+ *  - file version
+ *  - file compression protocol
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
+{
+	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	/* get endian, page size, file version and compression */
+	/* Use the pevent of the ihandle for later writes */
+	handler->pevent = tracecmd_get_tep(ihandle);
+	tep_ref(handler->pevent);
+	handler->page_size = tracecmd_page_size(ihandle);
+	handler->file_version = tracecmd_get_in_file_version(ihandle);
+	handler->big_endian = tep_is_file_bigendian(handler->pevent);
+
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.33.1


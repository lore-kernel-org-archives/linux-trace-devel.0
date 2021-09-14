Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C378C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9FDE60F11
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhINNXL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbhINNXL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:11 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 994B2C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id c22so18473833edn.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XuGRDg06q73jbPgmeD6b8pH/4xE6jY0heKZ3XoehWA8=;
        b=Ns/dsRD6rb08K4Kq7e8pnBWQSA2kY0EQk1kzv9T06ItqnVjVGcza3iciWdalWlBuPY
         eYCUhSzbeisOPpk90fUIN/GcY+fmWL+viti6E2QSBG+XFWW4Bdpi1HJeRFuMBeZFGzlk
         lh1HJyGieiaPDT4NR8uk17bwEpOBKSkEPFX+KiI/bZXZ0T6vDo6KWjQak/T7/trRaaAh
         kaMAWnlVHZcDbNqXYcX904ixF8DDSitqL5mf4UNJFSioPp5SoMDhIrLp1gCaQ+eOFf0A
         3XvIwZQfG3/gxNZfy7XLHqXGg17LHkvWsnJJoLLYRYMi5ezrlDRDrMh6/MTV5L8fQkbK
         TjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XuGRDg06q73jbPgmeD6b8pH/4xE6jY0heKZ3XoehWA8=;
        b=2yN1Zzq3NQ+Gihrdjh5r5CocFaBvi6GEufHUGVpsgZQ9m4LdS3A6UomhtUMsetEN6Q
         J116VAmZleNG/AJX7gSkNIKAXarzNzWzp9+v99pjkQuMNwBYbsmY/BL/y+cpoh6k2k8R
         Mxp7B+Ui5/2/BE3LUCQcVf9o43PmEcJN3ePmPNFtinivqk58LFs52rs2OkTO96KE2vyv
         g4gmXgkZZzyjcpA9jtz22QVIVqai21XhNXogqHsd6R6eUaetTSqSLpDDLOMXWeFI59N0
         BNgVeA5lKMkq7luwRhrxe/bH9LYq/bvgk/p2T5jQVcxwUxp19MmZAj7rGE98Bie9BpyG
         119Q==
X-Gm-Message-State: AOAM530RxViNqiwNwnPRIizCmIvriDS7pkRj+VP+RTH2z6+yyiTFEX3V
        SGrmUOcij0O/blCF2OFUDVj5uLfZOPk=
X-Google-Smtp-Source: ABdhPJwpUlhVZpIJ350gEkL3e5q0uYjfaGemASPkxGIueRzrxXxfVgeeHhMzerxjaV0Rtne5pBbNkw==
X-Received: by 2002:a05:6402:26c6:: with SMTP id x6mr19304097edd.10.1631625712209;
        Tue, 14 Sep 2021 06:21:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/10] trace-cmd dump: Print compression header
Date:   Tue, 14 Sep 2021 16:21:40 +0300
Message-Id: <20210914132148.3968401-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Dump the compression header of trace file version 7

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index d0278f7e..3cce231f 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -217,6 +217,29 @@ static void dump_initial_format(int fd)
 	do_print(SUMMARY, "\t\t%d\t[Page size, bytes]\n", val4);
 }
 
+static void dump_compress(int fd)
+{
+	char zname[DUMP_SIZE];
+	char zver[DUMP_SIZE];
+
+	if (file_version < FILE_VERSION_COMPRESSION)
+		return;
+
+	/* get compression header */
+	if (read_file_string(fd, zname, DUMP_SIZE))
+		die("no compression header");
+	if (read_file_string(fd, zver, DUMP_SIZE))
+		die("no compression version");
+	do_print((SUMMARY), "\t\t%s\t[Compression algorithm]\n", zname);
+	do_print((SUMMARY), "\t\t%s\t[Compression version]\n", zver);
+
+	if (strcmp(zname, "none")) {
+		compress = tracecmd_compress_alloc(zname, zver, fd, tep, NULL);
+		if (!compress)
+			die("cannot uncompress the file");
+	}
+}
+
 static void dump_header_page(int fd)
 {
 	unsigned long long size;
@@ -715,6 +738,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.31.1


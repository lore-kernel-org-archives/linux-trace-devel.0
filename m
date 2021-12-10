Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20355C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 11:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbhLJLIz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240246AbhLJLIy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:08:54 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F876C061353
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:19 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id y13so28328721edd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 03:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BrG3YYYzPJeeHMDZrmsvJT3K7XJlnw/6xk4Ufrc2OFA=;
        b=gezFsOQ4s+fPs2b8obuzY3j2iBpPicMJdb1F6rhRO4uV9Rgbs4HiJ12bzUJJRRObmV
         a1b+FIIfc/7XJKJx2lKp1oVEVEYrG5/fGq/OgrIOS66gLReJawClf6njVEdYSGEyBxQk
         sxQK6tNLWY6kPDyppjt7azPJmtHB6/JiIS1AsnwcgCIGQgVL1WIj/sq2XaORC/bpZy5j
         qdIzPf38AiOeziD5g3+z26fgK7mZbgUEX3GZUWk4B/8Xlf0bQhKpwvR/KeOWRYw38bUT
         GaTEy7LQBTIsIfXZw7pgD4xZyU0mA9iqXOeW2ktr4UuOHi32PffhMFN8q47FnDEyOVpY
         J5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BrG3YYYzPJeeHMDZrmsvJT3K7XJlnw/6xk4Ufrc2OFA=;
        b=77YTMb5LFgc1w0aE1qILALmMuN348DoZhl3+hya3dv8zluXthBq+kEgaAswuVpTbs8
         9ZlEbdx9GyTbCXgvr+hqUCR8JY733BvXvMSNVppCAfCEOkxfsxq3FfwRiGi0w0Fnr7CR
         W+wD+gUgajTlKf9U5jCsaftwA080+8at2OxuJnUqjQDiD6KNwiPcbq+YI7ug7Zd7+P6H
         vBM4wIUTrJpoKApWo+lxIBDfRZapythIUdocClSWtCfYOJLY9iG4H/+xCUAXDC6Fasaa
         fsgsrboow88s+t8NiDABxA768IG/+OoVot31yM3oMeeNQEvB4lhQzod2aRCR2j89QIlg
         LL4Q==
X-Gm-Message-State: AOAM533SycQI9B+4gzvdavme0KpUKjfkKfl6PYITqL7xIrJAfE1Vg65c
        7yapc0kYVxlv0YYz7SVAYJKvXauGeGs=
X-Google-Smtp-Source: ABdhPJytXiKPte8bfuYX79BWi1LRYT+Lr6NiV1F67xn1zKqFTBLmgrPq8M9GgEqBHEl2PcjPLF6hEw==
X-Received: by 2002:a17:907:98f6:: with SMTP id ke22mr22998884ejc.500.1639134316032;
        Fri, 10 Dec 2021 03:05:16 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gs17sm1278887ejc.28.2021.12.10.03.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 03:05:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 02/11] trace-cmd dump: Print compression header
Date:   Fri, 10 Dec 2021 13:05:02 +0200
Message-Id: <20211210110511.98856-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210110511.98856-1-tz.stoyanov@gmail.com>
References: <20211210110511.98856-1-tz.stoyanov@gmail.com>
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
index 23733194..1503e2bf 100644
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
@@ -760,6 +783,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.33.1


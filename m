Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA8DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5994A61268
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233909AbhKKPPs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbhKKPPp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:15:45 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275EFC0613F5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:56 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f4so25358344edx.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2pB8ZvqNIlqoaTXy8qeSvxTG+PBih+zcah2HllOhwAE=;
        b=QY/DK3MaIOJeFcnJelW84JTPn7y0Ec2krugmrpQJi08vE1gnN3KjN57he20KlKtd5J
         PUe2+wswQWd2IvOzJeLcnXrhvmY6TnTMvmj7F8rBghe/fSUHNT8I8CjfgDYgb3gn0wiw
         B6PhruSFfYMi4c52WNJ/JPF+5D8yiLOViyMYMTvZzqip4dDu1FBAPgdu2jCcK51M711E
         jnEq7T/2QGnmJG0uxp+DhyIdTZfu2yRGy9wQlG9zvpmvs+F0QlMwHf4HK3UxhXrv7To4
         w2H8Voi92B9Gk50X0Hcq0csh2g0m5eUNUsHkSKxM1Jnf4lxBC5qRR2stQSkdHwJdoeT8
         6crA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2pB8ZvqNIlqoaTXy8qeSvxTG+PBih+zcah2HllOhwAE=;
        b=urXSgrOjxyz3aImlyfAJJdAP5QzGaQ+Uavi4l+R4AlyDbrxbKndhhNuujEjYa0LEaN
         2LBn2pftoBZobA+mSuvq7jmh3fX5bhVIkq4uVQpGvVH5FdFjyvu4JsQoypLMCYye6HOE
         PeV9C4g4FqLfV8ZcCOVC4watc5eZseLorE6f5UAqYCVGocVo2MdsU+93YEJdlU/atT9L
         ohMhFdSFYOjYyrAnZW0L+uge9AtybCFPVhGQ4HYNDUfjvg/4YXprxm5bTp8eInADAsPv
         Nf+vq3QPMq93JCpsKEXvkLfruBY1HJy0u1MRhIdBJObtkuEMKUhduDoemgUvk2XhT5aV
         Y+Og==
X-Gm-Message-State: AOAM5303QVRn1c1dFF6o2wGy11Kai9vXqBwl/pceBUFuxoEoAxHHUDzd
        jcwIsdEats7RwPawrBrsLNMtFpuILCw4Kg==
X-Google-Smtp-Source: ABdhPJycdbmX1pKPpxV5CSsGwyeTkyVrMrycGICnOBngUkK9fhzmGRSBpC3GsSYK6Z655wsXJyNKJw==
X-Received: by 2002:a05:6402:1d9a:: with SMTP id dk26mr10778891edb.222.1636643574732;
        Thu, 11 Nov 2021 07:12:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q2sm1443375eje.118.2021.11.11.07.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 02/10] trace-cmd dump: Print compression header
Date:   Thu, 11 Nov 2021 17:12:42 +0200
Message-Id: <20211111151250.87023-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151250.87023-1-tz.stoyanov@gmail.com>
References: <20211111151250.87023-1-tz.stoyanov@gmail.com>
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
index 75e40911..a1fc6d7b 100644
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


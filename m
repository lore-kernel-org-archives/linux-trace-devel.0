Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EB7C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C056F610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhJHE3B (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhJHE3B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:01 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B37DC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id a25so15512072edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XuGRDg06q73jbPgmeD6b8pH/4xE6jY0heKZ3XoehWA8=;
        b=LFiDll08LDr1FV0D8xbpaSZVV8K62vYA2mA2UJvquCpL49gLWkSLlUTbNIIodA051W
         lvub9whCH7P30kJZ7s+4hx5k5mb0uYGcCDtcEgWD+4iolO6NRKtuRAzG1yyRFNsGjJYl
         KU0i1xrw1RzQ6ciefJsltDAsvie34dmh56QGm3HwfR5FJ6C5ZeOV3nJfBBI7MnMD7gTD
         IgclI4n2i3sieEfINbuPzxeWido8uCwogKYclmuAGVQ7dHEiyvxcf1f3nk6/p/4JKSIE
         BhcLgzx60aeIjT+I3//S2P4sgbr1ewFrPZGMvBfkvvEoCUONadDc374VMDqi3t2lN+xz
         XFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XuGRDg06q73jbPgmeD6b8pH/4xE6jY0heKZ3XoehWA8=;
        b=dbIYy+YBJ3WZzB6mQD4YD71cP5ExsQof/pQwAzsL3kfdIPPWhBpeafVu2/v/BL/rGs
         SDnA/jW9ykALucB620JmeypdWSvVHh4uOJWOqbixi9hDZW6hgyOkexfJBJUR2I21/O7n
         iApLh4lCUrBsk9MlbMz/iJss9BI0Kezlzo+bVQ4iBOcyRDEvRuYwoPWnlPavovFz66V9
         FymOaAf/2U4SttH5ZyVv5yn34u4v1P6uvg35tBcVklhNQBLRKbzW8OlEPATLR1gtGtyY
         bTig0MW0FIsc9ElPFwVaT/s/asL71k+SP1wNS2wWoGh++rRgXY726MJqyYUeoyeEwMwy
         3oYQ==
X-Gm-Message-State: AOAM532lmJNMqxCblcIdMdipNy87sIAnEnd3u+9Jb+aSGQzsvUSGvVwu
        93LGcpmecbLp+vC1JwwUFAmRx6vUSw5Nyg==
X-Google-Smtp-Source: ABdhPJwdhjNGs5i0OC3W/o6TlXw/ZQZR6okQrwDGTGayjQJ0n/BRiT5DiHLGFAyoWD9amIkUCyEF+w==
X-Received: by 2002:a05:6402:3088:: with SMTP id de8mr11936986edb.76.1633667225221;
        Thu, 07 Oct 2021 21:27:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 02/10] trace-cmd dump: Print compression header
Date:   Fri,  8 Oct 2021 07:26:53 +0300
Message-Id: <20211008042701.979075-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
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


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A70FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352484AbiASIa2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235211AbiASIaZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:25 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6D9C06173E
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:24 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id f21so7516367eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fuzogmPA1cNlbPNA80i95aTJkAS7oOOClLtr8KSBmOM=;
        b=A0Ddu0dQzm34B1qv1E4SjjW5LHZoYgahMeZ+qqNJM9/T2gEeNCKcoaAdUb6CRokxuy
         Irws909ZydANMB52zqgKQ4pEF6IrEegm+SetkjcWjbe6q+rahnrTL52SG9GMWGXIamkv
         eIXXZfGQL9uhAPk1RDbONJNnIw5kbvn9pO6rYuWq9lSdXcoREGAcENG1PPBiy/wOiIgK
         i3Q1joi9ut2agyoaJhfR2Cia1RrPtDfgf/iJ6xc4htAp1OKJDQRHtuNVpm2ve+wUAsFc
         its6djyQpqGT9yPw08cD4j2unmnHVzGHgMysxYm4GGgKXz0GlM+0HjIAgU0lf7yLIK0N
         HWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fuzogmPA1cNlbPNA80i95aTJkAS7oOOClLtr8KSBmOM=;
        b=NRrZQVFhKuuiVQ6saGrZUess1n3TYJKWGCPHiU42BJuHOqVLKMVkMArDSThnnS8HwK
         y92p//Eq6RzXrnToyNX6Gauf1CX9TdbsD7EFiQaqvniXy0ftMr9DonqD4cDppkoa0/ZQ
         Q2uwRN7indfw+oxPxXI9IwvRhVKScv6TlLBX2VOD2wXE0BtSYJ10V12FEDmRTjHDjE5w
         oTgR1Feo7yTw0aC+msFRg64/X3BHYF2EG4Wv/yRfCTm/fHBbJaNsVkSx4EegK4016/tL
         EuHHVDewBTq/TW2rAASObI0gWdnUlNgVC1XJNG00zPxIBM8/15qjV/4CXoQ7AfyLsiOZ
         W3Iw==
X-Gm-Message-State: AOAM530lNMKkiWerSieoUwQDURjrxzlSn8gBhyOv676FduG2EVFagZmz
        8Sgz+Y+MR34x3MwQ8MBkIQaYzfqZebE=
X-Google-Smtp-Source: ABdhPJx3nvC2zCmuudfHRu7rN3mbGgOG/bWpRunQXcNaGAtgQnsS7hMBRi41PldLbJF3/9faNSJbAA==
X-Received: by 2002:a05:6402:22a3:: with SMTP id cx3mr1198496edb.269.1642581023174;
        Wed, 19 Jan 2022 00:30:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 02/11] trace-cmd dump: Print compression header
Date:   Wed, 19 Jan 2022 10:30:10 +0200
Message-Id: <20220119083019.246153-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
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
2.34.1


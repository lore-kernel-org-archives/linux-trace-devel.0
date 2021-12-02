Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1088C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346826AbhLBMch (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbhLBMcf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:32:35 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311FEC061759
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:29:12 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id o20so114625972eds.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2pB8ZvqNIlqoaTXy8qeSvxTG+PBih+zcah2HllOhwAE=;
        b=Pnh3sMYCwG5q99AVaU+lui6MYmYvZ9Z4iLOWMqKPYV6T6mr4LDD1hIodYzZmKqsCOI
         QbqcYB/V0ZbEfqXm9OPkeR+J8IDgR6Uf5DM7FVZtXPDWZoI/e1DrCSTKdp+wgPifcOEx
         BQdOa0hj3vdBnF5MboeLBM9WcD7yKLpk/E86BvNs8JWbtZde8cPDBaeOlsowGqbcJ3Ve
         AKuOnZBge7ih3y4f8ARk4dPh24ONjdwXxCS7XW5liJ/LlZ1e7f5SO0jqTkJyUt6d4OEY
         aV0pcPmlCtIG05jfmbXbIa5Ms3dNooePtXeRWY+FCKhz9XE6DnKl5zqzPPnn6nSSXHSu
         xhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2pB8ZvqNIlqoaTXy8qeSvxTG+PBih+zcah2HllOhwAE=;
        b=t+g/zxQcsUHqQcNNJR0I7Zj3B7yV8sMfZ+RkhtRnck/1bFPK2MNhog2fCiZNh2J/FQ
         xFTpqTJpovQ9WlbwWXGZL4pjLVEh8uot4hcHHo0XlxUUzjLBv4SRCl+/SL2RckV3RurV
         1oSv012QsU3PSfWNr0yU7hagtA32qsPsCmLMod5CoRr7V1VXd3GtG39WbBr87CygKHOw
         sz3ao5Qe/ryRGhoXAu9/y5ztaxeEmWJfq/NnrrUoMNskdmv1SJpwAcO4YkQFdEoD5ZOU
         zJjtW8aU2xTaShDunRj1dAGUUnbH3b35Z3VW/t7bs3zF7XINKga5OMgT+FmeOBMM6vvx
         3KEQ==
X-Gm-Message-State: AOAM530R1nteg25B6hSG0vd0P/1jAgLg4iEC0TX2Z/CaQdBulF8qvRNO
        4VZ1gtnIap1TEiJ9w1r/h4vigo5izGG4+Q==
X-Google-Smtp-Source: ABdhPJyeEUXFU98CB//5UMjs+bsaGKVNGx4iNFJEURvJWkyEBSEzCnh8cyuSiXCxtP2hxXqizBAkGg==
X-Received: by 2002:a50:fb16:: with SMTP id d22mr17608481edq.367.1638448150814;
        Thu, 02 Dec 2021 04:29:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id m16sm2182692edd.61.2021.12.02.04.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:29:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 02/10] trace-cmd dump: Print compression header
Date:   Thu,  2 Dec 2021 14:28:59 +0200
Message-Id: <20211202122907.44008-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122907.44008-1-tz.stoyanov@gmail.com>
References: <20211202122907.44008-1-tz.stoyanov@gmail.com>
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


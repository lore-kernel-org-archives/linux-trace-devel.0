Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E13C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbiAZJxq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJxq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:53:46 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB1FC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:45 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id j2so37404985ejk.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DuNMznTqCVZx+zCPX/g816HeHkZU9bZzT+abn/p8vqc=;
        b=orkKQvmhm6rkRlhgeBTaTW6jwCRt979a4VNf+RdikXO7fHmmNU7kPbkzr+z4ea1I7S
         fOeVcV3ezqEmA8AjDwV/p5M4hnmJTgZ6138sG6qLpjp5TZqI6LNaGJQs1ybtWiq5hIvG
         8gOCD/cl0W8HFvfB7G6RIzrY7UoQRu1pUq3fjepB45i77JbwbUQf59snLdBMv0E1P4rf
         rIuVKJ0+BuWRbVts4lp38+S/5QuOiqT8Yg1alaARm4ufCng9oPVBpcZZYsrKb/bvwY5i
         fPv0b2ytLjXsLTV9OL+CcmdWw9qcyx+VOTCF4xigu/1ivBI5QY2xTQhZwNodoodinNzi
         7WtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DuNMznTqCVZx+zCPX/g816HeHkZU9bZzT+abn/p8vqc=;
        b=x3M1J0M2WCizV2RXZRs9eF0HK3JYJ+GisijfRtOxNqq0uN4Q+pl9xc07Xw3rfm4Qo6
         i24Xf3ajwFPojb/Ht49XSGWv4cRlpsKH6nTXKvACKtKvzdFNHKXLKPlYvoRlXAa7htBt
         qYe9zjLIXkCFXYmFeah1++m9CgIE8s6BDVpCcb5wE5R7T52J9iAkQySE/Az/BKflABB9
         jGr9SAa9oO1nX+3o1n4bpOBWjCc4k56fOvj8mTA20S7lSgoX6CT2Ua7QIMeXcHcFqATZ
         143J5+O32sdftdP9vbEwAPK5i8S7QoY20LosZ5+r5l3CNto5vSrVKx0RYT/mhaRJHg8N
         4v/g==
X-Gm-Message-State: AOAM530+SZ2Zlwj0M8JCAr45emNtT+RKHvjN7k1UZei+S+y1ZoEztaBY
        LCTPUK1BjYxLjbGhkd9tpCvrCCe9NPI=
X-Google-Smtp-Source: ABdhPJzsHXhssbEA7KNndEumflUoi8/2vkedxe5yR9sF6nVGh8LEmiz5TcGkgKSEDPqnhhXDrpBCTA==
X-Received: by 2002:a17:906:7948:: with SMTP id l8mr19072487ejo.636.1643190824117;
        Wed, 26 Jan 2022 01:53:44 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id h19sm3177266edv.90.2022.01.26.01.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:53:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 02/11] trace-cmd dump: Print compression header
Date:   Wed, 26 Jan 2022 11:53:28 +0200
Message-Id: <20220126095337.570867-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095337.570867-1-tz.stoyanov@gmail.com>
References: <20220126095337.570867-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Dump the compression header of trace file version 7

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index a99dbded..6dad0fef 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -219,6 +219,31 @@ static void dump_initial_format(int fd)
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
+
+	if (read_file_string(fd, zver, DUMP_SIZE))
+		die("no compression version");
+
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
@@ -763,6 +788,7 @@ static void dump_file(const char *file)
 	do_print(SUMMARY, "\n Tracing meta data in file %s:\n", file);
 
 	dump_initial_format(fd);
+	dump_compress(fd);
 	dump_header_page(fd);
 	dump_header_event(fd);
 	dump_ftrace_events_format(fd);
-- 
2.34.1


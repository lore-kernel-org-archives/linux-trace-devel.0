Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50817C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3747D60F35
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:27:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhJHE3J (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhJHE3G (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:29:06 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC0DC061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:27:12 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b8so31260194edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XBqB9KoV1o24qWOyKjje4CKxWGz3YUwcOPKCLKEWJ0Y=;
        b=CVXHdjH25KUOG4GahXq++k9+wwBiZivR8aCQnQlW5em8udhy7GZs5N33DGrHNG/jF8
         pqnn9CzUc8UDQMj4lBIYCbM2YsrZnHhcRl3zgMb73YGkOUYQaGubCE/CfLnFe8uB0TBH
         K6xHX1QE9zZ7H2A+MtS0R1zjOju/GZ/LI++MMFLFj1+hjmyGWjLMgWQ6N60zcuG2LY1C
         NMLuJ73AQIWWNFQh575OcCPE/74WZVKpdP4+xrwhiFyQmjI+Oz1LO8FyVRDmI0UnWJjd
         zkIYgXGEfB/NRCHYLDb779oEQousN1a3+K2/PxEsMgyR05w5UGj/vuE4LIgE+pRSmkMo
         uAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XBqB9KoV1o24qWOyKjje4CKxWGz3YUwcOPKCLKEWJ0Y=;
        b=gd0aIHmDDG9TjuM6mcUkmqJMez8vhyU8yA+hbUiO2yWzdrgX3T/ZotLTXZ46LLoXa+
         +MRYVD5fwQB9NT58Fv41xGYlxhZez+q45yCtCAoUoqDllfUVDEhgIW1ThgQ01ctcBNmn
         17809pZ6kRVxUjr90zPTc9BdpMvKvI+8ODuH8KVppbXxPAJCG9krUh4RORQA53rQwsP1
         PKJqijGRH7UoVUXpQtW1xQ5qfYKzW82B5nDnwGGtWZc5kOk2s08Pt8uBd8u7BpZN669w
         eDR5QZ4Azzw0KBQQnhDLyKdJIer9vn2uz+VARgmwW1YdMue3gjhgymli4HnGQsjkIsiq
         HtRQ==
X-Gm-Message-State: AOAM530uGXxbBBcW+CvNhJ0/ZMtzR/n9jemgtRMvDW16Ns6LXQ0IV7lL
        kDm0wdOYf9TYGYvD+55/fRnrI6+vuQYt/g==
X-Google-Smtp-Source: ABdhPJwo8GswazwvkbHun2t0WBggA5Iu/QJkEVb3cpdvc+6oozNQKSF5zJY+6O5XAyjJ5IPPqCkcZA==
X-Received: by 2002:a05:6402:142e:: with SMTP id c14mr11823556edx.209.1633667230720;
        Thu, 07 Oct 2021 21:27:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q6sm456536ejm.106.2021.10.07.21.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:27:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 07/10] trace-cmd dump: Dump trace file version 7
Date:   Fri,  8 Oct 2021 07:26:58 +0300
Message-Id: <20211008042701.979075-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042701.979075-1-tz.stoyanov@gmail.com>
References: <20211008042701.979075-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has different structure than version 6. Separates
parsing both versions in different flows.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3394847c..44f103d8 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -884,6 +884,31 @@ static void dump_therest(int fd)
 	}
 }
 
+static void dump_v6_file(int fd)
+{
+	dump_header_page(fd);
+	dump_header_event(fd);
+	dump_ftrace_events_format(fd);
+	dump_events_format(fd);
+	dump_kallsyms(fd);
+	dump_printk(fd);
+	dump_cmdlines(fd);
+	dump_cpus_count(fd);
+	dump_therest(fd);
+}
+
+static void dump_v7_file(int fd)
+{
+	long long offset;
+
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read offset of the first option section");
+
+	if (lseek64(fd, offset, SEEK_SET) == (off64_t)-1)
+		die("cannot goto options offset %lld", offset);
+	dump_options(fd);
+}
+
 static void free_sections(void)
 {
 	struct file_section *del;
@@ -911,15 +936,10 @@ static void dump_file(const char *file)
 
 	dump_initial_format(fd);
 	dump_compress(fd);
-	dump_header_page(fd);
-	dump_header_event(fd);
-	dump_ftrace_events_format(fd);
-	dump_events_format(fd);
-	dump_kallsyms(fd);
-	dump_printk(fd);
-	dump_cmdlines(fd);
-	dump_cpus_count(fd);
-	dump_therest(fd);
+	if (file_version < FILE_VERSION_SECTIONS)
+		dump_v6_file(fd);
+	else
+		dump_v7_file(fd);
 	free_sections();
 	tep_free(tep);
 	tep = NULL;
-- 
2.31.1


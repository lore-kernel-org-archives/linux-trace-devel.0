Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875BCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Dec 2021 10:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbhLMKAc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Dec 2021 05:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237595AbhLMJ61 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Dec 2021 04:58:27 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CA3C08EB20
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:29 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e3so50741458edu.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Dec 2021 01:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DhRx6ewN7MwnNiVVmf6uS+ga/E3172l7ca+KEv51r0c=;
        b=f2O1H5UCDK4mNC8YaTAyrF7SEQygYHa+KRJtzvsqdk3ZBJlPEAk86/K/oKJpDRKYeQ
         vn87bAK7pzbBnY5aB/mmkniKiC8hiwDGRw8MaR6tMlcI2wQQ9N5ydcCf59zx06Qq4mkK
         MNort9v14EHdDji+wwjq60nXgazrWC5VhAgC+KAtPHIKrNNSxNulNbgPl5VPvxom9Ckt
         H15CopMdXhJz9HaIJsMAvtFa4brKYjj4gpcx783OuUgtZ+P3apA3OikW6i640ZLbfotP
         6BE4RM4IGZFeyIW42g9sRdZ+AbKIOTNEogPHlqAwO1wLMk8SQ+iGonBj9Lvv2/VVjXV/
         Stzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhRx6ewN7MwnNiVVmf6uS+ga/E3172l7ca+KEv51r0c=;
        b=mPuP0trwCU6b/S84R8157ntyrM4u6KJmipXWz3ZH6MTi7MYYQn2k5CVLF7mh0Lggnn
         fH9vM++h1wCOZUsrw49xG2BKwLi8ZEuuclnAQ6dtJYD3d9f2VphIwhMWc6GCHw7wAO6S
         qQ3haFnnvP7u9q5CSqi/EgBFlVxr47Ij+/sOdIbiahN/cKNEu+XraC/TBV3IfT9+YrFv
         +OMgQoMthDkCzxzitrA9pufUqz21NgjKcKxRHB5rlihYCxAWmA2ABR5RFWEbSFbOVEDt
         ET+mNOvol3vWDzQyFRmetFtXxX8FqCckJao877cNSNB4jFGjsY5YS2m8jIyTOZlbsKVe
         pq3A==
X-Gm-Message-State: AOAM530kp4P2HbMLg00RxJNJiKWuupHEEyF1ctsGRA9evEt2FecHbnOC
        dOwSq34vnuqSlpXy0xqT2bQgEI2tGsA=
X-Google-Smtp-Source: ABdhPJyNIWpQjFQvKXAYDGplc/K/i3bSsvGNl7ijof3lqjbvOJTDZz6B1oo7SAwgkSWOnxqRRCdHAA==
X-Received: by 2002:a05:6402:3589:: with SMTP id y9mr65485936edc.44.1639388908566;
        Mon, 13 Dec 2021 01:48:28 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id yd20sm5465748ejb.47.2021.12.13.01.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 01:48:28 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/5] [RFC] tracing: Refactor ring buffer implementation
Date:   Mon, 13 Dec 2021 11:48:21 +0200
Message-Id: <20211213094825.61876-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213094825.61876-1-tz.stoyanov@gmail.com>
References: <20211213094825.61876-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to introduce sub-buffer size per ring buffer, some internal
refactoring is needed. As ring_buffer_print_page_header() will depend on
the trace_buffer structure, it is moved after the structure definition.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 kernel/trace/ring_buffer.c | 59 +++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 2699e9e562b1..cc34dbfdd29b 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -371,35 +371,6 @@ static inline int test_time_stamp(u64 delta)
 /* Max payload is BUF_PAGE_SIZE - header (8bytes) */
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
-int ring_buffer_print_page_header(struct trace_seq *s)
-{
-	struct buffer_data_page field;
-
-	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
-			 "offset:0;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)sizeof(field.time_stamp),
-			 (unsigned int)is_signed_type(u64));
-
-	trace_seq_printf(s, "\tfield: local_t commit;\t"
-			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)offsetof(typeof(field), commit),
-			 (unsigned int)sizeof(field.commit),
-			 (unsigned int)is_signed_type(long));
-
-	trace_seq_printf(s, "\tfield: int overwrite;\t"
-			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)offsetof(typeof(field), commit),
-			 1,
-			 (unsigned int)is_signed_type(long));
-
-	trace_seq_printf(s, "\tfield: char data;\t"
-			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
-			 (unsigned int)offsetof(typeof(field), data),
-			 (unsigned int)BUF_PAGE_SIZE,
-			 (unsigned int)is_signed_type(char));
-
-	return !trace_seq_has_overflowed(s);
-}
 
 struct rb_irq_work {
 	struct irq_work			work;
@@ -559,6 +530,36 @@ struct ring_buffer_iter {
 	int				missed_events;
 };
 
+int ring_buffer_print_page_header(struct trace_seq *s)
+{
+	struct buffer_data_page field;
+
+	trace_seq_printf(s, "\tfield: u64 timestamp;\t"
+			 "offset:0;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)sizeof(field.time_stamp),
+			 (unsigned int)is_signed_type(u64));
+
+	trace_seq_printf(s, "\tfield: local_t commit;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 (unsigned int)sizeof(field.commit),
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: int overwrite;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), commit),
+			 1,
+			 (unsigned int)is_signed_type(long));
+
+	trace_seq_printf(s, "\tfield: char data;\t"
+			 "offset:%u;\tsize:%u;\tsigned:%u;\n",
+			 (unsigned int)offsetof(typeof(field), data),
+			 (unsigned int)BUF_PAGE_SIZE,
+			 (unsigned int)is_signed_type(char));
+
+	return !trace_seq_has_overflowed(s);
+}
+
 #ifdef RB_TIME_32
 
 /*
-- 
2.31.1


Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7AAC2D0EE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D992072E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/3GjLZB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgC3QH0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:07:26 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37368 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgC3QHZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:07:25 -0400
Received: by mail-lj1-f193.google.com with SMTP id r24so18726965ljd.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Nv98FMZeYOyy4jWPQ3hjKcfqW2wE9ocQVzMSiGDpvQ=;
        b=H/3GjLZBbqBs1SrH4fTc7ox7FQAdsYCpCEv2Ag+xLRVA43gwJY/AIXYcbIEp7u0RBn
         1Umcj+8IMTsYkdw0LOEAJ3enhQQwGjl9yR7jGvUMxDP3s6D0gM6vGikdyQllC/CpXWf3
         ElCyLAy0JL9k6hSY0gBOjRcltodj5qraCn7pbj/bGEMXRWaLJm1l3fHToE0J87gYSc6R
         VzkH9av+Njs4ueMLGaHFrmpylvrbPmUN540QxwGnRuNI43jsZxNx/g90bmfGmeUs+on/
         RMtd/8o8xjLvYf0yj5QuwTrdnvOfBqGGsfdgQKoT3A3wLxzfv9h9TA9EaCpUOs3L8Tch
         KrVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Nv98FMZeYOyy4jWPQ3hjKcfqW2wE9ocQVzMSiGDpvQ=;
        b=V9KMR/BOUmLFt1SrZeO6l+WWkfpJbFJI1BhJnLUKu21w/yg14gV3SL0KTbQbipdK+T
         1mtoPLEAI8+uBNxPYkEpAmNq7D6ziCHgWOjg4HQG7o7OPETGa5+1bLPZE0jK7mxbyj0h
         j4MsCtCQ21MBfCODip09F2A1QnzBn1lvXEuit1R8qsLswMT7qksjSU8nDoKeTDwroxbv
         CqI06Bb/JRqKvbmrXKx/TEPiiVZ9g+IgicbbRPVD/ozEK6do7bkSpJSFGchXWxwDvcgx
         RFVc9FBC9yha/UD6j8xBsX0ApCTyHNU/pxy/UF7jNF399bMWxvYVHvH4ohoGJ+gpT10p
         mEtg==
X-Gm-Message-State: AGi0PuZjQaU9IQX8NW6h5K44MBV/X+hWNhdFCET7uOfKPLfUwc8xxHD7
        g+ZPk2he0PZyeHX+55Gy+HI=
X-Google-Smtp-Source: APiQypLTVqvsstHjGLtKAfzULt5jtevUdjUoSo4MnXvUmdl7UgaGRcscxk73U8mj+iAvTcpJWtn/EQ==
X-Received: by 2002:a2e:884d:: with SMTP id z13mr7771902ljj.158.1585584441855;
        Mon, 30 Mar 2020 09:07:21 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id x28sm5876123lfq.46.2020.03.30.09.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:07:21 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/6] kernel-shark: Fix bug in bool kshark_export_all_cpu_filters()
Date:   Mon, 30 Mar 2020 19:06:48 +0300
Message-Id: <20200330160652.28424-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330160652.28424-1-y.karadz@gmail.com>
References: <20200330160652.28424-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It makes no sense to check if a Task filter is set, before exporting
a CPU filter. This is most probably a copy/paste bug.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/libkshark-configio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/libkshark-configio.c b/kernel-shark/src/libkshark-configio.c
index f01a39b..cb7ca54 100644
--- a/kernel-shark/src/libkshark-configio.c
+++ b/kernel-shark/src/libkshark-configio.c
@@ -1407,12 +1407,12 @@ bool kshark_export_all_cpu_filters(struct kshark_context *kshark_ctx,
 		return false;
 
 	/* Save a filter only if it contains Id values. */
-	if (kshark_this_filter_is_set(kshark_ctx->show_task_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->show_cpu_filter))
 		ret &= kshark_export_filter_array(kshark_ctx->show_cpu_filter,
 						  KS_SHOW_CPU_FILTER_NAME,
 						  *conf);
 
-	if (kshark_this_filter_is_set(kshark_ctx->hide_task_filter))
+	if (kshark_this_filter_is_set(kshark_ctx->hide_cpu_filter))
 		ret &= kshark_export_filter_array(kshark_ctx->hide_cpu_filter,
 						  KS_HIDE_CPU_FILTER_NAME,
 						  *conf);
-- 
2.20.1


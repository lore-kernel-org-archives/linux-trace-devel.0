Return-Path: <SRS0=DKMX=5E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3ED1C4332D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB25214DB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Mar 2020 14:12:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gWVgQfSv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727763AbgCSOMp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 10:12:45 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36537 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbgCSOK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 10:10:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id g12so2661494ljj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Mar 2020 07:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Nv98FMZeYOyy4jWPQ3hjKcfqW2wE9ocQVzMSiGDpvQ=;
        b=gWVgQfSvhOXpD+LZV+ydqMrEwfzBEV2wUVDjjIla1mz9tB+B1FCXrQh4EndgV7Ewi2
         jGTEQkzLX6iEGqLA0x7JW/xqx69GT34nTDXNf/tJqFdncZlr5Zi768r2m0BBd+uJ6/Ph
         Yp4BdstcJJiOK9gKXy41UL8lx/uiT+2rhIZE9GCzHtkqe0dj/ulzrh7XxOdOCQkX3EhO
         IWPcvPaYI++QpFf/x+gVlG5OY1N2AbS8pmPyW48CuwegnXZHA2OaxaKvnuQ3mP6zGbd+
         okCoO6Fl98DyM5+wK+67uwIYwt/BeUrUH+N6n/NGYgn79WydqYaKH4vNeAjD+IJR5ycn
         n+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Nv98FMZeYOyy4jWPQ3hjKcfqW2wE9ocQVzMSiGDpvQ=;
        b=FfsKIng0GfGYwt3M5TLLyG0YstIVWdH4ldiLywFbw3nQV+6qcKJwbqBB4nncidfNRV
         pCvVY5G7mSo3J/Lv5iKTewJPaROxIdVy7pDTCcmktskAAx6Snrvnkx9clrjST4IwLf5Y
         JjcXExvIrV3/Kpo3cLzsIApiuZIJ5EobYyqHp2zitUSgyLb7/XOR4ZAIVlEBup0QGhsY
         aKON360a5SbN6Yk7XvCm8NqFcThJZN0b7lExETc94NJeCrS+XMMeJC/HGYUva+B1Pqcc
         egKTNOMTjtuqKjmZpXgDmV+oWUGRP2s503k/x52D1T+wIH9vRO3LaP+XSvVeRSgM06LO
         gB7Q==
X-Gm-Message-State: ANhLgQ27MSbecyGH9ptl7AVVS+ih1KnkAa0HXtMcwDfU0HZ2r4Bp8C6m
        mGl32CWnXzpWy7tCX39+w+w=
X-Google-Smtp-Source: ADFU+vvXJWUx3vd8c5mGfupKGFEOHA9e15u6U1qY3Fxp7/mqdG2gA+azVlKjH+gbqP236J8HR1f/YA==
X-Received: by 2002:a05:651c:233:: with SMTP id z19mr2161827ljn.176.1584627057532;
        Thu, 19 Mar 2020 07:10:57 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.223])
        by smtp.gmail.com with ESMTPSA id u14sm1817605ljj.54.2020.03.19.07.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 07:10:57 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/5] kernel-shark: Fix bug in bool kshark_export_all_cpu_filters()
Date:   Thu, 19 Mar 2020 16:10:28 +0200
Message-Id: <20200319141031.3774-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200319141031.3774-1-y.karadz@gmail.com>
References: <20200319141031.3774-1-y.karadz@gmail.com>
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


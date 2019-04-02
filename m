Return-Path: <SRS0=t+9I=SE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB886C10F00
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FFE2133D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfDBNmn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:42:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54257 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731640AbfDBNmn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:42:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id q16so3465325wmj.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 02 Apr 2019 06:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iu4Fyc42UQyrYE5Tk++BlWaRY8br2iwqhsYk9tm7HOQ=;
        b=HHw21U1ti0WLPzQnzbZh8OFFrz0LBGH/7rGYx2tgZWDJFcFGixOHhhspuZzXMyi8A+
         ppPrQQIPb8FjdsQ9UMf8LzGP9sWEEch0gGI8VbpGyNYH2S9OHusJmkc77Sk5WC8G1BgK
         Pkmt9bABxSwzafho14RbHrZRsikZZ03XXVbmsZnjKdtS9hxlYjjCX6CzhcGAgiWmBXu4
         etIejPhijYJqTbRHUp3rqlZ3Xiv96Zyo1f/tPUOdjbfFC2UIDNWwavPF4QodYXEMN9yf
         NpYT+i8jaaydU7qav4ykloCB/68bhdj/V5OKBJ9v2bwznzAaHQ2Vkh4NmiHLycqvcGET
         NUgw==
X-Gm-Message-State: APjAAAV10Qcdy3dlHDWlr6LmmtsQDKSHGshgRDI/AGgAIMYKzMPF8Hf7
        p08n26UZbTg6rlbR5Bn9Kg==
X-Google-Smtp-Source: APXvYqzsbQfiDZemc3pcsu3BduwSqd39R7Q7qlM91zWq6kaavotGPVOoaVeZtiB6e4qqm6Angb3ETw==
X-Received: by 2002:a7b:cd93:: with SMTP id y19mr3892729wmj.113.1554212561084;
        Tue, 02 Apr 2019 06:42:41 -0700 (PDT)
Received: from box.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h84sm19207083wmf.15.2019.04.02.06.42.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 06:42:40 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     slavomir.kaslev@gmail.com
Subject: [RFC PATCH v8 02/13] trace-cmd: Minor cleanup in print_stat()
Date:   Tue,  2 Apr 2019 16:42:10 +0300
Message-Id: <20190402134230.30988-5-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190402134230.30988-1-kaslevs@vmware.com>
References: <20190402134230.30988-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Do an early out in print_stat() when `quiet` is set instead of rechecking it on
each loop iteration.

No changes in behavior intended.

Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
---
 tracecmd/trace-record.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 8beefab..88b4a55 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3106,13 +3106,14 @@ static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
 
+	if (quiet)
+		return;
+
 	if (!is_top_instance(instance))
-		if (!quiet)
-			printf("\nBuffer: %s\n\n", instance->name);
+		printf("\nBuffer: %s\n\n", instance->name);
 
 	for (cpu = 0; cpu < instance->cpu_count; cpu++)
-		if (!quiet)
-			trace_seq_do_printf(&instance->s_print[cpu]);
+		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
 enum {
-- 
2.19.1


Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F28C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0697C21479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 14:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbfBROzB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:55:01 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43392 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728893AbfBROzB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 09:55:01 -0500
Received: by mail-wr1-f67.google.com with SMTP id d17so4272380wre.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 06:55:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iu4Fyc42UQyrYE5Tk++BlWaRY8br2iwqhsYk9tm7HOQ=;
        b=thUG4chP4fie40RxZy4T6P810aBc7cyxMbEFGcdREw/T8ti7gxVetjpbPGVQqb8dX3
         XP7ES7pcuamwx968LUqg6K1HSyfDcINg+i8GGI0SvrpXJg474o3rUW6ZCzJ1ybrR65bb
         DAY33NCBmNAoqchUMUph+lh/msJNQ8dY3nopqVL01ZM5Y86xmC+V3AH22zPFnjhkBQ6B
         h01DYkjKxYfvoPefl7Y6F7WBnA+u8C2Neb4W/bU0xjWwTCkMfVzDEORnaRvFuYwhKwIu
         XFaKNEMtYlzgXjSfQuSLVF1lQ8dClRB8m3BZ5mzG6/NtrPiGtWA+bdEhCv08AprsqzUc
         zGJA==
X-Gm-Message-State: AHQUAubU+PswCiIuJmnWExlJSjViL+av0lHBHqXJYl62sNLvIqfTUx9X
        JjwjLS5uVhNxpcfb4T4NaAkal9U=
X-Google-Smtp-Source: AHgI3IYYHuq5lq/loQsx6l2aWC1q9c+7XH5rr+l5erDbOHyx2LUYtbY9pqRTfnwcWKTMFF745SyZVw==
X-Received: by 2002:adf:f70c:: with SMTP id r12mr16772266wrp.54.1550501699691;
        Mon, 18 Feb 2019 06:54:59 -0800 (PST)
Received: from localhost.localdomain ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id n11sm10172528wrw.60.2019.02.18.06.54.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Feb 2019 06:54:59 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@vmware.com, rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: [RFC PATCH v7 02/13] trace-cmd: Minor cleanup in print_stat()
Date:   Mon, 18 Feb 2019 16:54:38 +0200
Message-Id: <20190218145449.13360-3-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190218145449.13360-1-kaslevs@vmware.com>
References: <20190218145449.13360-1-kaslevs@vmware.com>
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


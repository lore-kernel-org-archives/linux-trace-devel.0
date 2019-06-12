Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933C9C31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A0D620866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 14:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390208AbfFLOVz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 10:21:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50236 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409256AbfFLOVz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 10:21:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so6789346wmf.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 12 Jun 2019 07:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8UZyUGAmhcsrg+rhLvYN5axZRa+lIfrBvi45c+Ubrxw=;
        b=bXwuCt20p/d9y83F8Ua/j+fjwwzanqHkwwjbuMVoAzl3gJQJ5MFvD+bEDiPXxT0C/O
         PHXwyUOjqJPt0nkJHhdCRh/DJAw1NDBJ6N3rwuN816P7ObujQMXFTG6L9SpbBaTbQPd+
         6SZI7BR/ekHu7SZ/ls+KFZg/FpkkA0tM6XCr0tPdFgOPOcBRTO/yZ33AFwMi7C1bGuXe
         n+KWGpiR42hDgHzV6aQxScSu6jy787jHbz7hGvE2A0DiXOHVPGTQo5wlUdltM402WO+X
         lkRJ369huAm5nnLERnUEFbYuDlMI4exMLrNXygmIYD+L0Zn8wmdVP1d3K3N9LCQa1lax
         Poig==
X-Gm-Message-State: APjAAAX4YwvES/miBFiIZ0cFir4XtCpiYSYLtad4nVNSrYwuyWoZ9lrf
        T3gytqciSDISfJP9TKAQUUY=
X-Google-Smtp-Source: APXvYqzOSOyOXtKbtdJaSOFO/QFaJDq0pvWXSqjJoFPHmYWQ4xujL6kJ+8EPkJufWr7KwSFCttK1PA==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr21530731wmc.33.1560349313124;
        Wed, 12 Jun 2019 07:21:53 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f10sm27624826wrg.24.2019.06.12.07.21.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 07:21:52 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/2] kernel-shark: Fix a bug in ksmodel_set_next_bin_edge() part III
Date:   Wed, 12 Jun 2019 17:20:53 +0300
Message-Id: <20190612142053.14439-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612142053.14439-1-ykaradzhov@vmware.com>
References: <20190612142053.14439-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All time stamps of the trace records are coded with 64 bits, however
on some systems the size_t type can be 32 bits.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 0cac924..dde64de 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -260,7 +260,8 @@ static size_t ksmodel_set_upper_edge(struct kshark_trace_histo *histo)
 static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 				      size_t bin, size_t last_row)
 {
-	size_t time_min, time_max, next_bin = bin + 1;
+	uint64_t time_min, time_max;
+	size_t next_bin = bin + 1;
 	ssize_t row;
 
 	/* Calculate the beginning and the end of the next bin. */
-- 
2.20.1


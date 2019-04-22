Return-Path: <SRS0=qNMP=SY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E02D0C10F11
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 12:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B36E720693
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Apr 2019 12:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfDVMiJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Apr 2019 08:38:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36784 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfDVMiJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Apr 2019 08:38:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id b1so4303519wru.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Apr 2019 05:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TrgwJK31jgx0rWZUKPw4AljyiD48XZrGq8Qjq19pa8A=;
        b=mS4NEixwuezWEzxKWfUIMlZ13RzhSF1uoNvFvd77eJ4hrr95PaGLGWvHOsTBmQTRy/
         6o4WZeU0Rzs78nNHLGM+4m7jKR7mO7LoguXOuIGXBxHlABHZWvTQXqnBNaRmoyjpHJfQ
         jpvVWs3HPuMwfchh5xXSe0aW+VHh09tiW9GxKisejl7oZ839SJZaL/Aq9pVtCCgEmvhE
         5Ev06r9Xv2ivGVXil7vdTku703S4f9u/Z8m8/WxIpTcC6h3rySoCMoSj/IBOWwZ11rad
         spYRsJU+LhjRTJv2tSXtwH9Ik3jAOxfEtCXLYxfDZKk4z6SknH0HpQNtylrd31AHKxN0
         3KHQ==
X-Gm-Message-State: APjAAAXmADCnqQM/hDi3JTAxD8vhzCMYgDGj0mw0Bqw2zjs40GZqL8Mv
        woeZI/N6gWWsKKfRE4iXSPY=
X-Google-Smtp-Source: APXvYqyv4stflsgIlqiNebmDUIIqagDD1493B7bWVu7fvGZ6NNV1JVKsFHGthjJs3K/DyWVQr1Isxg==
X-Received: by 2002:adf:db10:: with SMTP id s16mr13113501wri.181.1555936687514;
        Mon, 22 Apr 2019 05:38:07 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id s203sm20196773wmf.14.2019.04.22.05.38.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Apr 2019 05:38:07 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH] kernel-shark: Fixing the fix in ksmodel_zoom
Date:   Mon, 22 Apr 2019 15:37:53 +0300
Message-Id: <20190422123753.3821-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

if (zoom_in && (int) range * (1. - r) < histo->n_bins * 5)

The line above has two bugs:
 - 64 bit type (size_t) is casted to 32 bit (int)
 - Type cast operator has a higher precedence than the multiplication
   operator, hence "(int) range * (1. - r)" is a floating point number

Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Fixes: bedcff1165 ("kernel-shark: Fix a bug in ksmodel_zoom")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 29676c7..978cd70 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -649,7 +649,7 @@ static void ksmodel_zoom(struct kshark_trace_histo *histo,
 	 * Avoid overzooming. If needed, adjust the Scale factor to a the value
 	 * which provides bin_size >= 5.
 	 */
-	if (zoom_in && (int) range * (1. - r) < histo->n_bins * 5)
+	if (zoom_in && (size_t) (range * (1. - r)) < histo->n_bins * 5)
 		r = 1. - (histo->n_bins * 5.) / range;
 
 	/*
-- 
2.20.1


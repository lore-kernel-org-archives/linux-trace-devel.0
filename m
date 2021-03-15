Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 041A7C4321A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E696560240
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCOGTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhCOGSq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1611FC061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:46 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ox4so48578691ejb.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5QrahDd61JCNCC55JMJ2nPOG9SHith/bj5jUizrYN8U=;
        b=ru4RV9HbpeUuVASknsC4VZIC371/tr+BIwexbCZGkrnx0JX3Xomn4dXN2iBW34D4oJ
         Q36aa6bH6Ykw/zY2vzq1NPGcgANhdUnjt27kkqmuLueOdc8TGFrw8frImc+5HAJNsXvY
         e3gUfneIqPwORi7688htvP2s9+TJbYFwd+pziQoBv8XbY2QhgCXAUviNRTj0ult8vqV+
         k0+nRx9Bybr7eV2DVgIWtWTRSEaBjVMv8jVkFbFnNgnItE8tdukhsdyzmoUFKhLLbuQ7
         g3rzcbaOAM8LcFvmcp55uWykIbaXoylZSPWqrUeF8qxlXlT8XRrSMaDXIcEcWaerbJjM
         eZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5QrahDd61JCNCC55JMJ2nPOG9SHith/bj5jUizrYN8U=;
        b=fBhagNLsPnA6sVaWiWPQ5ZaCHixRdGpYEwYCwytrrnuXbenf9PyFlwQY6sDV5xmDUN
         tl95r+AKpXMSZpHe6BHvM0h4hRXKV/RMT5sWIGnJEEvTYe3nDLolGaBKoPpvDDmdBrfx
         Y4LhC3etWqKh3yVNkFnKgEqRMrwFu1Bb9bY5hlDOADixdLsgD0DjeU38Mkmd000oiQEL
         MEQP9/FhAj2XIYPqCk8/3OzSmprXcdZIQMS4zUtwmQUyPtSdbk9NU+bppXKbIAVEL+IE
         GykycxxavdFzxz8uJc2IwoAtrmpyVKo0Bg7vtQerd4T/PTOKLDY8a3sfr3N6JpYCE6da
         V/mw==
X-Gm-Message-State: AOAM5339NAK054Y4Uus2xll2sg0r6Yqgq5oYw4D7w7Sq8THRNHsp/mxz
        VL/zhRg5XEFIbflmoxMAkHM=
X-Google-Smtp-Source: ABdhPJxrJoOueqxei/25Jeko4h6CMJXERhBJgL4c+YjFOos2ggqAdS0RKwXTqQri+HGte2yQOt/Luw==
X-Received: by 2002:a17:906:30d9:: with SMTP id b25mr21609137ejb.348.1615789124917;
        Sun, 14 Mar 2021 23:18:44 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/12] trace-cmd: Convert tsc timestamps to nanosecods when reading trace data from a file
Date:   Mon, 15 Mar 2021 08:18:29 +0200
Message-Id: <20210315061832.168495-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is information for TSC to nanoseconds conversion in the trace
file metadata, use it to recalculate the timestamps of all events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 65081007..dc9ac1d3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1276,17 +1276,37 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					 &host->ts_samples[mid+1]);
 }
 
+static unsigned long long mul_u64_u32_shr(unsigned long long a,
+					  unsigned long long mul, unsigned int shift)
+{
+	unsigned int ah, al;
+	unsigned long long ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = (al * mul) >> shift;
+	if (ah)
+		ret += (ah * mul) << (32 - shift);
+
+	return ret;
+}
+
 static unsigned long long timestamp_calc(unsigned long long ts,
 					 struct tracecmd_input *handle)
 {
-	unsigned long long tstamp;
+	unsigned long long t;
 
-	tstamp = timestamp_correct(ts, handle);
+	t = timestamp_correct(ts, handle);
 
 	if (handle->ts2secs)
-		tstamp *= handle->ts2secs;
+		t *= handle->ts2secs;
+	else if (handle->tsc_calc.mult) {
+		t = mul_u64_u32_shr(t, handle->tsc_calc.mult, handle->tsc_calc.shift);
+		t += handle->tsc_calc.offset;
+	}
 
-	return tstamp;
+	return t;
 }
 
 /*
-- 
2.29.2


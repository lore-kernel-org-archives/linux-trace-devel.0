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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE58C43603
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03DA664E12
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhCOGTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhCOGSp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:45 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EA6C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:45 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b16so3134441eds.7
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wNC9H0hPHXoToxr/gseEnC9/9164KvhD0GLDaTKzSog=;
        b=lPCSfkinGkKmKGIUWLl3duDDN0EQ6jRXhcDWaY+K870F4RA6B8lWQitXuEa1IfjzcF
         unR4M88SWkyVz0mCe9JoyHZ0CKdmNxx2YZet5tooc6U958oXmmJ94SugwCrTx/8bMmh1
         GoGUUvw/kK15nHFj0FtPEfUDxzeL5ZKhVM2Eq/uJNb6miXzMScPJoIsxz+uHQltB5dzO
         KPTh/Cj4Ypi7xi2VSa3Ay0W+EUk0JJJsayM3ZB5xiLUEd0SUg5mK58jhtE/ppeKcOmP2
         f7ANj3tTFhb6wzsb51gHz0PQs98eDUJv4HoIP3or/U4ENBpOwgAz3a78gsNphubSGG2a
         4xCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wNC9H0hPHXoToxr/gseEnC9/9164KvhD0GLDaTKzSog=;
        b=bs85KmX5vVCENwSQ5JeXG9LbhJ2cAGM3iR0OgE/6kE9aIuWor44Ltp+xaLnAlC3rA6
         oDY+O7QCVOa8JhzZUYBkQZdEkSD4GYRi9Aj+j7gKz5MzqGjSGCDf+ex7NTqXXREamkBY
         TOw7eT6Xp0chQksOUQp3RLtEYy6dDEq01W1fhNL0jWBuYutPCnYUPcbf50Iu9uxSUHB5
         4XX/b/Cad9oGX8+5QRqgyewwukkpDH5OMMFl7Tx8v97SP1m+5fLSdQ6kp9MuLeLZT87b
         r3cqlJ89U/pLqN4SY2HKWsp9kv0woYa8//s3T8pTRVMDjwxTX/0O3YpFwlqBptc/aUsO
         K1ng==
X-Gm-Message-State: AOAM531Vb2j+bRAmV1sQ70kaKQ/xevpaM2a8dNDp8QYIwjcK578L3Xvf
        eX92g95RZLmSzHSysLtrnpQ=
X-Google-Smtp-Source: ABdhPJw7sy1MAt7WCkO8DPiC5TKZgbhOwzj5+YiHgJE2rGSD498PuJUs5gXEqbR3sBkA1/r0k9YplQ==
X-Received: by 2002:a50:d71e:: with SMTP id t30mr27805350edi.58.1615789123922;
        Sun, 14 Mar 2021 23:18:43 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/12] trace-cmd: Perform all timestamp corrections in a single function
Date:   Mon, 15 Mar 2021 08:18:28 +0200
Message-Id: <20210315061832.168495-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading event timestamps from a trace file, there could be various
corrections depending on the metadata information from the file. Move
all logic that performs timestamp calculations in a single function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5384ad90..65081007 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1276,6 +1276,19 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					 &host->ts_samples[mid+1]);
 }
 
+static unsigned long long timestamp_calc(unsigned long long ts,
+					 struct tracecmd_input *handle)
+{
+	unsigned long long tstamp;
+
+	tstamp = timestamp_correct(ts, handle);
+
+	if (handle->ts2secs)
+		tstamp *= handle->ts2secs;
+
+	return tstamp;
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1297,10 +1310,8 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
+							 handle);
 
 	return 0;
 }
@@ -1930,10 +1941,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, handle);
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.29.2


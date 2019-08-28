Return-Path: <SRS0=sbuk=WY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7583BC3A5A1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C4EA2189D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:57:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JG6Z7Gxg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfH1I5y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:57:54 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40810 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfH1I5x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:57:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id t9so805768wmi.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Aug 2019 01:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJAVvyqSeoa1jAnD2+HN2Roj8blocYF3Ubt/w/PAf4I=;
        b=JG6Z7GxglODV+p68avG+73XPcrhgj3oQ8lEnHpbvry4Ex0rZq95XhLwNS4e1HUPfKa
         mUmQFNJ/NyukLkn29DDAhVGXiIUsN+pqPIFg2tE+28xABcL7sxLFj6Lz2YTL5Sij263S
         2+Pzeh6FdCpnGxePElKrFMh3TcFz5IBwUeIh9Y5SoAe5hpleLMPyE3jiFPIFh5LNNQcH
         4D5SdJQixXItITrUYIdqjBlsgRTmPvauZ3iKNmstnoFPvdDmta2MXp8+GQ5QA1fxNAIK
         a7tMZNTEin1f2+hIzC47mWkrmGYfv8NXu03unCfl5j6NPd6UP7z0pyF7eCco82ydbQd7
         nZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJAVvyqSeoa1jAnD2+HN2Roj8blocYF3Ubt/w/PAf4I=;
        b=pkZUSLAKdZ6bqwxDQD4KX1WulCWf2B3Lk8ZWkYAG+F5YyBDbNBpdZfhy/kdUpO+idh
         /vixuTdRRb1vVwjzS8LoHlm2Se/0hnnGPk9YHrBwa3OXqH77nL9iSktuFdiiZzgGCi3j
         YGUYXePiznKuhorpIMfJWtDF4hWNsIt7bkc87b0G88N7uvEs1FW2xUoDsuT5oT5GKRps
         rYGtpnhZcZ3gLtmUmccc0b4Y0tmZhvizImQl67YBsd1p3MdKV6Q0pYcjDouTsjoGaJin
         mqWiZprn+WQ8VThkhR3QctQhw/EvVrHFdhSDvoiGXfU7VLHVPXQWyEvX0w4FfDL8tn2A
         L/1g==
X-Gm-Message-State: APjAAAXoIOTw/yvpXMQTh9o6zwDVayaG8iDSsoLzG50RZgjzOf9Sfyv6
        kQ5jKn69cO2DTkeoTE1mjzuXoefj
X-Google-Smtp-Source: APXvYqxjdAKoC3a0p1bTDdAcbz8vL98NR9z7kLuc5KwLTCaxoZgpK7NY37hame73UXAAQV9L6+42Xw==
X-Received: by 2002:a7b:c95a:: with SMTP id i26mr3559174wml.175.1566982671606;
        Wed, 28 Aug 2019 01:57:51 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u186sm2579433wmu.26.2019.08.28.01.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 01:57:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v12 3/9] trace-cmd: Fix tracecmd_read_page_record() to read more than one event
Date:   Wed, 28 Aug 2019 11:57:40 +0300
Message-Id: <20190828085746.26231-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828085746.26231-1-tz.stoyanov@gmail.com>
References: <20190828085746.26231-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

The kbuffer_next_event() will return the next event on the sub buffer.
If we pass in the last_record to tracecmd_read_page_record(), it
initializes the sub buffer, and by calling kbuffer_next_event()
(instead of kbuffer_read_event()), the second event on the sub buffer
is returned. This causes the match of the last_record not to match if
the last_record happens to be the first event on the sub buffer.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 lib/trace-cmd/trace-input.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 05e595f..3bb17f9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1720,18 +1720,22 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
 			goto out_free;
 		}
 
-		do {
+		ptr = kbuffer_read_event(kbuf, &ts);
+		while (ptr < last_record->data) {
 			ptr = kbuffer_next_event(kbuf, NULL);
 			if (!ptr)
 				break;
-		} while (ptr < last_record->data);
+			if (ptr == last_record->data)
+				break;
+		}
 		if (ptr != last_record->data) {
 			warning("tracecmd_read_page_record: could not find last_record");
 			goto out_free;
 		}
-	}
+		ptr = kbuffer_next_event(kbuf, &ts);
+	} else
+		ptr = kbuffer_read_event(kbuf, &ts);
 
-	ptr = kbuffer_read_event(kbuf, &ts);
 	if (!ptr)
 		goto out_free;
 
-- 
2.21.0


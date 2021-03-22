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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559B3C433E6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1636D6198D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhCVKAd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhCVKAC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:00:02 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF12C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:01 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ce10so20170910ejb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a4BiW5YoUz5ufk3n1fjMIzWlYK86+qzPaMiKwA8JOn0=;
        b=VDCfZjrKxhUFWnWHJwTb9Yz6td7d3pxYIvl/CUoAsNSoNwu4yQ2w/pV+caDyYSbHga
         0otVYh+jLFG5gcPx4czwJmumeAQRQSPgnGKii6LEph4Xrf9ZxCuzymGIrAnMhbE1syUB
         pUrQbBKMptAZlZNdH1CVxdqMjyqJ1s1K9sIESd/2cUnGN19P9yzR0xf0hRdD/bBoQOdi
         vFXwA4POyaKB+toPkrT5dvJxur6kcs+5H4sCZTEfybPMsDOg9OAbN8tw7WGxcs1euVTh
         JB9Ugh8KJZwJvNO43x1CuCa2aaCe6Jn5Zopr6cZjZJVtBEm5aUeuNUmdZA3edOEMQF+w
         RD1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a4BiW5YoUz5ufk3n1fjMIzWlYK86+qzPaMiKwA8JOn0=;
        b=dIQJHwJkmZ0Y7Yv+a02Tgm7njexpi5Q8Js3VBZVDPrtYYTyYiKoIM6vt85B1T8lVNt
         SQF25qoz0AEQVLvabMLBsNmEQXBcIxGtvCIDci+uLcvSqYwHhc9RGw+ZBDF7SpVbC5MA
         A9FySABVd7PXbkqvsfedm6AbUETGhiHkyzSTrX354n7g2l7Oax3iMilUQgVKeyzjcN16
         g3EDq2llxxYDhL9A6yn741k6OnxkK2TooLUu7548V8xcBAijQpDAt8ohYGUECb2aT9Lm
         bUNVJfeiePbXy9LYNJSHOQtp5g6fQj+/fSBZ5/fRdpGUzRkWMA2yVc2oVcl0aGhuE/bS
         XtXg==
X-Gm-Message-State: AOAM530bQNRMzQ64xoLIr6EZrjFxYT+5/giy1tf99pBaThB+intndUFb
        ZoldFl9Q/sWKqtGlBOJsEZ6jFe7A5Lx1Sg==
X-Google-Smtp-Source: ABdhPJwqJEGwRksaetqiqeuxZHqeSOPQ4MTAsLBRmLzVkxeuPv0YnffODIt1YSmJAfBzUOJxwXqjew==
X-Received: by 2002:a17:906:c143:: with SMTP id dp3mr16556435ejc.499.1616407200460;
        Mon, 22 Mar 2021 03:00:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:00:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 14/18] trace-cmd: Add a new flag to disable any timestamp corrections
Date:   Mon, 22 Mar 2021 11:59:41 +0200
Message-Id: <20210322095945.259300-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new flag is added in the trace-cmd library for controlling events
timestamp corrections while reading a trace file. If the flag is set,
all timestamps are displayed as-is from the trace file.
   TRACECMD_FL_RAW_TS
The flag can be modified with these APIs:
  tracecmd_set_flag()
  tracecmd_clear_flag()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  1 +
 lib/trace-cmd/trace-input.c                       | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c33d067a..fdca7494 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -134,6 +134,7 @@ enum {
 	TRACECMD_FL_IGNORE_DATE		= (1 << 0),
 	TRACECMD_FL_BUFFER_INSTANCE	= (1 << 1),
 	TRACECMD_FL_IN_USECS		= (1 << 2),
+	TRACECMD_FL_RAW_TS		= (1 << 3),
 };
 
 struct tracecmd_ftrace {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 5d03cd00..88007cde 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1289,6 +1289,9 @@ static unsigned long long timestamp_calc(unsigned long long ts,
 {
 	unsigned long long t = ts;
 
+	/* do not modify raw timestamps */
+	if (handle->flags & TRACECMD_FL_RAW_TS)
+		return ts;
 
 	/* Guest trace file, sync with host timestamps */
 	if (handle->host.sync_enable)
@@ -2604,7 +2607,8 @@ static int handle_options(struct tracecmd_input *handle)
 			 * gtod. It is stored as ASCII with '0x'
 			 * appended.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if ((handle->flags & TRACECMD_FL_IGNORE_DATE) ||
+			    (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			offset = strtoll(buf, NULL, 0);
 			/* Convert from micro to nano */
@@ -2616,7 +2620,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * Similar to date option, but just adds an
 			 * offset to the timestamp.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (handle->flags & TRACECMD_FL_RAW_TS)
 				break;
 			offset = strtoll(buf, NULL, 0);
 			handle->ts_offset += offset;
@@ -2631,7 +2635,7 @@ static int handle_options(struct tracecmd_input *handle)
 			 * long long array of size [count] of timestamp offsets.
 			 * long long array of size [count] of timestamp scaling ratios.*
 			 */
-			if (size < 16 || handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			handle->host.peer_trace_id = tep_read_number(handle->pevent,
 								     buf, 8);
@@ -2710,7 +2714,7 @@ static int handle_options(struct tracecmd_input *handle)
 			trace_guest_load(handle, buf, size);
 			break;
 		case TRACECMD_OPTION_TSC2NSEC:
-			if (size < 16)
+			if (size < 16 || (handle->flags & TRACECMD_FL_RAW_TS))
 				break;
 			handle->tsc_calc.mult = tep_read_number(handle->pevent,
 								buf, 4);
-- 
2.30.2


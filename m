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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDA4C433E8
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF6761A0C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234426AbhCXNF2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbhCXNEp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:45 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B23C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:45 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso1167209wmi.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U72XNlXWEBux9XBC/JbsI6dAOYW3hOLN+0Rgtgi1614=;
        b=AoRouU2XtI0nObD6PGRMvKfJU7lQctMelDkLVI+2nxOzKvpvUJPiWyt8BQ4G7NyzFQ
         YiifiPZXSzOBmmbDwgM65J8jnMxqWlc501VqOth6EYZuQz/zY9qO/iPaAydWbN0r5zr5
         9F7Gor/cFEkgyG2hhvAaf40EB2w9+xgXtNKJTo8TWzo9WWxWgXCI3z0p/7genp5AWUvw
         1RMZXN94KsPmydbgcihsF/7q8BNWB8nX00PUE1z6+JDu1a0yopKjtOyaqGkjTxKzBhYG
         3T6TcfBAKwJGZHaArZn0nfNt3Q6VXlstzf5mZmpgQTn4osiQumxmBGDwRkIlMNN/fRXm
         jIjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U72XNlXWEBux9XBC/JbsI6dAOYW3hOLN+0Rgtgi1614=;
        b=N5C34hegZHkYWqnFCMqzM3ntsvouVPEYJ4XXUB0fA/rFVaC0oZHsBwntzCPqTyclTE
         XtP9F3ZLr6K/DSuxozgvrhd9kbJ0jXjh+Nl19KzPRDvmrUIDI5UDNTFsMaD3QyWlnHzg
         qvPDAOAEkNC+PF3cbjwjaBLQj2UBk7OonzOy2xk65yoFbltTmlNguMaNAFb2w7B9fOTR
         H4b21554L6giGhnUCaWYl/DEfJdLnfdJDMzKaYofSNXOtZbVh5j0k4aGnFlWlJJf5lUy
         6HrxIZ+fXaZRh0rnnN844R9mAxIOixrA5u8Oto/FUlbAO4gTEWo21Bi4I8/Jq4bAN0ry
         7pHQ==
X-Gm-Message-State: AOAM533djHHNxhDMM3ufuw0tNCb6sGIuykSPwrnYaPO3odVjh8fQqSLf
        OIXr64CXWdnIXDn9BaGSOjBrKUdm2B5avg==
X-Google-Smtp-Source: ABdhPJwb+ahhtoTfYqiMFE4uMrEeztoTvjJZt4u6XFlx6Fbm/s+kxR53c7zKhwiGj+Q0h7lHVQrCRA==
X-Received: by 2002:a1c:7e82:: with SMTP id z124mr2895016wmc.51.1616591083350;
        Wed, 24 Mar 2021 06:04:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 16/23] trace-cmd: Add a new flag to disable any timestamp corrections
Date:   Wed, 24 Mar 2021 15:04:11 +0200
Message-Id: <20210324130418.436206-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 lib/trace-cmd/trace-input.c                       | 9 +++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

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
index 696e7bd8..27ddd8eb 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1287,6 +1287,10 @@ static unsigned long long timestamp_host_sync(unsigned long long ts,
 static unsigned long long timestamp_calc(unsigned long long ts,
 					 struct tracecmd_input *handle)
 {
+	/* do not modify raw timestamps */
+	if (handle->flags & TRACECMD_FL_RAW_TS)
+		return ts;
+
 	/* Guest trace file, sync with host timestamps */
 	if (handle->host.sync_enable)
 		ts = timestamp_host_sync(ts, handle);
@@ -2601,7 +2605,8 @@ static int handle_options(struct tracecmd_input *handle)
 			 * gtod. It is stored as ASCII with '0x'
 			 * appended.
 			 */
-			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+			if (handle->flags &
+			    (TRACECMD_FL_IGNORE_DATE || TRACECMD_FL_RAW_TS))
 				break;
 			offset = strtoll(buf, NULL, 0);
 			/* Convert from micro to nano */
@@ -2707,7 +2712,7 @@ static int handle_options(struct tracecmd_input *handle)
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


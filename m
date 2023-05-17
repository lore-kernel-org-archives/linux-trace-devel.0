Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1915C77B7A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 May 2023 18:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjEQSab (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 May 2023 14:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjEQSaa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 May 2023 14:30:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91656106
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 May 2023 11:30:29 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bcb00a4c2so1692818a12.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 May 2023 11:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684348227; x=1686940227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DFsDejeobvuixEYeGLgJhtbLYB4BjUwC2DFJQYysNsE=;
        b=sbG4vtw1owyHDilQIB+39kORp56A7Y956K81H3XJVlRc/Dwq7F2rbD/rZO1M4Fp5nQ
         AyOkbqP/b9yUkc8fklOJM3GDAzY16TzHg2JewC8NBMLGPn64bwSTFjIJWG6oQWS5j1Ju
         pQd9d5ZAa8xGihi5YR+R59CEgw3ZHrjZtHvwHjXu8qrgJuZHS1w9C9wk+mAonW/3soeK
         Lwlh8GnoqZDj6ogpB9I1BPCsTrtCtAlc8esrBmrtNDzadXNfvUi/KXNjhuh+1z0/NROD
         9NQlkjMXUt51xl+PsKarzX982UnJ99aZGxh/DQUbbTE3k1fLrSH8IKyTRfudGMlVidi0
         PZsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684348227; x=1686940227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFsDejeobvuixEYeGLgJhtbLYB4BjUwC2DFJQYysNsE=;
        b=ZM+jxKX9hBEQVLlVh4mM3Lvu1NArHAI5QlV1XPobGgE+AwZaM0hPRpvT7NrKxTM47v
         ji1FaEXRxrf7LJevw0awz4QloRluXgQZRNoPBiZ4VYxtEM58zVz9lGT4+P3xLPiqKp2w
         KIDcWVyZ3n/BCIHpvtUa+IjiCrH9oHDGnb1YJOwQcMgvzSDuLQmC6laOTpk/HUNJRL6+
         CHN2TuCYbvltMgeVeCGu2df4y09yie2Eu39Kw8F+YtN+B9UWMP4t2YFagCLZBu38GM+I
         2WwDlaeSFCfxWpKsKW5x7et1sZJummJ9EdAGTq3YCDpzX1yuUNmOypRIc0K4/+/rrLUK
         zyPQ==
X-Gm-Message-State: AC+VfDzdGRFTYefFNMYMrPV0XntK+HUH0Yo0MrkSjC5IHDPHYm5PvjdL
        /6eK4EdgjdTCxu3JdlWfgjM2ZMR/1Dw=
X-Google-Smtp-Source: ACHHUZ5WHjEjmD2wF7v4eOvxuXBGi+JjNVhTSIajrqsfcZj9SawEHOcREN6dQ3kMcpk/nCXMEi8kOA==
X-Received: by 2002:a17:907:8a14:b0:94f:6218:191f with SMTP id sc20-20020a1709078a1400b0094f6218191fmr41376348ejc.52.1684348227340;
        Wed, 17 May 2023 11:30:27 -0700 (PDT)
Received: from belmeken.. (78-154-14-41.ip.btc-net.bg. [78.154.14.41])
        by smtp.gmail.com with ESMTPSA id l21-20020a1709062a9500b00969f44bbef3sm12128776eje.11.2023.05.17.11.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 11:30:26 -0700 (PDT)
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] kernel-shark: Fix segfault in libkshark-tepdata
Date:   Wed, 17 May 2023 21:28:46 +0300
Message-Id: <20230517182846.217058-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It turns out that the size of the info field of some events can be zero.

Fixing: 3146d0b (kernel-shark: Do not truncate multi-line events)
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=217429
Signed-off-by: Yordan Karadzhov <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 2009ca6..b780957 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -825,6 +825,8 @@ static char *get_info_str(struct kshark_data_stream *stream,
 	tep_print_event(kshark_get_tep(stream), &seq, record,
 			"%s", TEP_PRINT_INFO);
 
+	if (!seq.len)
+		return NULL;
 	/*
 	 * The event info string contains a trailing newline.
 	 * Remove this newline.
-- 
2.40.0


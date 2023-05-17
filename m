Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF25DC77B75
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 May 2023 18:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjEQSZ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 May 2023 14:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjEQSZX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 May 2023 14:25:23 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67F783F2
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 May 2023 11:25:21 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96a9c44ec4bso64043966b.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 May 2023 11:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684347920; x=1686939920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DFsDejeobvuixEYeGLgJhtbLYB4BjUwC2DFJQYysNsE=;
        b=E+FInNdAWSb7J7LbayVadXrximSeVfKOHlJUsMFFYfvHPHx0NqBJQUlEo+VVovA6pm
         KuK+Mf/ByXg9U3oQ1rUZBt92w0qjY+h5QhTFFrcHpGbe/ybH8ZDcIb1Uss9JmSMvFLzo
         ftPv5vxLLLgxgJy7uWDzHoL6i0OXvpqsds/UD24Iu1qLTSNo4DxMacq8pYN/QsKhBLIN
         vrg+oMR0SfmbFLn3NwpcavSUqiQI9udYVlhAs5Cko1M0V5XZLK5jh01tYMbIPIa29mG5
         spFqAWrJVDqZPb9g4vQXCJ6Mwgvt1KaZcLxFcNCtv52T69xyOguVB+nAPziTBk/4Y3wy
         3lyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684347920; x=1686939920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFsDejeobvuixEYeGLgJhtbLYB4BjUwC2DFJQYysNsE=;
        b=F2er77Q8P/zSDnlD9fzdUW3HnUqeGAxPsKVvP+fTqV+kU7JsvaOQQR/8LicxQiPf+b
         HlBqmUkN8UjOZ/cXsoCFM8Br69xEr+n1JbLIyBZLbh4rDJZ+vhl9A/Gpr1ZbQuzXLH2i
         sV4tgMqj4FuJhfVDlurL9t8yUg2EcTBWlmCqHQ1J5A0ifidlxFDzrtwPXa7Sxilc9rmt
         Kv7emR+bbVjcR6wUrimFzEhJzPfFcJ07H5w9M2G5MEy9C3R7fO65N+pSXT9a+rfjwwHI
         cqztbmcMjLpSbI26aLXckCoGzKGHvFL9zcD2lw8o4sn4Z1249Hie/YhDlNPCYyhtNrJ+
         1kyA==
X-Gm-Message-State: AC+VfDxpsmmdTE2GG2Vp8tIlyafrBGctd8SKFWPyHY+xdpNfLNXolipb
        CgoyXbTD5IrVNq9YYgSr0z+zj3bJM4A=
X-Google-Smtp-Source: ACHHUZ5dd2ozo7BbGBhIEZ7cW6VugL0XmpIdCYpDr7Jd5IS3ns8QowafjT9+FkFpRkO34Ar359gX7w==
X-Received: by 2002:a17:907:7f03:b0:94e:4285:390c with SMTP id qf3-20020a1709077f0300b0094e4285390cmr3703317ejc.10.1684347919895;
        Wed, 17 May 2023 11:25:19 -0700 (PDT)
Received: from belmeken.. (78-154-14-41.ip.btc-net.bg. [78.154.14.41])
        by smtp.gmail.com with ESMTPSA id s19-20020a1709067b9300b00968a2286749sm12764398ejo.77.2023.05.17.11.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 11:25:19 -0700 (PDT)
From:   Yordan Karadzhov <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, Yordan Karadzhov <y.karadz@gmail.com>
Subject: [PATCH] Fix segfault in libkshark-tepdata
Date:   Wed, 17 May 2023 21:24:10 +0300
Message-Id: <20230517182410.216670-1-y.karadz@gmail.com>
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


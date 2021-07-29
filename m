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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A71CC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B9B360041
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhG2FLY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234153AbhG2FLX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:23 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F59C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:20 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id o5so8485719ejy.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oaOQsPQWt+4/gfHtzVQ0CEx87Z5rT8r8+pQ4gqvBav0=;
        b=p2aBW1+1DGkBDUhJLoWHaXEdlI4iFTU5N6dl1HwYm3Q6CEEs7rBzZ2AXTQxWcSJJOp
         5PO1gJXpuxD5MhvwU+7lam9JiUkYBA/7TttRKv7X6T4rxCC1pw+292DA60+DoffVCTYO
         N7JOUjhScdQI/isOCiy82xQ1PtKaBsQKg8KUdgS8522VlZ5bw1D35Fjhge/ogixgDqgI
         dnOqqOqlCWet5hXMw5eXWGod1SOnhk8xPvMTCM9qxTGRCvx87qCoQ1vBZCGQJWKxSWRH
         K6c96DvJCFt2fJiKkGHWSfyXoWLGYu/mY5MeSrv5GRbY0V2AcoDHPWuZpebM2hcc1aII
         tI6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oaOQsPQWt+4/gfHtzVQ0CEx87Z5rT8r8+pQ4gqvBav0=;
        b=M+fc9snqzw/MiLViwPHeidg0yH8bs2jWL+twroWhd7GzCl74dD2QYSje3W4WL8eaPi
         yUMOQ4FEnmmAGqmJmdmX1jleIW3ujzyfFdzFrQoJJd314g4ZlWW3ckhrZc5HoOF/q49e
         pTfkIFmstvxsPdCWLa6c0cdJ9uKDDqfNekrFDoxdQdFkSvXJwvHnIckcP62lfzGy/+h3
         ZcvZoVO8yZKyLYCKnEi7WuIb4NbDk7AfRtEtvE1kJshzsn9zEICitpCHvfHHwoFHmZlP
         HMRBMYQtovHqH1M+z0qY7v8D1ZHnozLHhpn7oarusgA2ALS3Ttjpfp0KNFoD8ikKBqBz
         KQkg==
X-Gm-Message-State: AOAM531fAHT1to1Y4JLCyo/YLVVDoPd6BAGvVzxe9rPBFigJ0oPZnn9P
        8GkIAAK9T14mfEODMRXqiaU=
X-Google-Smtp-Source: ABdhPJzVdhu6O2Vc+iAiTOXelMVI2n2bqoLPs1FU2ZRGP588R+D3cLkKzob+ghehRTknMyI7n2e/OA==
X-Received: by 2002:a17:906:a445:: with SMTP id cb5mr3001761ejb.320.1627535479496;
        Wed, 28 Jul 2021 22:11:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 81/87] trace-cmd library: Set correct CPU to the record, retrieved with tracecmd_peek_data
Date:   Thu, 29 Jul 2021 08:09:53 +0300
Message-Id: <20210729050959.12263-82-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace files version 7 stores only CPUs with trace data in the file,
empty CPUs are ommited. Fixed tracecmd_peek_data() to handle that case,
set the CPU in the record - do not use CPU indfex, but CPU id.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b66d876f..df2e999c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2403,7 +2403,7 @@ read_again:
 
 	record->ts = handle->cpu_data[cpu].timestamp;
 	record->size = kbuffer_event_size(kbuf);
-	record->cpu = cpu;
+	record->cpu = handle->cpu_data[cpu].cpu;
 	record->data = data;
 	record->offset = handle->cpu_data[cpu].offset + index;
 	record->missed_events = kbuffer_missed_events(kbuf);
-- 
2.31.1


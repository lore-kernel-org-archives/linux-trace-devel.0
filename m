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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A116DC433F7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BDB61A0D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhCXNFe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234506AbhCXNEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:54 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAAFC061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:53 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so1146750wmj.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W3unDQUXPtkGXHvMUpsn8lod8Lwq/jv3Y3fL2UtAX0g=;
        b=AxUGtiXynHBxmqnzE61cZGoVD+9KyYUzwqplXB1Syb9cUtiE1SZOL7vPruUSVXFja2
         MEkCQj9x8HYFHV3PeVzucGAE9s4nQHUHFQHlTQQm648BxxEqSE6b3Ih+64uXBvSAhEiH
         rZ6R/vUC3hCUCKDBp0IU1/El7pW8c1xKbnRkYPvKWgvof0TR6+ESIUe8yv4W0FDaYnPM
         DypEdssTGqQrPbVgKeIx8qU6CcDGFmjEO1z54TCoaQMOYyG0joEtmQR6n6/g9NK/GQqT
         J6QdQSk3W4u48hzALHCRfNuK9NY1SowKF3M2tG4rPsi9inO5u5zcoPTm5nojZe7HMBkv
         EMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W3unDQUXPtkGXHvMUpsn8lod8Lwq/jv3Y3fL2UtAX0g=;
        b=bxygqqXDqvx9n81NCCu0YsehP+rgBnYRnoZ2okCGkzXiD8h7OhvSpD+WIs/ziLJ6w/
         LZ71YUNKqy/cZljjBdx2HAzgRTLriJ/da1bAi5aWZ5QBdnkQ59DCI1o0CprqdUJXK9HV
         2SaWso31EVoJrh05/40l09sFB/DfjM28KxDn0w2JpEHLUE8S8XKpmeLqgaNaiEuDTsCR
         tJmkKbwHrGOa8PEo28gEQatM07JlcaL9wzx8rNw0DrlNA9Y3329ztgiQanFvRL9xs4e3
         MXrWkKs3WVn+MKnGvrSUelNAmjLLIW8FaIc0/EdnW2UrfgJmrviiHJjWB3zZUmHp4S/B
         sc/g==
X-Gm-Message-State: AOAM533+689+Tg9YIulDsOd2vTw3zfmucogKgZWK+g03V3M6eW3K/x0r
        dAzC3pAj+kGbv8w/tGVsdtcno7QVInkWqg==
X-Google-Smtp-Source: ABdhPJyk6WxlBUWJ2s32BvPxkE+nQLUjwLfpSHie3WOZGxnolvAxY4qA08c2/JybKtPmxia3rCY48g==
X-Received: by 2002:a05:600c:224e:: with SMTP id a14mr2838942wmm.57.1616591092389;
        Wed, 24 Mar 2021 06:04:52 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 23/23] trace-cmd: Read at least 8 bytes trace-id option
Date:   Wed, 24 Mar 2021 15:04:18 +0200
Message-Id: <20210324130418.436206-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading the trace-id option from trace.dat file, check if the size
is at least 8 bytes. If the size is greater, use the first 8 bytes only
and ignore the rest. That way we can safely extend this option in the
future, without breaking the legacy logic.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0f5ed684..5ec12ed9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2703,7 +2703,7 @@ static int handle_options(struct tracecmd_input *handle)
 				trace_pid_map_load(handle, buf);
 			break;
 		case TRACECMD_OPTION_TRACEID:
-			if (size != 8)
+			if (size < 8)
 				break;
 			handle->trace_id = tep_read_number(handle->pevent,
 							   buf, 8);
-- 
2.30.2


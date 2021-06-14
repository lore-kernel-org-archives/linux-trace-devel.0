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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85280C48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB5961246
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhFNHxe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhFNHxa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:30 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19748C061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:12 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id ho18so15043735ejc.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HiQsMk0wkHXTkHUtFtlVTetDCQMIW2DvIJ+jQNwbSjM=;
        b=STeJt63MgJdahmxKGQQ/ZH55vt8Shv0uli3rB5/3HhHhcPE41iisGeDq0bR4BULuJl
         hwErpJq9+aBE1rmDROuGnKGyacZM+hiwYIq0B5qSfV7+QsTWpfBZ80TUT+tmLJJBJiqU
         hd9P0JMcJ9+wpjCOXp7EgsGpb5iFT9mewZ8yaZ9yAF3J1lypHxB66tHHVhwChVdx5TcB
         CYVanMN69Zs3XSNU5jzyDkwpQFVNeR73wSzt90XuOPHhNigO6KhVHicvVVcdcCXvJ3/K
         /cAYO8MKuraDzzFa9arvE4lZCTrBYh/9G8qSEkfNRaOlJaVRyWjVr9VwCxR8y3eVmJep
         xsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HiQsMk0wkHXTkHUtFtlVTetDCQMIW2DvIJ+jQNwbSjM=;
        b=Dg9Nhswj9d0MU4CtvOoVcXkDwcXz+aARAtcDEYUK1aO9DwLIRDqpHg53pb6nx66ZQD
         z3AzSblSwR+76q+BufYiPQcmUGbfue5b1jpOrx/e/6XobyPb7Uw+EIHRaaBx8nH5dEhd
         r5VYKo7RbCki41Z8wEoUMSGG5Epd4hZ4bnnYkVSf++YhsayPBMA21i9V67gkw38NibCC
         GPdue86DGqygVD6GGBUFACy5+3HnRrMZUQ4zOSDKYpOe47qx9boKU1pfmOtQl6uye5bg
         vIMpM6DaFvMcdcZqIR296qGC+UONiPquphKF6O7FCXAiDqNpaqT0dlvUCkj4tN5STcrF
         x3xg==
X-Gm-Message-State: AOAM5318Q3WHuDamgGG3nczQRoDrtzkWL6Go3EEMbBEpSg8EE6BY+p+7
        vc+yh8izQ7VXnMaY/x27EJc=
X-Google-Smtp-Source: ABdhPJx+kgegdOORL684FJjGelyUxIqmtwedp5RGYHC4J3mvDXhZWafTEJOP9r84+5bb0NkLbz4hvA==
X-Received: by 2002:a17:906:919:: with SMTP id i25mr13608046ejd.171.1623657070634;
        Mon, 14 Jun 2021 00:51:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 41/45] trace-cmd record: Update man page
Date:   Mon, 14 Jun 2021 10:50:25 +0300
Message-Id: <20210614075029.598048-42-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of the 'trace-cmd record --compression' parameter
in the man page.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 5d063cc2..c5a7fb75 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -367,6 +367,16 @@ OPTIONS
     Traces are extracted by busy waiting, which will hog the CPUs, so only use
     when really needed.
 
+*--compression*::
+    Compression of the trace output file, one of these strings can be passed:
+
+    'any'  - auto select the best available compression algorithm
+
+    'none' - do not compress the trace file
+
+    'name' - the name of the desired compression algorithms. Available algorithms can be listed with
+    trace-cmd list -c
+
 EXAMPLES
 --------
 
-- 
2.31.1


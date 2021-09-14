Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE097C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A53A610E6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhINNOB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNOA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:00 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38DAAC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:43 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id e26so9242747wmk.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4eNSf3fXIhuexSWrZzu9VRBujGIACDgGvnuES2rhjo4=;
        b=aVKHGZamVeiLsY5FthUF4QQkjHOOkrjuEnZ2UTrfkBSSSiqjCVMhQV98y81ktEmW96
         qBClURnDa9dByNg9U2Lil2a8caTTE6dIql5LHLi6/39b2zBQBXx9uadvXZYBSDC93yJN
         HYxN/Ip+22wQVuVH1XRqFfeRUKnd6kmrqjSuXeXGTlB5Cx3bLxTyPcTx5FUPxQTaXYpx
         kCwp0xVt7ne/9MsZa2/6ngHQEoAkE8x3W5wo/TvDhEZZ4AV7JPBvLfS02Am9HcBayJd0
         T3o1r/sOvRLz2h5NwB5POci3lyuGSK6PhgeSqA+1amD9q3aIcje2ZXJmuCs81GaZg6Av
         6Jpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4eNSf3fXIhuexSWrZzu9VRBujGIACDgGvnuES2rhjo4=;
        b=gnjEP6l/Hm3TUac+F+L6LG1IZLLREt1EgwU/UUTqd2KFx9dU8KbJRSYlEDwIC9xRxn
         aVJAPuuLaTTKkNGIH1WSMbT8azuPii4pFYjkY8+QUCkyt9NTbhOYAvOSRt5NLh7/eYNS
         BBga7CBJBBJYyT/8QXBRNY8spqq5Yee2fEnT8FnEkvJNwgV7pqE4vf/aTKl9ev3uY8/P
         xC3GGOPHaEjOlmrO+SPQ+n1Vn0UJt0HY7yOiQMgq3ylh4hbvl+HdW24hlnqgLlPRYfsc
         tq6P+6iNATgSY6RCVrfB87arkYv4IoSYPfIGEBG3e5HLLetJClNuElsrSp7rEy69r9KX
         NnYw==
X-Gm-Message-State: AOAM531Izb3Jxjbxn9UBlTXwhzZqGmAZRj8HPSk6EsR84ObtrHGH229X
        qLbwz4hdVDMp4XiazTrCoMlAoMtTRUU=
X-Google-Smtp-Source: ABdhPJxCbk0ai5qpuspZriVjCWEOTw4IFUdChhX3hmIPg/uYfJ4DQFZEBPExA9fY2ku1kKjQtyBs6w==
X-Received: by 2002:a05:600c:2193:: with SMTP id e19mr1772269wme.38.1631625161772;
        Tue, 14 Sep 2021 06:12:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 06/21] trace-cmd library: Set long size to the input tep handler when it is read from the file
Date:   Tue, 14 Sep 2021 16:12:17 +0300
Message-Id: <20210914131232.3964615-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Setting the long size to the input tep handler in tracecmd_read_headers()
API may be too late, as this tep handler is used to read and parse data
from the file before that. The most suitable place for that is
tracecmd_alloc_fd() API, right after reading the long size from the
file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e5c8c332..3d7f1c48 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -860,8 +860,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	if (ret < 0)
 		return -1;
 
-	tep_set_long_size(handle->pevent, handle->long_size);
-
 	if (state <= handle->file_state)
 		return 0;
 
@@ -3337,6 +3335,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	do_read_check(handle, buf, 1);
 	handle->long_size = buf[0];
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	read4(handle, &page_size);
 	handle->page_size = page_size;
-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94870C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Mar 2022 05:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235925AbiCDF5v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 00:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiCDF5v (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 00:57:51 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F70EC5D7
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Mar 2022 21:57:02 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id j26so682058wrb.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Mar 2022 21:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1yixPBVLzvm0/Giv1ivhl9WWRKEhLHtKRrOJJSvASnQ=;
        b=SJWrpBn7SqB/48xHnVvCWg1Vev0VM5ujBPh5Vr4cgG/ZkQF0XDZCw3bR7DGFxdQKFt
         ll4eAlteE8AYuxZfGIm1I63gBXSL5zibi/Kr9ox6l6EkQSAyK1CJkBueOri+/ohoX4hH
         Q870dNioQsAkO292XRjkyNMrgn+qy8fWILvdPmoeHq/jrzZDtdbe1D2euZwdatFPHKh7
         ZXKHN5FczAfMyNGLrhKi5bbmy2nghMHGEmN1EMROHnTmeNQQGsG73gTUgWmBRV/Y276a
         lplgSyZOegjKPECUkFy72Dt3Ynpw7cx9jFcwKWVLXWYG8nqdysoKoCacg5+BXLCtaYeG
         M8Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1yixPBVLzvm0/Giv1ivhl9WWRKEhLHtKRrOJJSvASnQ=;
        b=xJ/O8Ljx961wWYrNYSFEevYBRrOy7y0Qkx0NK2P3RMzJ3E3woLAhk16hwimMMqZ4zl
         J2w9hHUcqJZOopaRCb/MWXyp5zqk606SHgCRL1OeKajjRYfoD5DxFr1eE7q+BhnUlZim
         2FxW3LbYwkYQsE6bu0brHQYc29AdA3gCK2ZHcZNmyMfLuZYYJrgtOujcx0yV49hvXRnD
         mx+6V1KYkhd2TIPEubH4dgchwDzo7nJ7gvLLF6Nfzheyf5s4xeqpP7wleRjbhII7ge/m
         OxDZjyZfUoSh9xVCGLwTcMvv2dp7VL6N7OiAM2cXm3LKoJua8Kyax6rjJt4eaDtdMbIR
         wfMw==
X-Gm-Message-State: AOAM5338l8dD7Tr4gh4SS/QlGOURx63oHNdWSAAlBpLo1bAesuCj7dt/
        B1E3XTKRa920HNzb3jQ3WAI6zsdQ8rI=
X-Google-Smtp-Source: ABdhPJyUlY479bPFj+SL0SbcH18DPYEC6mtJEt9ifsfu4AYnWam/kJ1xleJFMYNr3R9hef1cJkRPMQ==
X-Received: by 2002:a5d:47a5:0:b0:1e8:88b3:16b7 with SMTP id 5-20020a5d47a5000000b001e888b316b7mr29684983wrb.417.1646373421158;
        Thu, 03 Mar 2022 21:57:01 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r10-20020a05600c35ca00b0038981d85ae8sm505074wmq.33.2022.03.03.21.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 21:57:00 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/5] trace-cmd: Improvements in compression logic
Date:   Fri,  4 Mar 2022 07:56:53 +0200
Message-Id: <20220304055658.440904-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Improvements in internal comperssion APIs, suggested by
Sebastian Andrzej Siewior.

v2 changes:
 - Fixed crash in tracecmd_compress_destroy(), reported by Steven.

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Use a structure to describe a compression protocol
  trace-cmd: Make internal compression hooks more generic
  trace-cmd: Use errno from zlib, if available
  trace-cmd: Add context to compression hooks
  trace-cmd: Use context hooks in zstd

 .../include/private/trace-cmd-private.h       |  20 ++--
 lib/trace-cmd/trace-compress-zlib.c           |  43 ++++----
 lib/trace-cmd/trace-compress-zstd.c           | 100 ++++++++++++------
 lib/trace-cmd/trace-compress.c                |  85 ++++++++-------
 4 files changed, 149 insertions(+), 99 deletions(-)

-- 
2.34.1


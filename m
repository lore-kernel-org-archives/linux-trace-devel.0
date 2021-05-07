Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF87C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3887A61059
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbhEGJw6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbhEGJw5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:52:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C061C061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:51:57 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c22so9491502edn.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uy9ntjxdywQ26MvpjQp4RtCdlGZprxxfqTFAab8Ym5I=;
        b=ga3WKRYIVnJRWNklgOGJo7mgjUTZdu1n5BcUKR/v9Wvkxdx0jFLLbAYpr2QvfLZmh1
         Haq83yimmyKcfzNTQlqYupVmpYbDQ//dTJm960Vl8x7Nz9hW7uE44oXDEWauzbLeOhPT
         k6PbgQSEQ0DfwQ6t9/1L/oCwKKVrKT0KW40ckthBuTcehFgtQBWC99nJ5BZczcAQrEim
         b+4SIIqM0snipLoAOI11eLagcLxLwUbIzPx0a5dcHYpCUzKY4YZDvkJjwSIOgLMiaZLM
         GWCczHJrtGua4R2muW3/HB1WFYglIPfnOlJed48hpn/3pGZ/T3Qm/zFNevnWZQu3tTYV
         tgLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uy9ntjxdywQ26MvpjQp4RtCdlGZprxxfqTFAab8Ym5I=;
        b=c8qiNUvWFrS8RJfx9I6wwLFVbvt4Y37Tpu3yhQ+nmdko6YGGEHGAImxoMb1yHocaZH
         8gnoRWGvWO2Y9Y0m+xTPVA8AdgTS0qKMFhUMNG3OHqhnUd7OdtMB/Mp5/aXC40QyNo+P
         IVxOOfWFuBrbGnA09GXr9F9Rdupa+zYHwHfxsj+c3WgkNwstWviSxltaF7AOEBJAI3Ot
         1w0vRZV1aHz+FA0tORn4wm3cGZkK80fPyGp51QmNQ8WCGlmXYHdDT0eusd/iVK6KvZy8
         8OuSncwsz6IYuCJgp3vZTCtIjCvFpfOTyJQQzafdbPK0Y4p7M2mwy0GxC7mS/7u9Ri7S
         U2KQ==
X-Gm-Message-State: AOAM531dhBfiSKpS6dRfbBdqX3h4vmGU8rLH93z05tmuglSNOvsj2/ge
        sd1LZnAgZufvIxc9SPEopTrFW5xsJLU+nA==
X-Google-Smtp-Source: ABdhPJwHioZJLd2yQmGit9TofkG6XANXUDqYjNLbSInZBo0UItZTVCI3xoZvvybWJvaijjKuMJzN2A==
X-Received: by 2002:a05:6402:199:: with SMTP id r25mr10273337edv.128.1620381116222;
        Fri, 07 May 2021 02:51:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eb9sm3130893ejc.96.2021.05.07.02.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:51:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] Add API to set severity to tracefs library logs
Date:   Fri,  7 May 2021 12:51:51 +0300
Message-Id: <20210507095154.1080202-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new API to set the desired log level of the library.

These changes depend on "[PATCH 0/4] Add severity to library logs"
https://lore.kernel.org/linux-trace-devel/20210507095022.1079364-1-tz.stoyanov@gmail.com/

v2 changes:
  - Add a parameter to tep_vprint() for errno printing, insted of using the log
    level.
  - Added a patch to remove unneeded tep_vwarning() implementation from the unit
    tests.

Tzvetomir Stoyanov (VMware) (3):
  libtracefs: Add API to set the log level
  libtracefs: Document new log functionality
  libtracefs: Remove dummy tep_vwarning() from unit tests

 Documentation/libtracefs-log.txt | 76 ++++++++++++++++++++++++++++++++
 Documentation/libtracefs.txt     |  2 +
 include/tracefs.h                |  4 ++
 src/tracefs-utils.c              | 18 +++++++-
 utest/trace-utest.c              |  5 ---
 5 files changed, 99 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/libtracefs-log.txt

-- 
2.31.1


Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5F0C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DE3023730
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbhAOFEy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFEy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:04:54 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790D7C0613C1
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:13 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ke15so3887232ejc.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FsulthSuE2h9ihS6oEKxM0JCHh2CGdKmMwtdaTsnl5o=;
        b=mpXLe8uV4a/LRphVbjZIwgH6Qh/nejAQcWmfGnzNB/qsX4F0b3JirKK3ERvPqVuhmH
         ej8k/5nU1F2l4yp6+1XgXDvkNvTfJAWlDu8gYxhnTzJ3s5X9gtds+ICDiAOIPMgbv2fn
         OV0LdUebhYabYZverRFqh04sEwtGo5vXtRyXb3jf7fQajuRlG/wg1MzHt9SXvqIbjzNc
         NMkAUbz96JZq/Utq0Q5Miapj7SBN/moZ7hRYY5i8TnDnUWU6EJlrQChNRvsXICcOFOW9
         j/n4ijsmtAy2eYqdiyrAHRfZoCgK6iNGMcHyK4v0XiOj3Rr0iV5R+i3ZIrU92R6k+6vN
         JH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FsulthSuE2h9ihS6oEKxM0JCHh2CGdKmMwtdaTsnl5o=;
        b=XS4+YMmM/5ZSzaNi0CEMicp4JY/XMPR0kZGMut4tvOJ1LNq4SgZ5J8ffZuT4n9FTdl
         OZUWpgdlJjzivfRtCb3J9DSJChCQcfJL0VH54Tyxgp/FzRvm6NflzPBgZwEf1XR3IiEx
         jkawo/xOWybZ3/ecnezkKQenKRPl3Iqe/iv5+uGtaL3QGmi39X9g9SXwXxcuqGReLwsF
         yi29etWGbe4M89+sm3z3PmFCl4xupNG9Hyu4zq0VKSVn+Kidg898I47sDQ/p8Xc2D9N+
         Ha6ail+dpFOUkXjIK2eAtRRXEy6bS2elFCNiWCF5q+/zgaDP9R83qa4g0zHy6guq87SG
         iybQ==
X-Gm-Message-State: AOAM5332rJCKu13nD2LutHGuz0whh7gIr3Qjsn9vwefooOF4b6Y0754n
        BK9fCk8qKxglw5HOCoAb3EFzguYL0eekKVN0
X-Google-Smtp-Source: ABdhPJxWU7gtEdW59ceoP2qmfqwzGfFdDSXUOM9wuBejkgONkdvhi73mDL+fBohY4+cuyFMBM1CX7g==
X-Received: by 2002:a17:906:134b:: with SMTP id x11mr2059250ejb.327.1610687052313;
        Thu, 14 Jan 2021 21:04:12 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d4sm3055670edq.36.2021.01.14.21.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:04:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] New libtracefs APIs for trace options and trace dir
Date:   Fri, 15 Jan 2021 07:04:05 +0200
Message-Id: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new set of tracefs library APIs for:
 - Working with trace options.
 - Working with non default tracing directory.
 
Tzvetomir Stoyanov (VMware) (5):
  libtracefs: New APIs for trace options
  libtracefs: Unit tests for tracing options APIs
  libtracefs: Add information about top tracing directory in instance
    structure
  libtracefs: New APIs for getting existing trace instance
  libtracefs: Unit tests for working with non default tracing dir

 include/tracefs.h      |  57 ++++++
 src/tracefs-instance.c | 137 +++++++++++---
 src/tracefs-tools.c    | 251 +++++++++++++++++++++++++
 utest/tracefs-utest.c  | 416 +++++++++++++++++++++++++++++++++++------
 4 files changed, 771 insertions(+), 90 deletions(-)

-- 
2.29.2


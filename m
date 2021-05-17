Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F43C43618
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56A1E61019
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238870AbhEQPAO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbhEQO6C (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:58:02 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B174EC08E85B
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:50 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id b25so9504551eju.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pY0P+U3w0k+9ZozOFyW6tdNjPkhSm3c9+OtfaPFkon8=;
        b=pPfh7dYebEHZp/gOu7H/xffXByALEUtpgIEzKGtCqdmALxrJYd5aPvq78cdmOakRDm
         MtP7AQlfxl2POwsPc6dgOIXs4zBFusyLKtjd7NqTAlJiDnO78KvqmQZE2aPKPgsubMXG
         JoNJ8O3qYqyEyFy+MRUsvyNm0dIrkFxBZw5R7mLcmgQwkwil7Z2J3Y5Q0bxJutk8+u76
         GpBKXtn2oIpgk7EO5KSegY4TTJbUUN3SJDU0Vg/IvIknbHTLnQBSn/WF+PaEgyzDut2N
         5sF8KBESXwUeCu9dEnwbN/4wzAQTHbwo7o3tiekDLz/aHDVPBfXRdlmikPpcphZtzhN2
         VKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pY0P+U3w0k+9ZozOFyW6tdNjPkhSm3c9+OtfaPFkon8=;
        b=K+kDe38KPzMWXRPR6nV1Z1o8fMuKd9jq3QSfm4TJ9wL4j0MhUFbX6fTGYsPxmJKlQy
         9wY2wyzgvCusuIx8C3ihHSYvTeg6YKeAK49gPHPv2j11dohoj/yJal6UkiywvrQhZpPS
         YRdKHunJPBPifysmxn6KaQqsUhAuvTHEf9kaAoK52ZPMaguK3EJua2XX83s39eiODCmK
         FoN/Xo1dUB9XwiuoWRNTvtLReMKSU9pCVfRXubkC762UpyYIpOUZfNCgznbxP93koT6A
         WY08L6KE6DWQyuQv3Muh/E89liguHiz4OsdroQBNOfDR3KLgqhhU7lo/U/HYsN9mLZYH
         t58Q==
X-Gm-Message-State: AOAM532ngadoUpmoxizqd47gpPbWsC+pCT6k2vi8bXYVZjh5rkQe19Yt
        5r9uGhlThzuWptM31q0ESXr+gwQEM4o=
X-Google-Smtp-Source: ABdhPJwM8Cneie39EiQk8QnY1nt18g64E2WY3MkRdYs3yZH+SrelgXOnADGd39RE9LGuVtQKsYRGeQ==
X-Received: by 2002:a17:907:1b20:: with SMTP id mp32mr127731ejc.495.1621261309229;
        Mon, 17 May 2021 07:21:49 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:48 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/7] Final fixes before KS 2.0
Date:   Mon, 17 May 2021 17:21:33 +0300
Message-Id: <20210517142140.286153-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

v2 changes:
 - Still showing all CPU plots from the new trace file when
   appending [PATCH kernel-shark: Preserve open graphs when
   appending data].
 - Setting "seq.buffer" to NULL after calling trace_seq_destroy()
   in [PATCH kernel-shark: Fix the checking if "trace_seq" was destroyed]
 - [PATCH kernel-shark: No slash at the end of KS_PLUGIN_INSTALL_PREFIX]
   is new.
 

Yordan Karadzhov (VMware) (7):
  kernel-shark: Preserve markers when appending data
  kernel-shark: Preserve open graphs when appending data
  kernel-shark: Clear before loading new session
  kernel-shark: Better handling of plugins when appending data file
  kernel-shark: Do draw the combo point of the mark
  kernel-shark: Fix the checking if "trace_seq" was destroyed
  kernel-shark: No slash at the end of KS_PLUGIN_INSTALL_PREFIX

 CMakeLists.txt          |  2 +-
 src/KsDualMarker.hpp    |  6 ++++++
 src/KsGLWidget.cpp      | 40 ++++++++++++++++++++++++++--------------
 src/KsGLWidget.hpp      |  4 +++-
 src/KsMainWindow.cpp    | 34 +++++++++++++++++++++++++++++-----
 src/KsPlotTools.cpp     |  3 +++
 src/KsSession.cpp       |  1 +
 src/KsTraceGraph.cpp    | 10 +++++++---
 src/KsTraceGraph.hpp    |  2 +-
 src/KsUtils.cpp         |  4 ++--
 src/libkshark-tepdata.c |  4 +++-
 11 files changed, 82 insertions(+), 28 deletions(-)

-- 
2.27.0


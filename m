Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85DFC433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:25:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1C47613DD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Apr 2021 16:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbhD0Q0a (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238926AbhD0QZi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Apr 2021 12:25:38 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFF3C061350
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:25 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id h8so30558028edb.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 09:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jhh/uxePkui2k6JmueA5sq2X0Trio3WTz8AmUrDeJPY=;
        b=giYqJQCiU22qSIXLpRTpU5gFAHAsJXfPqwyP70s1EzqXyBXx2wTbqmn78t/C4vBPCI
         3O8RYmly0USakpV5QVl7bqZ4hpe6aStv+QV/ibSwYITe0n3G7l4Qdf1pY9jEpKwGbGQI
         v2sgd6dWswzjI5x9jgQ3H/SLXIUsQeJPXHj9G4VRaHZwcrcD52QQ2otg9vf6ptihkUU8
         IEUiIZ30LWiy7kdmPgLFSqYdHj9eDQY/6eZD4DReWd7QYiGTsOfT1nBJKY+bajJrAWxb
         IInYNXuJODI5D3wt9VUZOozCQFsHBsC60nZmP/LaVJtsyNtBPgqZDXhO+DxuZU9GMwvb
         R1IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jhh/uxePkui2k6JmueA5sq2X0Trio3WTz8AmUrDeJPY=;
        b=P0A+cbj+CRfiZJOkWz0Hohrcw3yKa+54v+pt9X0ajBdCwpsmhtmi8JMblq71Lg6K5g
         Wfl/o7xYGVrfRlZjVPswOs76WwYkv9WUuKRwJ5A9+Sfvlv26SIzyJKIHV2uemBJBlECe
         B7Le/PYMaf7dzPCbhIEKh0qDoTM1c596SUE00QBQrR/7LLTpxMKxUXRJJ+1ce66HRiwD
         0LUXtDEK7nowqZ/fdbMixBOkKFm7tfVA0NsPo0iYdSpga4HzEpvjaeFnTumpSZcLPGRh
         9m+vPz+6qQwxYeiwM8sz5nJaobAdbzhLe8kXxODHVdA+WpFhyIiZZEKYLV3O4evWo3YY
         oZ8g==
X-Gm-Message-State: AOAM531hS339Ez/LNZqB7Hz4qxoUMt9TcNpCBJnDfDuqjBqloPU+y95W
        gWKB2cr/XBjnHBTiaQPqeSEmz9Sl6ZE=
X-Google-Smtp-Source: ABdhPJxN8NkDiIWSjYt7YN6R4n3LnuB+8C21Zi5m8J9rdwPhgyHeh2Uw2Hw1zk4QqyjDja0+fOopFQ==
X-Received: by 2002:a05:6402:6cd:: with SMTP id n13mr3327144edy.330.1619540663542;
        Tue, 27 Apr 2021 09:24:23 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id d15sm2740284edu.86.2021.04.27.09.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 09:24:23 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/7] More minor modifications and fixes toward KS 2.0
Date:   Tue, 27 Apr 2021 19:24:01 +0300
Message-Id: <20210427162408.134001-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (7):
  kernel-shark: Fix the build for 32b systems
  kernel-shark: Add "cron" job to workflows
  kernel-shark: Fix KS_DEFINE_PLUGIN_CONTEXT macro
  kernel-shark: Add cleanup of all plugin contexts
  kernel-shark: Fix memory leak in "sched events" plugin.
  kernel-shark: Disable the pop-up offset dialog
  kernel-shark: Remove kvm_combo from the list of default plugins

 .github/workflows/main.yml |  5 ++++-
 src/KsMainWindow.cpp       | 11 +----------
 src/KsSession.cpp          |  2 +-
 src/libkshark-configio.c   |  2 +-
 src/libkshark-plugin.c     | 10 ++++++++++
 src/libkshark-plugin.h     | 31 ++++++++++++++++++++++++-------
 src/libkshark-tepdata.c    |  3 +--
 src/libkshark.h            |  2 +-
 src/plugins/sched_events.c | 19 +++++++++++++++++++
 src/plugins/sched_events.h |  3 +--
 tests/libkshark-tests.cpp  |  2 +-
 11 files changed, 64 insertions(+), 26 deletions(-)

-- 
2.27.0


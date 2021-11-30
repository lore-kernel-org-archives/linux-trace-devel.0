Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9990FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Nov 2021 05:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhK3FEU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 00:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhK3FEU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 00:04:20 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A354DC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:01 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id x6so81160976edr.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Nov 2021 21:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8e6nVuZgndnxSDCVS+BwuU25Ahr96FXqBSbHmyLqeyQ=;
        b=aYM7IQIGuxin0xMKAd1xaueKmpoAsRF2yQss+AhVQvMa0wJy+NZQAWhr100jQWXx2n
         qikjOnzKKXx8rYy5fw15nahr2JL4F/Rb88XkRUXP9vJnNNPzFNdduLNfskaDzR5P5APV
         jl6rX/OnMZqV5Hw2naSIVHYhngnAX5Uwhpx3823ljwfDt3goODsFBDIB7DFLlHqZ90P8
         UdA3npM4yIhmOxgsiYjpZyCbztr2AxCrSuRkzF96jLmR4TS4WQQLEZySLGK+1NN2lOXH
         NS/0Ir9laH+XBQBL5imp5tA08+QI5RD4Pvo+vXZZ31x0ala+BBtPuyMe4iIkpNmSbRcS
         Lg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8e6nVuZgndnxSDCVS+BwuU25Ahr96FXqBSbHmyLqeyQ=;
        b=GxoNxoSdVmJJ7+GK7exBsXaeskd+iSKB+jsLsOCLOKXXJK+8GjMuhsd17+GnjNecSL
         L5W7wr4R2T91dpdRcbADfr43xBXkK95FZV7PtxhcSCd576l4bMlS+PhFEWleivPN71B8
         sVW11s3Th5Dmatw9ho+vLJyeIUD5zvzmmz33Kw0CVj4DCz3XynPuxZg9SgQAyPZMR1W7
         x1md3d/ktpb5RUPlr/ZNtjgUrmEh/eNYTMI0FbXKdtgEBu1DKl6U8ntR7p6I7aC4ePty
         QAM3Ok6KdZGuuPyg3wAt6MzLR9gZORmcZ6JSKY+oQDnKxwBgkr/sv9bel8ZgREtv4sLH
         MILg==
X-Gm-Message-State: AOAM530Ilv6PbD1nl76jLQoMaX79rGOAvTHepH/jkUfVcLQGJJ+o51YR
        OMGy4ZxMx7dU8cgLZBANJ4c=
X-Google-Smtp-Source: ABdhPJxgZfURnErzlyxO+olDCoYfRAUMvAUAGXLKLrZcm5njgV7lJqL4gZedeBwFRQngwYNU8hEugA==
X-Received: by 2002:a17:906:7ccf:: with SMTP id h15mr64543310ejp.386.1638248460237;
        Mon, 29 Nov 2021 21:01:00 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w18sm10385849edx.55.2021.11.29.21.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 21:00:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] New tracefs APIs
Date:   Tue, 30 Nov 2021 07:00:53 +0200
Message-Id: <20211130050057.336228-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two new library APIs are proposed, to provide a missing functionality:
 tracefs_dynevent_get_event()
 tracefs_event_apply_filter()

Tzvetomir Stoyanov (VMware) (4):
  libtracefs: Reuse logic for loading events inside the library
  libtracefs: New API for getting dynamic event
  libtracefs: Unit test for tracefs_dynevent_get_event()
  libtracefs: New API for applying filter on event.

 Documentation/libtracefs-dynevents.txt | 15 ++++++-
 Documentation/libtracefs-filter.txt    | 11 ++++-
 include/tracefs-local.h                |  3 ++
 include/tracefs.h                      |  5 +++
 src/tracefs-dynevents.c                | 29 +++++++++++++
 src/tracefs-events.c                   | 11 +++--
 src/tracefs-filter.c                   | 19 +++++++++
 utest/tracefs-utest.c                  | 58 +++++++++++++++++---------
 8 files changed, 125 insertions(+), 26 deletions(-)

-- 
2.33.1


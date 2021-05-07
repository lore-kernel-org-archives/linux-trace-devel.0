Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042EDC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D919C61451
	for <linux-trace-devel@archiver.kernel.org>; Fri,  7 May 2021 09:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbhEGJvc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 7 May 2021 05:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231517AbhEGJv0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 7 May 2021 05:51:26 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C22EC061574
        for <linux-trace-devel@vger.kernel.org>; Fri,  7 May 2021 02:50:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gx5so12641032ejb.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 07 May 2021 02:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5V2VzcNb+boXnQnHRt6q4QxbfiztG7zemMaXsmnKHIQ=;
        b=J2ID1FyLJ1HtZGCv7Obcx+pBk2+tel2LtsK9jNsttnAEyKIqRKzsB/69PN+4J0NYge
         1VsAXvU8VE4RATHGZAiXRJjS9zvmnZnMnDD1PD3Ib2CbwOI4WPFrc3e2IqgTY52GaVEc
         IlPT95atCd5J4Nfln0HpYUrqsOvTJxKvvMTLQbpY5zdxKqxEXoO5N7ozRFLtZKYFN0dE
         +Mi7o1guflr3NLLWC6ngxxWSDCqmG6wgbvUvaAJHBmsPMklY3Cz2eCXE/bkpUiM36gVP
         Y13lnwtrFhidgB7wjGHdYVrjPwNMQw1ep5DkfYxZc/pdVjge6hDop+7OiBwruV62DtVk
         RduA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5V2VzcNb+boXnQnHRt6q4QxbfiztG7zemMaXsmnKHIQ=;
        b=n3s6Z+mjLRy8p0Hp4a6As1jA8AOvnIbadMorm3/nsib/iJOnjfyQaME21jMh0TH6L8
         s46b8O/iQkzdCc3LdiWurni7eab2B5clNpDQKsnKfWoZw1HPablVufCv3LP0P6uk8jKo
         oSCxZodb5TLUQM7001rMbdGXtGItdE0EZy0AtOQoqjJNKYD58hJhOtRSc15tQkCcyIol
         KZBh4t33D/YPkvmixIWKKbmzeM4gv97g1yYh0dNqQo92cL4QlwBhI4AhuoloFE9N40Uy
         3G+PHSgNFLebdMzkmSD5Hc1TZDtaaMwgq9HQ7nHOMnFZ+ecI7LCnOyIaajHl4CUUbcNF
         hLnw==
X-Gm-Message-State: AOAM530eHjtzb0il4+jgV7uk+apltUfeLzaOB0ydajJaF44hu80vCvlQ
        p5eKm6NofhBZkSI5v2Lh/gxqAEUbIs4ZnA==
X-Google-Smtp-Source: ABdhPJxpL46UOLidFyiK1K0FBL1qWPVA39O9BzI8w7wlCBeDkVgR/sVK+Do71ON6IWxT9EQ04guPGA==
X-Received: by 2002:a17:906:b253:: with SMTP id ce19mr9126815ejb.531.1620381024603;
        Fri, 07 May 2021 02:50:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a24sm3787193edr.74.2021.05.07.02.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 02:50:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] Add severity to library logs
Date:   Fri,  7 May 2021 12:50:18 +0300
Message-Id: <20210507095022.1079364-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Defined library log levels and add a new API to set the desired log level.

v2 changes:
 - Add a parameter to tep_vprint() for errno printing, insted of using the log
   level.

Tzvetomir Stoyanov (VMware) (4):
  libtraceevent: Add log levels
  libtraceevent: Add logs with severity info
  libtraceevent: Rename tep_vwarning() to tep_vprint()
  libtraceevent: Document new log functionality

 Documentation/libtraceevent-log.txt | 90 +++++++++++++++++++++++++++++
 Documentation/libtraceevent.txt     |  3 +
 src/event-parse.c                   | 14 ++---
 src/event-parse.h                   | 12 ++++
 src/event-plugin.c                  |  2 +-
 src/event-utils.h                   | 12 ++--
 src/parse-utils.c                   | 65 +++++++++++++--------
 7 files changed, 158 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/libtraceevent-log.txt

-- 
2.31.1


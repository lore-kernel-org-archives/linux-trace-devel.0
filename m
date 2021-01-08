Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD50C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jan 2021 14:32:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F706238A1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Jan 2021 14:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbhAHOcf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Jan 2021 09:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbhAHOcf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Jan 2021 09:32:35 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95F2C061380
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Jan 2021 06:31:54 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id d17so14737243ejy.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Jan 2021 06:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5OhECiRs4mpidTBclddOD2BGrRUKCQMSVN4Z7FhylPY=;
        b=eDlGKkix3XqhZlIvvLLEVQe2bKhTxWUMAwflcUxW42rK0vo13Dn+sOZuskZ87fuNVT
         Vlk1etofq/hDMCvXkrmAKh4Q1/5GuWpvKJbt4snvUT1Hl8D0OvYC6RZyd4MAiZ0aHK1e
         qL0sH0+rY58NvUKeTVyzvIZQAKjPr8HGLXAxsguEihwhRRQjicAybSz6QS2QkdOhPrvW
         rx8OajrwBfatE+blValXCW5ITXWCALsoSFnkOMtYnEHXJUsbHZNHVQdZtw/MwFZGUKMd
         Wr/Dgf/N1uLZP4L73/kr51sz6eB1np+4ah8T6s8TmMmSM41rZ2AOdUqAy3u1WgEX43tB
         3SOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5OhECiRs4mpidTBclddOD2BGrRUKCQMSVN4Z7FhylPY=;
        b=NdpuVlGsgVIdclR2c4kzmT0UjTCcflxFkZAVb5VlkDO8iGzwY3eVW3NLYW3bKkxzm2
         dL4hkN9p3dfU/B1Iw/04XO3C6HwTZGCoV4A2iHsbpEp4Y3CjLm0XssQuXQbKT1aTRIiZ
         HCwG6ySjQYeqMbejx1ub1xLEHCFk6Cfcc2rqOf/6eviKLL+X4O6rLjmyes6wihqSZ6MK
         vui1ouoM1V1bGvWPVGF8by/u2uej8QPsMECstkZDteOyvVSXwVaS3FM2SjvZQLG5DT90
         EYqJ9DWZCECGci+bOP7n+X1kSNWkxt+w6TNFJVdhUNuG9QYeUZnddCb3ykVwR3Hm1S89
         eyNw==
X-Gm-Message-State: AOAM5339zVWdnd8RRdOebe5trtK77El+Uh4Y6Xa1nw33qLTgFs4xKUN6
        gdDiY13J52xJGTqhU3sT/AM=
X-Google-Smtp-Source: ABdhPJyG/N7IfKOKHrLhOb86rpV417YpKJsfyKPVNsTI6ejaCzw5Hr/FalelSgfRhn3FnJvg//pBwQ==
X-Received: by 2002:a17:906:810:: with SMTP id e16mr2929727ejd.34.1610116313619;
        Fri, 08 Jan 2021 06:31:53 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id d13sm3588120ejc.44.2021.01.08.06.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 06:31:52 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/6] kernel-shark: Visualization plugin tools
Date:   Fri,  8 Jan 2021 16:31:34 +0200
Message-Id: <20210108143140.285037-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We implement a general purpose instruments, that can be used to
implement efficient (fast) visualization plugins. We also use
the new instrumentation to optimize the sched_events plugin.

Changes in v3:
 * Typo fixes in [patch 2]
 * The missing signed-off-by of [patch 3] is restored.

Changes in v2:
 * KS_DOUBLE_SIZE macro was simplified, based on the suggestion made by
   Steven in his review. A dedicated test case for the macro has been added.
 * Bug fix in kshark_free_data_container().
 * Bug fix in kshark_data_container_append().


Yordan Karadzhov (VMware) (6):
  kernel-shark: Add KS_DOUBLE_SIZE macro
  kernel-shark: Add kshark_data_container to libkshark
  kernel-shark: Add KS_DEFINE_PLUGIN_CONTEXT macro
  kernel-shark: Start using C++17
  kernel-shark: Add plotting methods to KsPlugins
  kernel-shark: Speed-up the sched_events plugin

 CMakeLists.txt              |   8 +-
 src/CMakeLists.txt          |   5 +-
 src/KsPlugins.cpp           | 416 ++++++++++++++++++++++++++++++++++++
 src/KsPlugins.hpp           |  48 +++++
 src/libkshark-plugin.h      |  59 +++++
 src/libkshark-tepdata.c     |  34 +++
 src/libkshark-tepdata.h     |   7 +
 src/libkshark.c             | 158 +++++++++++++-
 src/libkshark.h             |  43 ++++
 src/plugins/CMakeLists.txt  |  11 +-
 src/plugins/SchedEvents.cpp | 310 +++++++--------------------
 src/plugins/sched_events.c  | 393 +++++++++++-----------------------
 src/plugins/sched_events.h  |  50 ++---
 tests/libkshark-tests.cpp   |  89 ++++++++
 14 files changed, 1071 insertions(+), 560 deletions(-)
 create mode 100644 src/KsPlugins.cpp

-- 
2.25.1


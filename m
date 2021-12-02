Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1CAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240689AbhLBMg1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhLBMg0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:36:26 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CC1C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:33:04 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v1so115183871edx.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RibmGqwWX0ikXG5OTpzCrQk7U6R2Bo99r9O+cDNU9Io=;
        b=SOzCxuW97q93h1gYRRKojS/B5ljlVqhMfMJS89y3Hgle0G1U17BsNSkVd50sqbHGqm
         22bRF64ScHNDgbFQwesty4rd6tHqBkSyKpRaLoGOTtQfFh3H6nsp3yxUV7OMQkMOa2U3
         rV1mMqXY4BsUMDMNrBGx71GtTeBa0K6eFS/ODm/YfgiD0o+D9uWjPH8hoatCbJM9Oo8C
         o5OKHdI5w+NaRbF7samBGg/VrOhOxtQdnQmoSPgohciciXEIFYfrKNovklfr+VmJ3RH1
         qATPmjSmTFBiwqxnTQP3cOxG1rxNTClCvnMkhXUhjhUSNaPFlkdgaRI+wDPI+zNoD7ik
         pB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RibmGqwWX0ikXG5OTpzCrQk7U6R2Bo99r9O+cDNU9Io=;
        b=OpSZ+lujGIv1G6c8aPC3eghd5MkmwZuvI91sxPr7wT5hFUh5P4Fdi/IYCUMKzt2SB2
         6zBpdwx9WDCn0GlgnPWcN5PnR2erZ7qPSkZ9mjYBNpnIYCJyNPScxKI6CDi5Rzuf2zGL
         OLaX51Ek3vuFA9Az8KAXZ4BHwFHIndmWcIPfV+hqC94Eh5z4udLhJuFmCVHIZO874url
         IcJezi2vVzHuvNGTwiSD3d7G2mhZjZ77E01TddTqwa/BE1zcylGD5ZN4mwENf/VQhhAh
         mqG3/JCXKsSm2ik8DHynGb4fvHEJNdYpyNKwVQMuz+gE5+QsvUqlmv3THnyFUQ9kMhSQ
         JUNw==
X-Gm-Message-State: AOAM532sNw1Q5yanmcR9rsrHIJQoTcJ9k7grRM1IC47bhOgnsOpla2C1
        +e5Mq0zxA9Q0SDOv34bGGmcHltE+rZFUDg==
X-Google-Smtp-Source: ABdhPJziwvcPT/LGZQrkSpQw3eeyWyA/FD0j2QHFFWzcaTogglHf6M0e54OYuTRq/elK2cAu5tWyPQ==
X-Received: by 2002:a17:907:6e8e:: with SMTP id sh14mr14781367ejc.536.1638448382200;
        Thu, 02 Dec 2021 04:33:02 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g9sm2188420edb.52.2021.12.02.04.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:33:01 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/2] Get trace buffer page size from kernel
Date:   Thu,  2 Dec 2021 14:32:58 +0200
Message-Id: <20211202123300.44401-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace buffer page size is equal to the system memory page size in
the current ftrace implementation, but this may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This patch set depends on:
 "[PATCH] libtraceevent: A new API for trace page size"
  https://lore.kernel.org/linux-trace-devel/20211126034606.190816-1-tz.stoyanov@gmail.com/
 "[PATCH v5 00/10] trace-cmd dump - v7 update" patch set.
  https://lore.kernel.org/linux-trace-devel/20211202122907.44008-1-tz.stoyanov@gmail.com/

v2 changes:
 - libtraceevent API is renamed, use the new version.
 - Rewrote get_trace_page_size() to use libtracefs APIs.
 - Cleanups in "trace-cmd dump" output, related to buffer page size print.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd library: Use the real trace buffer page size
  trace-cmd library: Introduce buffer page size per instance

 lib/trace-cmd/include/trace-cmd-local.h |  4 +-
 lib/trace-cmd/trace-input.c             | 11 +++-
 lib/trace-cmd/trace-output.c            | 71 ++++++++++++++++++++-----
 tracecmd/trace-dump.c                   |  9 +++-
 4 files changed, 77 insertions(+), 18 deletions(-)

-- 
2.33.1


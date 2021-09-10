Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB24C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF6686120C
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 16:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbhIJQkW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 12:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhIJQkS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 12:40:18 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7201C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:07 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s25so3368583edw.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 09:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RRokjGN3N9yDpfNutbcrJH7RBCJFa8xLpJ4FWVd6O+I=;
        b=Dxw1tCVXc1lD3Qi1RZgSA7tc+fwQhHvfk7TSYC9Ru//pmS4AqgxEcJ/Rpi1yImtTT1
         10WhkxN5OKTERLGTnD2UQ05WNZx3rtbOjEQB/Fm0c/saWcqpFvYtIKBgDEGzv/Shi9Zm
         yDH2g7Qf5W44/AJtB8+QKipTgjVu0VgpI+vZzeM52U9luwQOZAfETp8BoHuszj6dcJLX
         APbLWRdo88mN7xuLWct8g3EsQ87brqaD5LGJ/7tF5R7LojIuiRAOe7UbLFdEGI0/47rD
         azG3zdD6fzJbJV6WPhzZbCJ4JA0q2hdkPh7nIzct2AljL6c9jGl5Xe80TG7OA4FmRuEn
         b3BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RRokjGN3N9yDpfNutbcrJH7RBCJFa8xLpJ4FWVd6O+I=;
        b=40mxdxh4i+QqdZL4KpUsYqxFaE/JPpV1n3stBrFTWAla47DhKnuyQp1gCSGOGdkNfO
         40WbUEWr1xjTLSPA/Uu8wYjjVtjFoLpnfrer3VDIFjWj7qngSl5jqkHdOKkPS1MPDhCY
         3dH/GmALPnuSpwbn2YdxpoyL+RwNJzWbVLJHi3C+bteTCywxEg4uYYG/m4efryabrGcy
         546gA2zZOrJR6nfQg/XltWr9P7F062UV3QuLPvT0Lg1tbcoCU1JOHbQCrUvxmNFbZJm5
         bkCihXxsiFqESD9g2fJ5FVLMXeyxp6SRSFxfjBTe/ua1sPGfCRaQDJgb7chgm3m17Q/W
         rtEQ==
X-Gm-Message-State: AOAM531r+mYAyXSrmTQO6fC0NR4nu3yj2RO+/xRbNw8LDl5IpIIXVw75
        2k9qxd4UoYlk3SMgmM4gtm4=
X-Google-Smtp-Source: ABdhPJzfBs7VKofXIIF/Ll31DozNDi1wFUaKWYe/vayXZZiHWGMEbsKoOlbLLwMzkLToQ7N622xB8w==
X-Received: by 2002:a05:6402:524f:: with SMTP id t15mr9961974edd.121.1631291946250;
        Fri, 10 Sep 2021 09:39:06 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id g9sm3095290edk.54.2021.09.10.09.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:39:05 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 0/4] Modifications of some 'hist' APIs
Date:   Fri, 10 Sep 2021 19:38:53 +0300
Message-Id: <20210910163857.324696-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains various minor modifications inspired by my first
experience using these APIs. 

This patch-set applies on top of patch 'libtracefs-Fix-code-indentation'.

Yordan Karadzhov (VMware) (4):
  libtracefs: Add new constructors for histograms
  libtracefs: Transform tracefs_hist_add_sort_key()
  libtracefs: Add new 'hist' APIs
  libtracefs: Remove tracefs_hist_add_key()

 Documentation/libtracefs-hist-cont.txt |   8 +-
 Documentation/libtracefs-hist.txt      |   8 +-
 include/tracefs.h                      |  27 +++-
 src/tracefs-hist.c                     | 173 ++++++++++++++++++-------
 4 files changed, 159 insertions(+), 57 deletions(-)

-- 
2.30.2


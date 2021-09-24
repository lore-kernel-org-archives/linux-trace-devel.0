Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684D2C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E5F2610CF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245370AbhIXJ6s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbhIXJ6s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 05:58:48 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A05DC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:15 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id bx4so34079792edb.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRpkqEJPm5wIy2905v9p6lQpCukqHpyaQyHBQYqb2Fs=;
        b=NsVBFx/kgl1WTBqR6AAS03uVCTs+6sJeynpuYfLiVms6hoLOffWLD14Mkilu6AVDUK
         9ZD7bUX89nLGeH3bUYG5fMDhEwRMM5YcAgEHicZi5r5JwAIohQP2JVlangIvH8NBkxU5
         6SWsH+DEx29abSm3/eNkcQmindlZUo5AtlgHZ9+EDBvrbJU50Tn1fVLbSe856q/iWRe4
         b1G/NvDKCTjfwkX1c7EoRY50xOI5rtmZd1OHrno3HxO9fpxNDF7RdV7UN8DV2qR1cQHH
         OFj4Dsf9rkl2DJFPqgBjN+AtdVGybPhnM9eGimlVP9g6ldiK4gEx5F4RpWo1kyqQc4nY
         +xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JRpkqEJPm5wIy2905v9p6lQpCukqHpyaQyHBQYqb2Fs=;
        b=UtxcU5cfrtxmUwgNFijYuFkASHjmhf68kAS6dWIZaZbX1bNRSIFkkp78RTsSYPQgQE
         6zHyT8Y6j/SO9uKLiy19KSonPHlfvHDIo58n2uNeDgh3emeatLGW0/YGUb7/C2/yGw5W
         NB4216ZOexsQ00QygMIWKXnNJZKfdnxilDPc4lNjZhRZxWfkCMZb4CWWff2ixHheB0gd
         lZMl8i8oMCzuzUegJ7FxGPcC4wuR+Wrw5Gm5bUBiNcWlmk/tGkX5PfojVqB2WmJJlwJY
         QMH/0rE7FQYpGGm7aNA2yM/W1nWYdyOykmRUD0iNLtrhydLiiker3syw2+voup4RMlzV
         sl5A==
X-Gm-Message-State: AOAM533mMXHGubMWlA1VujEEiXHaQrEqJtL8otTdFVcgNU4tsGsZoguA
        DgObNhicrVjnY1Ez2luw6uE=
X-Google-Smtp-Source: ABdhPJxHtEM8mEJFY89eY5oXR23BxNlCSSSV4AT/ngswCpSiLk7yuiu2axkUiZ3VTSRgRM3b9nnl3w==
X-Received: by 2002:a50:da42:: with SMTP id a2mr3842869edk.361.1632477433692;
        Fri, 24 Sep 2021 02:57:13 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id n13sm4635907ejk.97.2021.09.24.02.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:57:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/4] Modifications of some 'hist' APIs
Date:   Fri, 24 Sep 2021 12:56:58 +0300
Message-Id: <20210924095702.151826-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set contains various minor modifications inspired by my first
experience using the 'hist' APIs of libtracefs.

This patch-set applies on top of patches
'libtracefs: Fix code indentation' and
'libtracefs: Fix add_sort_key()'

Yordan Karadzhov (VMware) (4):
  libtracefs: Add new constructors for histograms
  libtracefs: Transform tracefs_hist_add_sort_key()
  libtracefs: Add new 'hist' APIs
  libtracefs: Update 'hist' documentation

 Documentation/libtracefs-hist-cont.txt |  30 ++++--
 Documentation/libtracefs-hist.txt      |  80 ++++++++-------
 include/tracefs.h                      |  26 ++++-
 src/tracefs-hist.c                     | 132 +++++++++++++++++++++----
 4 files changed, 207 insertions(+), 61 deletions(-)

-- 
2.30.2


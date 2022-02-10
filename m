Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C530C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiBJPXy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:23:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235764AbiBJPXx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:53 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F38CE5
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:54 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v12so10272676wrv.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QwgeIKW8PaMYJi9B+nP0by14TdMX3dIluPT+zTHQ5Ts=;
        b=AQALUFArR2EjSAZQwLIEgfMsoG3nrwdWFpyWVNQ/9KhmF7sXzw8/4zPwPAfyzJlPeZ
         BuXE1fsqjh6SDXNVmCzFWYYipXnUxUZVDW0yI7QzfhjC2pHrSzc7uq5dgyQD3X12/jgs
         NvkS8la76O9cKufo3WX7mwi1gskikU4C+EII8FAFOM383wbFDJ7+yGZTAgJNghp994UN
         1+KbVbdm9SN1N6feR/VADdrT2gSWJoXzfDhd3bstPxg5qfbCGPxbZCBPjHD+7LrBC7kb
         FAYIc3DF5kZxAAezljgzsshZFcCK0QKtGZZg9TkZvwfBpNNCAIPayTb4L0KMRKUqB9Aa
         D/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QwgeIKW8PaMYJi9B+nP0by14TdMX3dIluPT+zTHQ5Ts=;
        b=SJvvfSwU/KYHwLoxYy1wwKNNHrBEwcV8BZlY0QdBgSt8gPnQkto1xRaFP6WIaRt9Vd
         sNARSvBgS3eZCp0UQbcCDRijVRla/0NjuQtVsN7expoP8j7G9Z41I5FBybiPbMCi0HvW
         7f4DfaSl9ZrjsZ1DU0v4c6yy2r/Z92hpMYYnij1mMv3aZccwcKyrLpNJMPbMJM4/qMwG
         vjYElLbgVVsxaDSUoCa7PTxBoRCbe6a7oUuASASPofazRndqUTPSLbRuFr+vxRX7PVHw
         eVKkvndDjpbFDZiM8Xz8ELktrxe6gc76IfzGArYrqzd3uNdQZX4eKBy5+JlywvEn8FJL
         hsiA==
X-Gm-Message-State: AOAM5309eqOSAGg1QX2LL+EULfDbUdA9IZb4vMul203BLj8un42W3cpx
        izVx90tbuuwtGBS2vqQfXscZfZOmW+w=
X-Google-Smtp-Source: ABdhPJww/TMR3lrGhmYTALJG2d1TjQlOjuTx5VfrODACJoCWfgOT0we3fqhizUVfupIt1/AehdHY9g==
X-Received: by 2002:a05:6000:1866:: with SMTP id d6mr6624878wri.309.1644506632876;
        Thu, 10 Feb 2022 07:23:52 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:52 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/8] trace-cruncher:Fixes before v0.2 (Beta)
Date:   Thu, 10 Feb 2022 17:23:31 +0200
Message-Id: <20220210152339.363943-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (8):
  trace-cruncher: Prefix all python class names with 'tc_'
  trace-cruncher: Fix bug in the constructor if tc_synth class
  trace-cruncher: Add tests for synth helper APIs
  trace-cruncher: Code cleanup in the constructor of tc_synth
  trace-cruncher: Rename python function argument in PyFtrace_eprobe
  trace-cruncher: Add tc_eprobe class to ft_utiles
  trace-cruncher: Check kernel support in the eprobe constructor
  trace-cruncher: Add more comments to the examples

 examples/eprobe.py                            |  23 ++-
 examples/hist.py                              |  32 ++++
 examples/hist_oop.py                          |  24 ++-
 examples/kprobe_open.py                       |   6 +-
 examples/synth_oop.py                         |  14 +-
 examples/syscall_trace.py                     |   4 +-
 src/ftracepy-utils.c                          |  50 +++++-
 tracecruncher/ft_utils.py                     | 144 ++++++++++++------
 tracecruncher/ks_utils.py                     |   6 +-
 .../tests/1_unit/test_01_ftracepy_unit.py     | 100 ++++++++----
 10 files changed, 295 insertions(+), 108 deletions(-)
 mode change 100644 => 100755 examples/hist_oop.py
 mode change 100644 => 100755 examples/synth_oop.py

-- 
2.32.0


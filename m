Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C24EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiA0HBQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 02:01:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiA0HBP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 02:01:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C10C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:15 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id n10so2313054edv.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDCeiPRyMVUpGOZvWWIQXtffI5Kov3gVLihlQK23wvs=;
        b=PWZt//uJ6B74xKrPzlGxjpyQsVfaDgY1b+zzddCg37GgDYuhHxRK4FbwsXDYI0HahU
         fOfjRquM6/CqIIL5opgIbpYH6C4vo5bX9FkbzjXSqyI2bxX0d8/25R9eln4CMhonJl/7
         MBFMzIJNNO1ERs/syICh+C9WuPj/4F2dHtL27oRd023+c1LS4EBD4T5dbPSHxfVTB9Fn
         xKjb4MwD09YuHbfTt70LLeLpo9af5Wp0sFihdoFLFVKjTZhq1BAANwhmxpCL1ZsDD1DZ
         fzoj7DxPpiQaHWxme0WtJP4bnYWRJjdbx4QkNkB+G48vKFhsGH4Z+recqyFeAMJRriRs
         DhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yDCeiPRyMVUpGOZvWWIQXtffI5Kov3gVLihlQK23wvs=;
        b=XbTpW41u8vpy3zbq9nh3eTGiMmqaRFzN58Ct7jn4But8WX4TofsC84dtrnOGVALepE
         F77xSbJb97K0r+eymMgdpR6R3Nj/GNpQSAVFu8htxgWT+Ch0IBie6Fb1vTFvDVQ5+HYs
         WESaZdOF7J+Mu27qUdPuu7CUlaiUVhvYryQVNE9AeDUOe+Zdh5bLLPlB8MOKq4TvpTeP
         8G8RTpcB8uXH1c2nkw6uBvPk7/MBQ+ItBzaBhXoPnqr7TO3jWNF0mHQA+ZRRfugPiHuI
         JWGN4muft5w4XcPN3e/lAlWZh5iDbJlAzYvf5t+qr3ONZoCLrQonM/IgDDFznZjBblFJ
         NSSw==
X-Gm-Message-State: AOAM530OQ5TzsHgbLVf4rAbbtRfZEdUc8gmRPpQqfif8IVFafxbfpy6X
        gep5C9YOhDt3m1aFGZKmuKE=
X-Google-Smtp-Source: ABdhPJzHXQ6ceUtSNl9PlBWK9djKPwYMwA9XJTXc3Ntw15JPnziscgSnH/ZASacM2FEaEuLOzVJxHA==
X-Received: by 2002:a05:6402:50d4:: with SMTP id h20mr2393969edb.90.1643266873596;
        Wed, 26 Jan 2022 23:01:13 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i17sm8317079ejp.60.2022.01.26.23.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:01:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/3] trace-cruncher: Add support for event probes
Date:   Thu, 27 Jan 2022 09:01:08 +0200
Message-Id: <20220127070111.27529-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Event probe (eprobe) is a new type of ftrace dynamic events, introduced
in the Linux kernel 5.15 version. It is useful to have support for them
in trace-cruncher, as it allows more flexibility when printing event's
data.

v3 changes:
 - Added eporbe example.
v2 changes:
 - Rebase.
 - Moved unit test in a separate patch.
 - Added a check in the unit test if the kernel supports eprobes.
 - Renamed the API from PyFtrace_register_eprobe() to PyFtrace_eprobe(), for
   consistency with the other dynamic events APIs.

Tzvetomir Stoyanov (VMware) (3):
  trace-cruncher: Add support for event probes
  trace-cruncher: Unit test for event probes API
  trace-cruncher: Example for event probes API

 examples/eprobe.py                            | 29 +++++++++++
 src/ftracepy-utils.c                          | 32 ++++++++++++
 src/ftracepy-utils.h                          |  2 +
 src/ftracepy.c                                |  5 ++
 .../tests/1_unit/test_01_ftracepy_unit.py     | 50 +++++++++++++++++++
 5 files changed, 118 insertions(+)
 create mode 100755 examples/eprobe.py

-- 
2.34.1


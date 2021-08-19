Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3681C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 943C861101
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 13:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhHSNJS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 09:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhHSNJR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 09:09:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3A8C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:41 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so6794113wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 19 Aug 2021 06:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRWV26ENnn7OnzYmPTlhNp5zElgnbsk5UYBPrILC08o=;
        b=ZSHQkYvIDO5yWLowH4wF7+dFNBSHfs4HkVF+n14jOBRBIaR6NnFy/lIeYozLygk5lE
         T3InTS2+1+1W+2nev1q+dSvfH5kKaWrFzPX+DM8Z6xEHyMiakPVnY7RGUEqkMKqbWRFa
         HJBfpVxajkwnoJ8SokCrz9zTXx6H9tNqfGSQxZoxq6Gv3bMpG+FO89Y6z3oNb7KTWJIQ
         AdX4WI5nbYSiqjU12X4m3LLk4nTbZMLlgyyioVGl8c+8AosQswwoXRY4jXV0huhqiZK2
         PfaN5HzrtobqbqeLXVo6xbRmd6yDaCTNZ3lqHJOA+c7rGpbUXsyHyrTRHGpqBvrkuE4M
         T8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eRWV26ENnn7OnzYmPTlhNp5zElgnbsk5UYBPrILC08o=;
        b=enNS3a5r88uRzMB9gp4oAQkJaIdywR+yLVXxCqtFHLCP6DDQ0f487PWtD/YqKauuoP
         AS41ce3avyZhHjoid7nmtg1RWfVk6OB0jhzxXAilceEo6c2FcYUf93OlJgl7rndHxE+d
         QV/eQLgPNBMYj7/WOVLnXaImckgPpRoPGqTERkMjHgGnZjCYj/ooCFROQD7kkyd1lxi0
         +qVMyTamvSPZT8FI3HDIaJLha/GtgIQiixqhji28WvxL1iodNQt2/FvWKb+z95ELVa2K
         Cm7Qz6jwEMB59gnAG4ivddUlo96QXYLNVga1zXoJ+zfqJfMsl61TfdQ/YCHtcHInHlUM
         Y7Zg==
X-Gm-Message-State: AOAM5305y++fiP0l/Tugd74jE9V7E3AFzkr7ViHay5M3wQwoaOy3KZqS
        vs0s/TJ2QENrUFHsuU4z0WuwVqpuwok=
X-Google-Smtp-Source: ABdhPJz1SByI5xCec+Zvi1sX423MlMAyc0W5nepLHLSLlQmKwbAF9CDCN8JrywNsfHa30y+vLVJ5QQ==
X-Received: by 2002:a1c:f206:: with SMTP id s6mr13382379wmc.102.1629378519808;
        Thu, 19 Aug 2021 06:08:39 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id f17sm2889978wrt.49.2021.08.19.06.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:08:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/7] trace-cruncher: Refactor instances and kprobes
Date:   Thu, 19 Aug 2021 16:08:20 +0300
Message-Id: <20210819130827.12327-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We simplify the way kprobes and tracefs instances are handled by
the Python module.  The need of storing all kprobes and instances
created by the module in a binary search tree is eliminated by
defining new custom Python types for those objects.

Changes in v2:
 - Adding patches [PATCH 3/7, 6/7, 7/7]


Yordan Karadzhov (VMware) (7):
  trace-cruncher: Use proper naming in common.h
  trace-cruncher: Add type checking for the custom Python types
  trace-cruncher: Allow for detachable custom objects
  trace-cruncher: Define Python type for instances
  trace-cruncher: Refactor the way libtracefs instances are handled
  trace-cruncher: Define Python type for kprobes
  trace-cruncher: Refactor the way kprobes are handled

 src/common.h                                  |  34 +-
 src/ftracepy-utils.c                          | 669 +++++++-----------
 src/ftracepy-utils.h                          |  65 +-
 src/ftracepy.c                                | 145 ++--
 tests/1_unit/test_01_ftracepy_unit.py         | 288 +++-----
 .../test_01_ftracepy_integration.py           |  56 +-
 tracecruncher/ft_utils.py                     |  14 +-
 7 files changed, 530 insertions(+), 741 deletions(-)

-- 
2.30.2


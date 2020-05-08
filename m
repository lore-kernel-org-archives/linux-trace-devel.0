Return-Path: <SRS0=aZMu=6W=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FEAC38A2A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA30214D8
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 May 2020 15:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpXyOHWm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEHPXT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 May 2020 11:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEHPXT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 May 2020 11:23:19 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9EEC061A0C
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 May 2020 08:23:18 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a4so1712742lfh.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 May 2020 08:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLOvHFDeWhXxl36kILM44nOItFQFwoGziUl+Bj/XlGU=;
        b=FpXyOHWmYIxkZ6sJHu57OJi4I5Nk9w5g9MpKX/ekmYzPOi/GJoNL6p71WpqxTq+MJM
         KRkFjsQJu7/BqT08FT1bduaQX7FoDge5jgVj/8mWCz3FLbgPm/wVUP5ENzrgA0VVOJSB
         vMN32xy0EPWM8oZaNNswz8ct3WVuw2FpZDVq6ETqWdMmOFsDuzPRJvcO62N4zw7VABJb
         KXuconR5AMMX/AntRrPkcbOgJOWdEtXcjE/yWncH/aUowcBITcHRZ/H1Zmz/CEYGYZ8W
         KoIWk3fS5AsILqKsZWkUTMcYAx5U5lbUiWUVk2PrTwCbwDgb9vP+qEwZf6SkJKOws6tY
         7NtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LLOvHFDeWhXxl36kILM44nOItFQFwoGziUl+Bj/XlGU=;
        b=cRwrfW951Y5js2RUREAFMj5/pZi8adf7SUuVAmeNlZa2gmHn9qL8wzMKiJ5kBUzk92
         lkFu+e7N9PNa5mNVpeTqB/onK6flKDhC7Ul7BdJks3rgaxdcg7tWttE0o/Wz7sMQmgJL
         aUnVwkJx+p7aULQqW5IB0iA5RxFYInOpPb5fj9fprSh5wEU40P5Ihbdi69DY4AkPwk0r
         UI4y+rKov/TsD6SQcqPk41c9OlYlPcdG3m0qs6ihQrh1Q4zF1qT8JOVs75TDz3csPcy1
         h3dkJjt2cxOkiH5Z1EJGCdhs21udQo2Q23xc5dmVYvWcYXOZtj/6KVwpfXCSTRJ4GowG
         XYDg==
X-Gm-Message-State: AOAM532zPZl0viX4eMNVsLBye3+5ImL+dkKn/YklkI4LtDcHB5hkrLqr
        9y73dwDjLAIrd3AkLpY8jP1CtLP+f8c=
X-Google-Smtp-Source: ABdhPJyN31Z3TQYdKLjzPDBuUItQy8F3d/EhZvshkCqPxCdodikTLx2fhc/Hd5Ggbat2Im0OMzMFaw==
X-Received: by 2002:a05:6512:46d:: with SMTP id x13mr2278045lfd.56.1588951396918;
        Fri, 08 May 2020 08:23:16 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id q20sm1466497lfm.35.2020.05.08.08.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 08:23:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 0/3] 
Date:   Fri,  8 May 2020 18:22:59 +0300
Message-Id: <20200508152302.27843-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The patch-set implements new commandline options for KernelShark that
can be used to pre-select the CPU and Task plots to be shown, before
opening the GUI. The idea was suggested by Julia Lawall.

Changes is v2:
 - Fixing a bug in the parsing of the string representing the list of
   IDs, given to the command line options.

 - New Patch 3/3 that limits the number of CPU plots shown by default
   when KernelShark starts. 

Changes is v3:
 - Switching to using comma instead of space for separating the
   Ids (Pid or CPU) of the plots. This way we don't need to worry
   about quoting the arguments.

 - Adding to patch [2/3] logic to handle the case when the user uses
   the "--cpu" or "--pid" options multiple times.

Yordan Karadzhov (VMware) (3):
  kernel-shark: Add methods for selecting the plots to be shown
  kernel-shark: Add command line options for selecting plots to be shown
  kernel-shark: Set a maximum number of plots to be shown by default

 kernel-shark/src/KsGLWidget.cpp   | 13 +++++++++--
 kernel-shark/src/KsMainWindow.cpp | 39 +++++++++++++++++++++++++++++++
 kernel-shark/src/KsMainWindow.hpp |  4 ++++
 kernel-shark/src/KsUtils.cpp      | 24 +++++++++++++++++++
 kernel-shark/src/KsUtils.hpp      |  2 ++
 kernel-shark/src/kernelshark.cpp  | 34 ++++++++++++++++++++++++---
 6 files changed, 111 insertions(+), 5 deletions(-)

-- 
2.20.1


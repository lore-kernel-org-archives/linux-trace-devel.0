Return-Path: <SRS0=fBth=A4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D890C433E2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 082AD2074B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Jul 2020 08:03:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fLPIshEx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgGQIDa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Jul 2020 04:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726855AbgGQIDa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Jul 2020 04:03:30 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C073C061755
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 01:03:30 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dp18so9788958ejc.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Jul 2020 01:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zTRm1pc4WM6Vqk2nByxT6u9yYq4sNdHtHcemIm/r8LQ=;
        b=fLPIshExpYb5CrH6sSe7t+tlCWOql0fBjyo4P3Quda99a7y2N6qu8yyKK3Ey4Qsc/r
         ryIVO3QZ3s1WvZlbZikn9QetLdC7/jKAiopiXizAydq4mImmuJ8GP05Y7LZPWqr1gnMf
         I2EkMR7hMYJZgBgw2UcsPnt6SF3vaqKeXPqjhGKZ+rb9hYHVTgVnbq1rZNwAb/pkPrJK
         wM3yl8R5IQub5hyO7mCy5EvgznS8HtpTywq8bDidZoglS6G1Dom87VczLBRDEMBT1kmQ
         byZ2EvsiVLbjTv7Eabc9sf40yX02Qxuepam2WZ1/uHwFpRFF6MONmtpj8VbX/61w72LQ
         ucOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zTRm1pc4WM6Vqk2nByxT6u9yYq4sNdHtHcemIm/r8LQ=;
        b=ilmMwwY3XN60aEqTXylB0fojzqZOFSvcqyTcgJgnz6h1/liXTu/xvD5/eXEudsALm0
         PH5uy8HxN1k6/zXTil3nv7ijnE5dFvSpKWNXGxXnkYBQGTQyLpd3po+eqr8Rjp23b8O+
         gdhtQ6O+7Nno8oYFSPh+VAHX8UVDYTE1Ve9nBpY3MLFnErFmzpC1YDTLVpzr7IDLZ9g/
         I9fPlDNo/R6/9CKtPclUVAO1Kip/h3m+mYFX45hKXjicE7s2HIjlopj2xUBGbjM9E4BO
         ul0RLcIlxhvKV1FOyc4q+oe/Ma+WCb+13zvjlNmP4ROVQwN1cB1jE3orOlM489Zf1sls
         dwEA==
X-Gm-Message-State: AOAM532Gi7PSbouljZnz3yIXrfVHT/zVx6aZ30gx4cm6DAZEkng1zraP
        Dy8RG73bwLMMugQixmiF1wE=
X-Google-Smtp-Source: ABdhPJxKh7lHEMhiP8U6EC1yufo2JyOoCcnbfOyg+jkhKhwmBXX+XQ8/2Ttg8Ix95QTM7xI99SxptQ==
X-Received: by 2002:a17:906:f20d:: with SMTP id gt13mr7583961ejb.117.1594973008888;
        Fri, 17 Jul 2020 01:03:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s13sm7186074ejd.117.2020.07.17.01.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 01:03:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Enhancements to trace-cmd clear
Date:   Fri, 17 Jul 2020 11:03:24 +0300
Message-Id: <20200717080326.82151-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added new options to trace-cmd clear, alowwing it to be ftrace instance
aware.
Implemented new tracefs API for iterating over the configured ftrace
instances.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Add new tracefs API tracefs_instances_walk()
  trace-cmd: Enhance "trace-cmd clear" to be instance aware

 Documentation/trace-cmd-clear.1.txt |  13 ++-
 include/tracefs/tracefs.h           |   1 +
 lib/tracefs/include/tracefs-local.h |   1 +
 lib/tracefs/tracefs-events.c        |  14 ++--
 lib/tracefs/tracefs-instance.c      |  52 ++++++++++++
 tracecmd/Makefile                   |   1 +
 tracecmd/trace-clear.c              | 124 ++++++++++++++++++++++++++++
 tracecmd/trace-record.c             |  24 ------
 tracecmd/trace-stat.c               |  52 +++---------
 tracecmd/trace-usage.c              |   4 +-
 10 files changed, 214 insertions(+), 72 deletions(-)
 create mode 100644 tracecmd/trace-clear.c

-- 
2.26.2


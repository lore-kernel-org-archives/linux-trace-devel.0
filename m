Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F263C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05439208C7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 08:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qEEDpkAq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgFRISk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 04:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgFRIS1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 04:18:27 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84788C0613EE
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:18:27 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id l10so5027059wrr.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 01:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoK5djW3FOTZZaz5vgGrwKRdBl8bqyCJ7EHWsStZEjY=;
        b=qEEDpkAqsiclQWA+KOROMawh7cwm56lXhjk8J6QRvAEoaAda4gmIKfwB0TJSa5qiIF
         sLqxws2LR5QcKuDLFom84sNT3LRAtsOYBNMODMjZ1QQ3imP858c7DBKlx4rwlF+mXV/W
         EZNA25d26XHRMh3xpAHIggRH8Y9Q3B7umfIwSPZzuPah4T7+dK39UnGwhIFYQ51qHonx
         gwJuqm+UUkOlO115jl2HRqXffn9Woxg7lb7Y/AWQ1JyoKRUQr21C0Xcw4rZVOxDwHUEf
         28BT88PsoMP+DRV8LKjaODhQopHgMauEej166jLdb2JkLE1wZvY3f4ifZ+7h9GU/Goi8
         8bxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AoK5djW3FOTZZaz5vgGrwKRdBl8bqyCJ7EHWsStZEjY=;
        b=UvdNbmBLsHnZQTKPQfv2/KRmRqtwoZjDKHpF/uACRqz4OXILiSwsfek35cWEBg64w3
         w7szN6ZryiE/yssOrSdMDYdTurB41VrJn6MtnQtKEu5OEegn5gHY2huLDer0rr+hnqim
         Y5th/wy2FdvdsPqdhQn+7k0Zd/vbWcasVHX25sNHiXwYoq/hvGl/aFQkvem0Nu6xK5Ax
         T+E5U5ev50IoxvYClNI5f7NOLh58EfGAe8Kj11JiwU+45AfZuw67d+57tvuMpSokCKSu
         FmTBWiJAr/kHiYkt+RCdNH8u5q9+adkKIEXroxZiTyox70pVg15BS/n/RXY3qVix/O+E
         7GHw==
X-Gm-Message-State: AOAM530dLQ0/KkzcWzZbObEK9W3okpxP2o8vkpFag6lCFn/4rBwxJgKO
        lCZgbFToPnt2MS3mqL96N7KqnE5kZCw=
X-Google-Smtp-Source: ABdhPJxmoUp8iJZQr5Vv+kUGjA7PlEIaqSP4c2CogENY3nvAQZHDjn0TobVxNFjh6O58DWRWuKyrSg==
X-Received: by 2002:adf:afdb:: with SMTP id y27mr3175560wrd.267.1592468304830;
        Thu, 18 Jun 2020 01:18:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a1sm2675811wmd.28.2020.06.18.01.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 01:18:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] [POC] Add support for uprobes
Date:   Thu, 18 Jun 2020 11:18:20 +0300
Message-Id: <20200618081822.158674-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial trace-cmd support for ftrace uprobes.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: [POC] Add APIs for extracting DWARF information from a file
  trace-cmd: [POC] Add support for uprobes

 Makefile                                |  19 ++
 include/trace-cmd/trace-cmd.h           |  24 ++
 lib/trace-cmd/Makefile                  |  12 +
 lib/trace-cmd/include/trace-cmd-local.h |  13 +
 lib/trace-cmd/trace-obj-debug.c         | 340 +++++++++++++++++++++
 lib/trace-cmd/trace-uprobes.c           | 390 ++++++++++++++++++++++++
 tracecmd/include/trace-local.h          |   2 +
 tracecmd/trace-record.c                 |  79 ++++-
 tracecmd/trace-usage.c                  |   4 +
 9 files changed, 882 insertions(+), 1 deletion(-)
 create mode 100644 lib/trace-cmd/trace-obj-debug.c
 create mode 100644 lib/trace-cmd/trace-uprobes.c

-- 
2.26.2


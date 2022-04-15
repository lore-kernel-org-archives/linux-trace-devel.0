Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CBFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 04:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241474AbiDOEMo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 00:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbiDOEMn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 00:12:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE1A43386
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 21:10:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id t11so13451090eju.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Apr 2022 21:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DYYS6dI3q/Szkpsg8MTtHmakqjn4zH0hDR+CVogPh4k=;
        b=AynCrF4RS5LvhRmFaJQ9z+q91PYmaBHEI3YBnf2uPcTqogw2sNK9G9ajzrnGXrTKMr
         SrIQ8Qhfrsq3b3c0U87WHU075mO7g2m/hU9Qa+FovMyrpsqFF41hT8HlgKf0eZLjvNbj
         JKiAA1NtQaUIPvK81qBNn6JupcebJvq4d7Jc2QxsQ6hzPj7SlHiBaxp3iAlpIV3TLd6K
         7Cp8JTmChoe7WkEAo1LwkQvtIHklOCmCfbwZ2zHp/+ISEbCBN683q0sVGhhrGYrpzM0R
         WqAK7yabRX5Bm+pEDHXxMzn1V7jfo4k0Go9+ZFymSGWI+FjHXkgOC6lIFnoBoH0wIt2/
         meLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DYYS6dI3q/Szkpsg8MTtHmakqjn4zH0hDR+CVogPh4k=;
        b=3Qhhnm2NAL733sl6aJNssL/DPHUnHgYxPVeGdTY77KkVqpxkYbykdtcA8VXHhvl/vU
         0lnFrCWB4gOegbWJQvL4b/hT3aNaJoXlfMBL9YrnDRud5s9ME+zAd/c/1FM2WZcgFL0s
         XcUUpkof+3Xj28DdTrP1hkF5BUfNwW7PJsLa1DiIXQEo/wIY2gQzqVI/GKZJBP5GnH0J
         E5aWXdYDDTJTcRhYJlRbu9rHeJtCim51KDU2EYuf7uhrhwK1uAvc1IdcxijovNOB+UxC
         Hb43P+raSORt/ZaqSzVSLSXkMK2GHdUj/do116FsjdAPvC6EsrM0bZMfe8dTjPK9WNRq
         FsPw==
X-Gm-Message-State: AOAM533SyLliYOEiD4a7Czo9UL2tzTXFHleJzh1hFv0u23DQ7z/5HKHA
        t54N2fSAVFO8D/edRbXz1co=
X-Google-Smtp-Source: ABdhPJyb/KL4//PMmlwZSnsy31+z3A7CSWBWEiPTdgqo3EYoruZkg2oyDBwilmtPTajr7tTu5wpnZQ==
X-Received: by 2002:a17:907:7209:b0:6da:9781:ae5d with SMTP id dr9-20020a170907720900b006da9781ae5dmr4552903ejc.73.1649995814218;
        Thu, 14 Apr 2022 21:10:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id dd6-20020a1709069b8600b006df08710d00sm1255724ejc.85.2022.04.14.21.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 21:10:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v2 0/4] trace-cruncher: ftrace uprobes support
Date:   Fri, 15 Apr 2022 07:10:08 +0300
Message-Id: <20220415041012.36151-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace uprobes can be used to create dynamic events for user functions.
Tracing user function can be very useful functionality for trace-cruncher.

v2 changes:
 - Moved the uprobe C code into the ftrace-utils.c file.
 - Reused internal functions from ftrace-util code.
 - Renamed utrace start and stop to enable and disable, to be consistent
   with the other APIs.
 - Do not call utrace disable in the urtace example, as this logic is
   triggered by the destructor.
 - Changed the logic for allocation of internal dynamic array - double the
   array size on each reallocation, instead of increasing the size with
   hard-coded constant.
 - Added support for running a program with arguments for tracing.
 - Do not run the program for tracing in a separate shell.
 - Coding style fixes and optimizations.

Tzvetomir Stoyanov (VMware) (4):
  trace-cruncher: Logic for resolving address to function name
  trace-cruncher: ftrace uprobe raw API
  trace-cruncher: High level wrappers for ftrace uprobes
  trace-cruncher: Example script for uprobes high level API

 examples/user_trace.py |  43 ++
 setup.py               |   4 +-
 src/ftracepy-utils.c   | 676 ++++++++++++++++++++++++++++
 src/ftracepy-utils.h   |  21 +
 src/ftracepy.c         |  45 ++
 src/trace-obj-debug.c  | 982 +++++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h  |  54 +++
 7 files changed, 1823 insertions(+), 2 deletions(-)
 create mode 100755 examples/user_trace.py
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h

-- 
2.35.1


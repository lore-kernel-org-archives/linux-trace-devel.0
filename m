Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A16DC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Apr 2022 11:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352700AbiDOLoO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Apr 2022 07:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiDOLoN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Apr 2022 07:44:13 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443A6644D0
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 04:41:45 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bv19so14972847ejb.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Apr 2022 04:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RbbcjpUvnn0qOWQJrbKT1Ht2YozBJDzaOWNtZetdPFs=;
        b=To0kY52EKOOnoGHDuZYCLhavyuNxpS9/g4V7cZR91garCIyPubploKyfwjTgrEjilY
         H6f0+KNCUa26bFkFayGoo9lpSW+FM9l316UvScUa0TMNmBlYVkJpQSRpTVs4pn+uJlEt
         Hl93NH5TsgnjS9TZ7ll5vxwEV+Dt0yqaSTTC8gE6TRyTsAia/gYUH2rrHa70fjVFyL/y
         mpZ7f0CjHiwxFizHJJnCwIRGy9jZn9M9oY/2eXMBQqJt6WR62gHHEPbH4E3ay3pTe25R
         9lp2wDlelyGp4JlpsHYIHDHyo9LkoN96Ydm2Wg8Wj2OfOJqqWV14Xuar9Xi3cN+/gMVX
         E68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RbbcjpUvnn0qOWQJrbKT1Ht2YozBJDzaOWNtZetdPFs=;
        b=7H47Zqs2M06LoG0IQLo4saml4mczSo5N/dvZ2ZJHLlZsXvDeuBSqykz9BLix/PqLGP
         CjzbC40tj1lJA3HWu9kvg5zLbVnoN7NzXtjoZnPJ73+ymR9AfH2sZ3MjmkiA+X1QrQ4M
         sZcC9RmoCmzLOw0A7MyWMytlpeoT+WFrtISXizQFtfDZLrTYj5TOyi8Am95TRVD8Nl5W
         KAqNEzwmaB8g29NRuajxmXJPZdcB9ljyCOpz+TKrp8ZBdg7t6dF3RWNvHOI2Kw5ZRF37
         weO4IrM37l6H+xTK/aPxlF1gmdDuTLEpDxrBUtHzTms7HqbuMquhCoskJxDuur2th8uB
         XoBg==
X-Gm-Message-State: AOAM530ugEBlUmoOZQxVNgxOMPwboKHxAdeb7jvnuBmmbEmkw17woBOs
        1oF59/P8nO8gpUm/IA0YiRefrGrqr+k=
X-Google-Smtp-Source: ABdhPJyEg6qpYSHbg0IFVbI3wDVhSqAzQuRbgysz3ozOCBJ5q7IXWeqgSProwBIrtEjSmu8P6nkZEQ==
X-Received: by 2002:a17:907:7e84:b0:6e8:b7ce:22b5 with SMTP id qb4-20020a1709077e8400b006e8b7ce22b5mr5801941ejc.763.1650022903716;
        Fri, 15 Apr 2022 04:41:43 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7-20020aa7cd87000000b004207282701fsm2462878edv.63.2022.04.15.04.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 04:41:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v3 0/3] trace-cruncher: Initial support for perf
Date:   Fri, 15 Apr 2022 14:41:37 +0300
Message-Id: <20220415114140.64468-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two major functionalities are introduced by this patch set:
 - VMA <-> function name resolving, using bfd library.
 - Support for Linux kernel perf framework, using perf library.

v3 changes:
 - Renamed some of the methods, to be consistent with the trace-cruncher
   naming convention.
 - Coding style fixes.
 - Code clean ups.
	
v2 changes:
 - Renamed a lot of APIs and internal functions, to have more consistent
   names and prefixes.
 - Added support for staring an application that is going to be traced.
 - Added support for setting the time duration of collecting the traces.
 - Handle ctrl-c into the C library instead of the user application.
 - Coding style fixes.

Tzvetomir Stoyanov (VMware) (3):
  trace-cruncher: Logic for resolving address to function name
  trace-cruncher: Support for perf
  trace-cruncher: perf example

 examples/perf_sampling.py |  53 ++
 setup.py                  |   9 +-
 src/perfpy-utils.c        | 906 +++++++++++++++++++++++++++++++++++
 src/perfpy-utils.h        |  43 ++
 src/perfpy.c              | 141 ++++++
 src/trace-obj-debug.c     | 982 ++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h     |  54 +++
 7 files changed, 2186 insertions(+), 2 deletions(-)
 create mode 100755 examples/perf_sampling.py
 create mode 100644 src/perfpy-utils.c
 create mode 100644 src/perfpy-utils.h
 create mode 100644 src/perfpy.c
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h

-- 
2.35.1


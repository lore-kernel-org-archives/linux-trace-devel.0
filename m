Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDB7C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 10:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiDHKGU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 06:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiDHKGH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 06:06:07 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BB5A2057
        for <linux-trace-devel@vger.kernel.org>; Fri,  8 Apr 2022 03:03:45 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r13so16304112ejd.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Apr 2022 03:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lYTa4+rcQlknMlf12UYK5H53zs+SQ3xZtd7225JSKrE=;
        b=hGrCZf19AvHIClkLz4bFF4iTzsCVS3XGTQWfUMdxpuDh18/skEvh9TmniCZIrZ+dEr
         Adw9y6clsB18IHtcsbq+IJ7q/W6WsBcdQpEOG/G17Rp/SA743yT2dcsveiarn+mPOG+a
         cuXrVkZbE0nwOKbidtiriZn8z8scT5MnQAcEeyxdmCyg80KQw/EEIL2ZO6lLEMDBfvkX
         o8vZii83jT1DUIKk1hZqKyg/1VjohZ8mHe37BKZmqP0+BJNDdkQT2v544Igzi8peKg2J
         3MC8SpBdAaqNMwh4R+111aVhknVRzN+8Ovhj/zE+KARbZIq4AMdkQ6G7fFVlQfVI2U8U
         ki/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lYTa4+rcQlknMlf12UYK5H53zs+SQ3xZtd7225JSKrE=;
        b=vaUWz3RtVDdddJ5GQODwHwJA92VAwcHDUPOBKs3OvFrRDzIGPZKL1UO6ZWiuLF14sN
         wJ7pYR9MbvaAenYq3zXdPSqSp0cPgcLhbByxN6ewCEa+t+0OaTUmkXTLTjyinqd+r4Gs
         N5B9jRDlRPkxLqPWweQeRHEco3nzKbIuFnQRi2tfNRM9roE2QIuQAo8t1QNGfTinN8Cx
         Q7gSBe1LnhgPMy1p7H9JAnhMs9fRujOLnJ3pI1wkjzNOE2ko02vZH96KuO0BfwV2BmvO
         Or2MfZQhGNqFsIHNwjz1DTq1Xq0khJCXy0JY42nmt5cDPc+6SnXY3OPPPor5rz4k+whM
         ovUQ==
X-Gm-Message-State: AOAM530HnO9NZKiQ8aGcN5Jii0usQmZp5rujbXwPCP58uS0qGQyVmcZA
        cXUPforxoz4cZVBs6GD3townLiD6sXo=
X-Google-Smtp-Source: ABdhPJysmkj+qljXWUz+PxxjTwRo8vj2rz9UbZdhhCOL04xNOQ1hUkGOzcTzB5iyAavRStSiKlLAWw==
X-Received: by 2002:a17:906:e0cf:b0:6e8:5728:e376 with SMTP id gl15-20020a170906e0cf00b006e85728e376mr1205986ejb.134.1649412222612;
        Fri, 08 Apr 2022 03:03:42 -0700 (PDT)
Received: from oberon.zico.biz.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l17-20020a056402231100b0041d0718a3e3sm1860369eda.23.2022.04.08.03.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 03:03:41 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: [RFC PATCH v2 0/3] trace-cruncher: Initial support for perf
Date:   Fri,  8 Apr 2022 13:03:36 +0300
Message-Id: <20220408100339.594358-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Two major functionalities are introduced by this patch set:
 - VMA <-> function name resolving, using bfd library.
 - Support for Linux kernel perf framework, using perf library.

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
 src/perfpy-utils.c        | 896 ++++++++++++++++++++++++++++++++++
 src/perfpy-utils.h        |  43 ++
 src/perfpy.c              | 141 ++++++
 src/trace-obj-debug.c     | 982 ++++++++++++++++++++++++++++++++++++++
 src/trace-obj-debug.h     |  54 +++
 7 files changed, 2176 insertions(+), 2 deletions(-)
 create mode 100755 examples/perf_sampling.py
 create mode 100644 src/perfpy-utils.c
 create mode 100644 src/perfpy-utils.h
 create mode 100644 src/perfpy.c
 create mode 100644 src/trace-obj-debug.c
 create mode 100644 src/trace-obj-debug.h

-- 
2.35.1


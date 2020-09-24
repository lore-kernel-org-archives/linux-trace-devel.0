Return-Path: <SRS0=Qydk=DB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA4EC2D0E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 07:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68B2F206C9
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 07:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvdeIUEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgIXHPC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Sep 2020 03:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726929AbgIXHPB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Sep 2020 03:15:01 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B623CC0613CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 00:15:01 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v12so2437192wmh.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 00:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vKZcPLZXKZSyPQyH9Ytc8rg8gMazexHlN2W6dhH9Ms=;
        b=NvdeIUEQc2VQT+/S0akDUh7SQM3p4zrNbnnViFIK1EdKPrlDfVvItvbik7ZdmUjuNv
         yKqJOjsFXm6q+4cIBOshuq2bgWlW2xKGwP5oEIegR1kNughuUCfRnaLnQx23hLdB09dg
         0Lw1aTnAGrqKpo2Cfnx3DaukV60By9NNh2UiYycmudEQDs7S/2cMNYa4NC6I4SsfZrhC
         RVEPRR7mDn7EUYYW9N7pjQKBDfNyybGq3IDVLcxWagziZ92eXx/wlyiMxvIrfi1EyxdX
         cEK7nCq0PwWiMSHEANuxspi2iLqH+UX3LnadoDIIxZAbgOxqnJY5MhcGDs58Af3S/0fQ
         8RoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+vKZcPLZXKZSyPQyH9Ytc8rg8gMazexHlN2W6dhH9Ms=;
        b=bA/4n1cYC5dnmHRs6u6UQI4PvF2hy5+rUoAQJqMaWsqtnCDwo2kEOjk7gZp91tPFvL
         vxk5asGoqdzLfBc0ezYsJ8WMYUgNQeYQqka6mxPkdC8z2Z3T4mhagnY0uzmby+gUAKxR
         yeNRGt+BWfHfVmSoiTe2GPDCkrqZQju40tXluPI9FMogv2hDyT4/8EEIB0uUrhHU7rty
         5ueGuRHfgG7WGujSaI5YBqkai2EmUgVnIajkBG/VweKAZGDYMmZeip8p1+XvSY3RpOWb
         DNHNGARIb2cLxOFQKQcc9M8rke3ra983SdYFXhXhHWCz90aSABPaDfKFn80LOo+Lp5Iq
         hYUw==
X-Gm-Message-State: AOAM532PF5X6q/pNjSkNubjjNxtxNTCuJMnh1MpWiGoMogJz3RBVoVnw
        Pp02D3rsy87B69PrHlpVm4dwdb+LKV0YVg==
X-Google-Smtp-Source: ABdhPJwbLsRSFcrqFIdjNmQzqcNp8PANS2iFyAutDQae64iql0Gm7JlV8kwKcc1Ljc0vdhXyckJYAw==
X-Received: by 2002:a7b:c345:: with SMTP id l5mr3116575wmj.123.1600931700417;
        Thu, 24 Sep 2020 00:15:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h2sm2465293wrp.69.2020.09.24.00.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 00:14:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/3] Initial trace-cmd support for ftrace uprobes
Date:   Thu, 24 Sep 2020 10:14:55 +0300
Message-Id: <20200924071458.101326-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ftrace supports uprobes - trace events on user space applications.
Trace-cmd cannot configure uprobes, in order to support it this new
functionality is introduced:
 - Function name to file offset mapping, this information is extracted
  from the dwarf and ELF headers in the binary file.
 - New options are added to "trace-cmd record" for setting a uprobe:
    --uprobe file:function
    --uprobe-ret file:function

[
 v2 changes:
   - Renamed some internal trace-cmd functions, to not overlap the bfd
     library namespace. Suggested by Steven Rostedt.
]

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Internal refactoring of pid address map logic
  trace-cmd: New internal APIs for reading ELF header
  trace-cmd: [POC] Add support for uprobes

 Makefile                       |  10 +
 tracecmd/Makefile              |   2 +
 tracecmd/include/trace-local.h |  56 ++-
 tracecmd/trace-obj-debug.c     | 823 +++++++++++++++++++++++++++++++++
 tracecmd/trace-record.c        | 193 ++++----
 tracecmd/trace-uprobes.c       | 221 +++++++++
 tracecmd/trace-usage.c         |   4 +
 7 files changed, 1195 insertions(+), 114 deletions(-)
 create mode 100644 tracecmd/trace-obj-debug.c
 create mode 100644 tracecmd/trace-uprobes.c

-- 
2.26.2


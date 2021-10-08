Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 228A4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEB4F6121F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhJHERN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbhJHERM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:17:12 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B0EC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:15:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b8so31178546edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roEFSllBznr0ia3p6cqrGwxjKrEwBnJLh2MXqe+R6CM=;
        b=LskNhW3HvYRmCWjX7p7DLScETGMNsIQDJs+bqfR5tEkQKgPAg4kVCmbV2YIDbhnclx
         9MX54In0+8feE4IEwpRO/HmtFn6zK9nIsgvDezGwnMDBHNLkizDKLWIJG9ByuNKd2dEE
         hDn6ylK93H0q1mw6ZBHf9sVSD8gfE33X5C+KCQY3a4edlcMDDSoC6ZAV1MdULSWzKSVV
         f1QNCoHKK4aW05nCl9gID4mE8NrFOaJrmbsAwDlEo0dPZsFh/zbUbakqeGYebRHxLzsA
         zzM3/lcTYVTwqKlM1J6yuKOOxxOV4Yj324yqqiubpf7uqQXzKOIBktIVZ3erwTYK3qj3
         Oxdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=roEFSllBznr0ia3p6cqrGwxjKrEwBnJLh2MXqe+R6CM=;
        b=mYB3KPXs5gDxeKnLNJ2P38Lr198f7ckzdl5HE9fcNJfrsUTEL4agAnifHwtdEzMd9P
         6ixeBVQGtzlhlxHC3isHXqt45DwUc95nJ6h4MxCo5vzkHKErNATDeYQuHHi38yHqk1Ub
         jxzD2bsom+q4Rk+59Ma2piKU89Ll0w1lCpyoXCzzSMHir7Acym0UfpWDyy85LGwEe068
         SLvRUwTSoSXYbyScnyjJHrXGJKKn9y4u6t+nTcBeLyvqpLG7QNuNHYE5zJ5mt2NVWZcJ
         Ca3C1FDAAhzvoFljhITsK8Jz8iVfl9bMVJh5QO0WmqKfvlTSbDRSfg/JYESCnimwZwnD
         +rSw==
X-Gm-Message-State: AOAM531lIrnR5vzoeSrusR5GzLLfp0KZckxz5mRqEEERK3PPMfY3qfta
        KK8A1CVLKlfc7A8aOUNqGEw=
X-Google-Smtp-Source: ABdhPJzsS06e5p1tGWaJ1sHPSXEKTvSU4f6s6nZjkh+uvIta71dM8YknVxEp/rVRT45BMeyUTK1r/w==
X-Received: by 2002:a05:6402:5255:: with SMTP id t21mr11182691edd.103.1633666516489;
        Thu, 07 Oct 2021 21:15:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w15sm459614ejb.4.2021.10.07.21.15.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:15:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Refactor the logic for writing trace data in the file
Date:   Fri,  8 Oct 2021 07:15:10 +0300
Message-Id: <20211008041514.974537-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a trace buffer data are written in the trace file, the buffer
option in the file metadata is updated with the file offset of the
tracing data. Hide this logic into the trace-cmd library.
Added new APIs:
 tracecmd_add_buffer_info()
 tracecmd_write_buffer_info()
Changed APIs:
 tracecmd_append_buffer_cpu_data()
Removed APIs:
 tracecmd_add_buffer_option()

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for upcoming trace file format changes and data compression.
The size and the offset of the trace data is saved in the file right
after the data is written. The old logic calculates the size and offset
in advance, but when the trace data is compressed it is hard to use
that approach.

This patch-set depends on "[PATCH 00/10] Refactor APIs for creating output handler",
should be applied on top of it:
 https://lore.kernel.org/linux-trace-devel/20211008041321.973755-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd library: Add internal database for trace buffers
  trace-cmd: Use the new trace buffers API
  trace-cmd library: Helper logic to update the trace buffer offset
  trace-cmd library: Refactor the logic for writing trace data in the
    file

 .../include/private/trace-cmd-private.h       |  10 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  19 ++
 lib/trace-cmd/trace-output.c                  | 319 ++++++++++++------
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-record.c                       |  18 +-
 5 files changed, 250 insertions(+), 118 deletions(-)

-- 
2.31.1


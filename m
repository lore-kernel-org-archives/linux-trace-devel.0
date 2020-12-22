Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D90C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 12:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7887923130
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 12:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgLVMKg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 07:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbgLVMKf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 07:10:35 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5C1C0613D3
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 04:09:55 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d13so14259101wrc.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Dec 2020 04:09:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xyeyvu8G5P/Carb0OFQ6Ek/wnt9v+cdiNWQ434ByvNA=;
        b=WGX7VzmtGXSzDCnDU0QsJ3+l36DB2jJVtzAA+d/GvwXSu06dgi4ZsxYWEBpSWoTPF6
         1m545AYkiwv0Rsz/1uBui9YaEy4EQ1hqcSsqPSgk8KsiO+YIfXBhc+4iij+7M517gggq
         lqbggKIhaa5qBuqWfQzBQyb2BppDBd8SJSeJWStib4YGIEMXAr/cXlmKhUiu+kCiu7VI
         DGbIEuMVF04AN1kd8MIN03Qu6kXR+Uy1ha84gAkzRG5DKLELZ10RgrHMt+s1mxNWeYBR
         LvKG3Wp1+vNm8eNO1pb2JW7nr/tnDJpzZ26BXfdmtzk3ezmh7cnSpy+ZeKuwyeQLzzFi
         mjjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Xyeyvu8G5P/Carb0OFQ6Ek/wnt9v+cdiNWQ434ByvNA=;
        b=IOJ4lCHn44jmQKVIa90D7DhBMyerW3KFELmjA5BVklA+2KabxrVEv0aR2IGxG23ZlN
         3qTbaEQKB++E6VHrW0inJGmbeD8TNFNqRyvC7V4wTHMmgpB0+eXUDNayzWsIu0rX7FZI
         wXy2SU02d96Ma7uT7lBYGUIfGa7s70LM/IY7K5t6f7ovDgz2u6oATIoJBUqrH8OWBRuk
         16I+i3bi/anq+bkn39F7POWSgD75rPImMrVGE7xrKChhXfwjP2+CAzXWw/t5knuGBvCz
         EZzJTH2uGOTB5cfDsT9k1RpEptTBm+WyCDVO7jbiNkO668jbdMrFL2+G7s8RbT2WHJ5K
         qJvw==
X-Gm-Message-State: AOAM530kESVgwo1fy7x3GrZArXn94JEqKXxXDqRidPNDcmEAvhS3EILi
        U1K/GOHwcwntULGDqKJ0Rc1235/24yNaGdZT
X-Google-Smtp-Source: ABdhPJzmvxddSqnejSN53CZEuF2BRdhWjLMzfImECtLu3NWMI7zJtzmXS2mu0+zYZ9qKZ7wXJNdnRQ==
X-Received: by 2002:adf:dd11:: with SMTP id a17mr23830505wrm.360.1608638994059;
        Tue, 22 Dec 2020 04:09:54 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm28168576wma.3.2020.12.22.04.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 04:09:53 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Rename a few libtracecmd APIs
Date:   Tue, 22 Dec 2020 14:09:49 +0200
Message-Id: <20201222120951.492370-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Renamed free_record() and tracecmd_get_pevent() APIs to have more consistent
and intuitive names.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Rename free_record() to tracecmd_free_record()
  trace-cmd: Rename tracecmd_get_pevent() to tracecmd_get_tep()

 include/trace-cmd/trace-cmd.h           |  4 +--
 kernel-shark/src/libkshark.c            | 20 +++++++-------
 kernel-shark/src/plugins/sched_events.c |  4 +--
 lib/trace-cmd/trace-blk-hack.c          |  2 +-
 lib/trace-cmd/trace-ftrace.c            |  4 +--
 lib/trace-cmd/trace-input.c             | 20 +++++++-------
 lib/trace-cmd/trace-output.c            |  8 +++---
 tracecmd/trace-hist.c                   |  4 +--
 tracecmd/trace-mem.c                    |  4 +--
 tracecmd/trace-profile.c                | 14 +++++-----
 tracecmd/trace-read.c                   | 36 ++++++++++++-------------
 tracecmd/trace-split.c                  | 20 +++++++-------
 tracecmd/trace-stream.c                 |  2 +-
 13 files changed, 71 insertions(+), 71 deletions(-)

-- 
2.28.0


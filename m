Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E976C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E22223122
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Dec 2020 05:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbgLVFH3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Dec 2020 00:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgLVFH3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Dec 2020 00:07:29 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C6AC061793
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:49 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id 91so13252975wrj.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 21 Dec 2020 21:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cQswQV4rxfwQ4Ef4xP1CpsU11RR+eU7LPd1XxI7/dRM=;
        b=Rlq66ckRpl1dBjBRWWNUvDXyzY8sKDj7kHIYFs56mAWdnuTwOVdw/+MXiHpVcXr6Eg
         GCAlrcMRXgskznXD7+ANji5UNxBPcREEG8GV0zE7TewdGkKzUthftIjZNxtTXoaXiKjm
         ViWHr1iPQgSKPbAJGHx4+H6nLsJi2pYOG07tTqHAGsJmJ04CAYn9tFkVuO0WwkEsar52
         /6gx5M3dWWrZvdQsitjBCRbGrG3gh0f3pQuflcMn+9B4OVPeePEN+Mmsl6pBCwGNtVwa
         1gM0DE4St3oo19A8sTAK/eAEbyKXOCx1dWnfQSsWv/MfaELtkEqb2d0Kv0Ym6OvGIZKn
         94mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cQswQV4rxfwQ4Ef4xP1CpsU11RR+eU7LPd1XxI7/dRM=;
        b=JWlHgkQMn2+94KDFOlkwwfvQR+rpfupr9fy1miAcVCcKO07F7nvGbUYOet98RpL4FI
         soLcPfD3osHHVktCmmx3vK81AXw8hBr+Uwb2+Czx9cz4UjxC9+5CrtqDiUM7Qj3lWYux
         QczEYB+ci3CZ9zPHPaHAj85nw+51CyydCumuFBzlq2qDltwFWPyzjtlh2BzysV+8V1f/
         lvJ0aZRg3thBv0/BeHr7buMcdTRYqRxC+DIukbIBjd/d++tXfZiCAMWCQ7VpeU6cSJwn
         Qz/0mJBXH08KS03c7DYU8DDXlGDChUnmmsHz6/t2p8LH9p8ORgfMSOK0SrcEpsUUq8GK
         S2dw==
X-Gm-Message-State: AOAM532q49tnICODE2dZzTigCRU3h0s0KkJ7Wa/0szknMwhN5w7SGAes
        Ujwz2ptFMCKPc+vA6jJBN0Q=
X-Google-Smtp-Source: ABdhPJznriY87F1c3bzrQjxSQcLxW4Evax02xLhYG0GRda/hcr4RsLlciaDDLrQjJnEPhv+wI/P7Rw==
X-Received: by 2002:adf:c40e:: with SMTP id v14mr22022841wrf.163.1608613608061;
        Mon, 21 Dec 2020 21:06:48 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n8sm28828686wrs.34.2020.12.21.21.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 21:06:47 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Remove tracefs_get_tracing_dir() API
Date:   Tue, 22 Dec 2020 07:06:44 +0200
Message-Id: <20201222050646.375340-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The two APIs to get the tracefs mount point
tracefs_get_tracing_dir() and tracefs_find_tracing_dir()
are replaced by single one, tracefs_tracing_dir().

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Rename tracefs_get_tracing_dir() to tracefs_tracing_dir()
  trace-cmd: Use tracefs_tracing_dir() instead of
    tracefs_find_tracing_dir()

 include/tracefs/tracefs.h            |  7 ++-----
 kernel-shark/src/KsCaptureDialog.cpp |  4 ++--
 lib/trace-cmd/trace-output.c         |  7 +++++--
 lib/trace-cmd/trace-recorder.c       |  6 +++---
 lib/tracefs/include/tracefs-local.h  |  2 ++
 lib/tracefs/tracefs-events.c         |  6 +++---
 lib/tracefs/tracefs-instance.c       |  2 +-
 lib/tracefs/tracefs-utils.c          | 14 +++++++-------
 tracecmd/trace-check-events.c        |  2 +-
 tracecmd/trace-record.c              | 19 ++++++++++++-------
 utest/tracefs-utest.c                | 23 +++++++----------------
 11 files changed, 45 insertions(+), 47 deletions(-)

-- 
2.28.0


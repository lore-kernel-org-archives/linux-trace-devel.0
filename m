Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D17BC28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbiAZJzg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiAZJze (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:55:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8459EC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:34 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id u24so22135789eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:55:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7sW8e9ljB3iTHzFA/hw3RCe2RSvL72FC737tIL9TdA=;
        b=dWc6gpETwZMrz3KJgSCcS0jgUcCZvawV2Qj7RRWKZI1mZl/B0vvgzdDemz39ViijKZ
         WQ8TtXr6P7P1qP1mW7JV6o+08T28XXjLfKxC7/yTfauoNHK+j9mASzg0bMvCYi7Huvp9
         tvBBrJZSyulNPQ0X5njjgYucpgspN/j4YtCEkdEjvCtiQ8NXL72+xbt2mxrOuVa3QFqf
         l3A+1OJodMCeWsU8LV2f0sOop5KRLvQahLhiQ+QrmDGNxgBpK2ylQQ504BHiRTNdhfim
         P5HkXy5m8Y+bkav4rZBrFFxj2P6L6xZWlSdFAjHuuQBGHlOANHhH0HbbEJzOIaLzV8w9
         gvsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7sW8e9ljB3iTHzFA/hw3RCe2RSvL72FC737tIL9TdA=;
        b=Lwk5j8I8Nol5cE0+8tL5ag6cNIbGvV5cqrbrt9D56L4Fw62nGWRk5oXjxK5+sLE4Nv
         Yb7EbdHtxea0skhjXtSa0K0PyXVN8Ce9xAf5RQLQeNkF//BRn0Grk8K0kk9dcNjfmLcr
         dcmPoAsOzAyGKJMIVIu88VxxzDDOqJmClcOqFBpaQf35HX63fVExWDmBrPzkYxY5c/03
         MmvDA1/SjnfS4NJ5Bi/2i0iydO8rHcImMZ6tHk3gB+08DlDTqgurvipWP/Lc+9zJPIlL
         fhXy91basufAmkf01ObtEY0HSwWSgQrAKKeKWw9ftavrgTAkLJkEaKBFi83IcOB8jp7j
         4z/A==
X-Gm-Message-State: AOAM531NU14ylvPi3gw7aWDjPfoACJfgFbr+l3nhL2PxB/Ti+LjUgRmH
        2KwRDJWzNhI3uMiPQ2MJJR4imWy1gAw=
X-Google-Smtp-Source: ABdhPJz5eZkWDINAbx3RmGdY5OzPQAXGA9sxfrawK/gL21VgpDvEpLU/8E7WagCHfuXHdXemp14W0w==
X-Received: by 2002:aa7:cc10:: with SMTP id q16mr24205111edt.60.1643190933104;
        Wed, 26 Jan 2022 01:55:33 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id z25sm9563070edm.60.2022.01.26.01.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:55:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 0/4] trace-cmd documentation update for v7 files
Date:   Wed, 26 Jan 2022 11:55:26 +0200
Message-Id: <20220126095530.571035-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added documentation of trace file version 7.

This patch-set depends on
 "[PATCH v8 00/11] trace-cmd dump - v7 update"
 https://lore.kernel.org/linux-trace-devel/20220126095337.570867-1-tz.stoyanov@gmail.com/

v8 changes:
 - Rebase.
v7 changes:
 - Documentation update.
 - Rebase.
v6 changes:
 - Rebased on top of the latest master. 
v5 changes:
 - Rebased on top of the latest master. 
v4 changes:
 - Rebased on top of the latest master.  
v3 changes:
 - Rebased on top of the latest master.
v2 changes:
 - fixed issues of split and convert commands with some corner cases

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Update bash completion
  tarce-cmd: Man page for "trace-cmd convert"
  tarce-cmd: Update record man page
  trace-cmd: Document trace file version 7

 .../trace-cmd/trace-cmd-convert.1.txt         |  65 +++
 .../trace-cmd/trace-cmd-record.1.txt          |  13 +
 Documentation/trace-cmd/trace-cmd.1.txt       |   4 +-
 ...e-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} |   9 +-
 .../trace-cmd/trace-cmd.dat.v7.5.txt          | 450 ++++++++++++++++++
 tracecmd/trace-cmd.bash                       |  37 ++
 6 files changed, 572 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/trace-cmd/trace-cmd-convert.1.txt
 rename Documentation/trace-cmd/{trace-cmd.dat.5.txt => trace-cmd.dat.v6.5.txt} (98%)
 create mode 100644 Documentation/trace-cmd/trace-cmd.dat.v7.5.txt

-- 
2.34.1


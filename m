Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED5C1C2D0E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838E024655
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Nov 2020 07:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XotIaRlT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgKQHqB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Nov 2020 02:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKQHqB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Nov 2020 02:46:01 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD79AC0613CF
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:00 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id s13so2280972wmh.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 16 Nov 2020 23:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qtatXU5pKIinN4aBd8/hTE52UwftG3nuUgmgtfbWuVM=;
        b=XotIaRlTHdl5h7crCiIkWb1QKh7i74YmulM/UudWfC1+S/SZOB4RvhmG9cGTHWC7Aq
         2B7trJFRC4BPyj0tn8IYtZfh8Ellb33C3X+NiOjq4PbDZXUttk5mrUn9It2I6QtCOv7E
         4BLIpaNYSp8p38AoI6l+kyEDdOSLBkPqQQtSSoue8B1ebbkjZa6PFiuEHaFkrB4LFFZO
         F3AeUjHfdWJziBT8XQPDFl4WWufj6go4mvI1MHPHq9f7oL7AkL1HmAdwpx9LNtXqoT/+
         ECt4xA+nfyDQbBs2W1EIgK9tIG4VkiKF6YMKH4AOvLwExSOHOQZm1wgqfvJqWihAzKgX
         KmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qtatXU5pKIinN4aBd8/hTE52UwftG3nuUgmgtfbWuVM=;
        b=Kwecdb68D0Rr2hJGmWE6dASC1KbRRUbZUKKU3wshTjMDY9xHGsGGlNPMyoh5wBPXfC
         k0bpRyUdrXa2dmKvahWeAx5F+sDSbshnxSONf+5/e3TNfOLw3xNCHXXg5e9WgjJgp3nM
         bMQaNYNtqi5i7Cikr3wdCRdQzKiGNY9SbLQmGfTeQBwnyZe6luh2NPunl5TMVnrfVRpf
         3Y3cjbfarC1O0huvkxofi0wc2raRkPg8o1Xgq6cUlIN+XH7S6bhcLacnrK7gYENYk2m3
         dKI70Fd/UdDA0AXXgPpSzGTO2Ew4ENCLkeX4fAptDe/Yo8ZCBiITdhaZXIs99hiEtUwK
         8buw==
X-Gm-Message-State: AOAM530u3dZieyU+nyF1bIgEuXo8OUBqodhL5ycn65vOsFaJ4zp58AD0
        r00ecG4ois3LDAEKeXCW9uaZYbRQEII/+IV+
X-Google-Smtp-Source: ABdhPJyog9GF4q1gKoX3n4U0pz+OUN0AzRG3vj6riaRK0t+SEXvdgpO5axDZqOrCT+vfVbC3vJPbAA==
X-Received: by 2002:a1c:61c2:: with SMTP id v185mr2786118wmb.152.1605599159527;
        Mon, 16 Nov 2020 23:45:59 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d3sm25752046wre.91.2020.11.16.23.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 23:45:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 0/8] libtracefs fixes and improvements
Date:   Tue, 17 Nov 2020 09:45:49 +0200
Message-Id: <20201117074557.180602-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A few final tracefs library fixes and improvements, before releasing it as
an official library.

v4 changes:
 - Added new patch: "Use tracefs_list_free() API".
 - Hid the library non API functions.
 - When creating a new trace instance, inherit the permissions of the parent
   "instance" directory.
v3 changes:
 - Addressed Steven's comments.
v2 changes:
 - Change tracefs_instance_create() to return pointer to allocated trace
   instance structure.
 - Add new API: tracefs_instance_is_new() to check if the trace instance is
   newly created by the library.

Tzvetomir Stoyanov (VMware) (8):
  trace-cmd: Change tracefs.h include path
  libtracefs: Change get name API to return constant string
  libtracefs: Use tracefs_list_free() API
  libtracefs: Add new API to check if instance exists
  libtracefs: Combine allocate and create APIs into one
  libtracefs: Add new tracefs API tracefs_instances_walk()
  trace-cmd: Add new libtrasefs API to get the current trace clock
  libtracefs: Hide non API functions

 include/trace-cmd/trace-cmd.h       |   1 +
 include/tracefs/tracefs.h           |  10 +-
 lib/trace-cmd/trace-timesync.c      |   3 +-
 lib/tracefs/include/tracefs-local.h |   3 +
 lib/tracefs/tracefs-events.c        |  26 ++--
 lib/tracefs/tracefs-instance.c      | 194 +++++++++++++++++++++++++---
 lib/tracefs/tracefs-utils.c         |   3 +-
 tracecmd/include/trace-local.h      |   4 +-
 tracecmd/trace-record.c             |  72 +++++------
 tracecmd/trace-show.c               |   2 +-
 tracecmd/trace-stat.c               |  81 +++---------
 utest/tracefs-utest.c               | 107 +++++++++++++--
 12 files changed, 350 insertions(+), 156 deletions(-)

-- 
2.28.0


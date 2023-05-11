Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7071EC77B7C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 May 2023 18:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238768AbjEKSFQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 May 2023 14:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238516AbjEKSFO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 May 2023 14:05:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED39E1;
        Thu, 11 May 2023 11:04:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 957C2617EA;
        Thu, 11 May 2023 18:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39564C433D2;
        Thu, 11 May 2023 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683828276;
        bh=d+cecxraTXeWzYMKn5rFdRXZ1LbESCxt6tQQY2hpvhA=;
        h=From:To:Cc:Subject:Date:From;
        b=MoAOtLcfuiRZGJRadyzkqYQMdHYLduGkC1IZb3JvAPEvVLI3Jz3xTS4J6bUQiDcGe
         fcxGkMj9WlU34+0lTyzoc+kEUPorPsJHdPi1uGqrihFb8QdOnzru41uxi7bjHwPp15
         1wic1uS1Xj+LHGOHXyzkt6KFEnYDSTD9GfBNuLeIcC9Ie8y8cNhHCGDwlHf+oo1Y+1
         GAktMKqaF4RWAdlO44BfqVMC8PlxYbpsUAqTLFTctzvkvO4MXHH9JiH2ndBmfo29EU
         eIcxdYaYtG2jnn4PPey1ziJvoJDgLJggD2MdneXFIG6yVZ7qUvKSACm4+mw6F09V4F
         /9U/v+ATK2cRA==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Juri Lelli <juri.lelli@redhat.com>,
        William White <chwhite@redhat.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 0/8] rtla improvements
Date:   Thu, 11 May 2023 20:04:18 +0200
Message-Id: <cover.1683827510.git.bristot@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a series of improvements for rtla, mainly as a result of our
daily usage of the tool debugging problems at red hat.

The cgroup support and house keeping options are from our usage
of the tool debugging containers.

The auto-analysis overhead reduction is needed when we go to
large boxes - but it is really hand in practice, as it gives an idea
of the problem without having to look at the trace.

Finally, running hwnoise 100 % of CPU time might cause some systems
to slow down too much. Reduce its utilization to 75% by default to
avoid problems for people using it for the first time.

Daniel Bristot de Oliveira (8):
  rtla: Add -C cgroup support
  rtla: Add --house-keeping option
  rtla: Change monitored_cpus from char * to cpu_set_t
  rtla: Automatically move rtla to a house-keeping cpu
  rtla/timerlat: Give timerlat auto analysis its own instance
  rtla/timerlat_hist: Add auto-analysis support
  rtla: Start the tracers after creating all instances
  rtla/hwnoise: Reduce runtime to 75%

 Documentation/tools/rtla/common_options.rst   |   8 +
 .../tools/rtla/common_timerlat_aa.rst         |   7 -
 .../tools/rtla/rtla-timerlat-hist.rst         |   7 +-
 .../tools/rtla/rtla-timerlat-top.rst          |   7 +
 tools/tracing/rtla/src/osnoise_hist.c         |  90 +++++-
 tools/tracing/rtla/src/osnoise_top.c          |  83 +++++-
 tools/tracing/rtla/src/timerlat_aa.c          |  35 ++-
 tools/tracing/rtla/src/timerlat_aa.h          |   5 +-
 tools/tracing/rtla/src/timerlat_hist.c        | 139 +++++++--
 tools/tracing/rtla/src/timerlat_top.c         | 127 +++++++--
 tools/tracing/rtla/src/utils.c                | 266 ++++++++++++++++--
 tools/tracing/rtla/src/utils.h                |   5 +
 12 files changed, 684 insertions(+), 95 deletions(-)

-- 
2.38.1


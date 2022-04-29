Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A251C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Apr 2022 16:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379184AbiD2Qb5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Apr 2022 12:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379111AbiD2Qbv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Apr 2022 12:31:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A25EDA6ED;
        Fri, 29 Apr 2022 09:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFA10B83698;
        Fri, 29 Apr 2022 16:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749FCC385B2;
        Fri, 29 Apr 2022 16:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651249699;
        bh=zqptO1N6BDGu0LrGJkssck2mGdxM1qreWWihBCeLsaA=;
        h=From:To:Cc:Subject:Date:From;
        b=hreF3EozLcRhO/KxxXTt20IKe3Z2u+ysUMWQizRzm/ToaKDwlC7dk+QD+JH56qnk/
         6zD1j5+1VWjUIEQ+wB5hMfhH8PBggD+IMHCpuecJ1lml62GkBAhUGvMgGdupLdV7Aq
         iallFkk1Iq7oxH4OmPPqlg/qeXpRUuH+aYhmsuSRr3uxFSNgEHKj7y9paChRnkXBNw
         ECn1L2g30gV6aLGFVYQqyJNinYgEAwl6RlUzpJy1Qn1WDwULtevuZhC5qBiUBMPxNS
         aH9NtSueOr9okZ9ImGuSjkzKy795ht6CpYfu1J0f5dkuIw7HCC66WGMA1FN5uEH6Nf
         H+mH/jPXHps7A==
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 0/4] rtla: v5.18-rc4 fixes
Date:   Fri, 29 Apr 2022 18:28:09 +0200
Message-Id: <cover.1651247710.git.bristot@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,

Here are some v5.18-rc4 fixes for RTLA that I think are ready to be
queued.

Daniel Bristot de Oliveira (1):
  rtla: Fix __set_sched_attr error message

John Kacur (2):
  rtla: Don't overwrite existing directory mode
  rtla: Minor grammar fix for rtla README

Wan Jiabing (1):
  rtla: Avoid record NULL pointer dereference

 tools/tracing/rtla/Makefile            |  3 ++-
 tools/tracing/rtla/README.txt          | 12 +++++-------
 tools/tracing/rtla/src/osnoise_hist.c  |  5 +++--
 tools/tracing/rtla/src/osnoise_top.c   |  9 +++++----
 tools/tracing/rtla/src/timerlat_hist.c | 11 ++++++-----
 tools/tracing/rtla/src/timerlat_top.c  | 11 ++++++-----
 tools/tracing/rtla/src/utils.c         |  2 +-
 7 files changed, 28 insertions(+), 25 deletions(-)

-- 
2.32.0


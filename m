Return-Path: <SRS0=0fRq=77=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736B3C433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 11:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 510DF207D8
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Jun 2020 11:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FYcGsrKb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgFRLn4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Jun 2020 07:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbgFRLnz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Jun 2020 07:43:55 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687D5C06174E
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 04:43:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id h22so2556802pjf.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jun 2020 04:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4iO9mSXLNhkr7fEidiZu7rg46ASzwSU0y1tKmFUhCuI=;
        b=FYcGsrKb7PDioH7XLzyFpEKOvCWuR4veHZkbTRVoy11CoglDPED0ApQNUF9iW41Ct2
         GN27PZFaeeEbq/t9j4WIp1Ns1GkO5HmNRhoPX16t5oOg2fp4FzKDsiECa3Xi88S3RXo4
         iycI8JswZoYJ0xpqmTCo1pajb6GNAMsvM0ffPtDk7K/LGKLevVYutBM9CvKNIywOk5Xw
         z0gjzvnIjqanaWJSAIgG0QzKpGTGELBQuL8r23iY4kkDMEmVuDxap64UfIr3wWeS7t9+
         roE+FQzXJbg4X1u/ssc01sDvIxZPiVzn8+PT7ZNjxeaDdTMxit4u1j7M4O0yAgGDpadf
         bBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4iO9mSXLNhkr7fEidiZu7rg46ASzwSU0y1tKmFUhCuI=;
        b=cqBvJ6VGqyBujx5mpA3hBSZEPBgnprVFLHe1vINwFm9QIBpEkJvd5V97vgNMecdTYr
         tHxnDcOUj+XxkiE8eeZ/kOUXRR2djsNFs3R9LpJVDDVnI1TEU+P+hDwWC3FqVc8LRudE
         ApVXCYcZUU1kdgk1uDrCSR8lV6iQeaJN525D39v0M+w3wMlG9f6Zi7GoH0f+3S7KsqZw
         I9Hz1otTiF5RFqUA0EhKLRRWfbWsTk6JW9oe2E2ZpH8x9ZXoR1RgrHnYU5y5YwI5hvEe
         tNDeIlCiSX1nvim2IkK4rTxs0oy3yT1xn+WbliWb99LAHypUYwx4HzavUBs7gqj4vjvX
         bHxA==
X-Gm-Message-State: AOAM531LoVijIQ+PK79+tillOyDQpC3Gv+E2VobQQiwvncgicmpIJ4ij
        5OOSEryyEPVKuA2Usmb4aUobLsYqcTWPhZ7ddp69DpVfd0s=
X-Google-Smtp-Source: ABdhPJzXeXdmSSyGzGEUGIs/wr43uMNtJLMBzsfwL3gNkCkufiqgdDIw26vh9bEqDQlH5RzReD4hKJxRCKn3yVRaR9s=
X-Received: by 2002:a17:90a:22cc:: with SMTP id s70mr4072596pjc.2.1592480633464;
 Thu, 18 Jun 2020 04:43:53 -0700 (PDT)
MIME-Version: 1.0
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 18 Jun 2020 14:43:42 +0300
Message-ID: <CAPpZLN4RkWjAFBw=wShOMhQ0ECWJnDiOyQQPP6os68pSM9VeBQ@mail.gmail.com>
Subject: libtraceevent sync
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Steven,
These are differences in commits between both libtracevent
implementations, in trace-cmd and in kernel. Please look at them, I'm
going to synchronize both trees according to this list.

trace-cmd/traceevent commits, should be added in kernel/traceevent:
  "trace-cmd: Introduced new traceevent API, for adding new plugins
directories."
     https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=5c8ac22552af4213f81cb7839f7f262252a80855
   "trace-cmd: Optimize pretty_print() function"
      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=d8c1349f44ca9ac8ef0e7f198a133603ea399a95
   "trace-cmd: Move plugin options from trace-cmd to libtraceevent."
      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=5988d3085d9ec5d7418ad49bc8c7e88c832d5ac5
 "trace-cmd: Remove trace-cmd plugin handling routines"
      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=b2cf2e46a6d013d4037118274cc783570277ce32
  "trace-cmd: Add proper KBUFFER_TYPE_TIME_STAMP handling"
      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=e5de44dd43523764d18dc773f82ce1b738c22e64
   "trace-cmd: Add --debug to trace-cmd report"
      https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=8cdbccd5ef422dc518e7246aa1c41922e834120b

trace-cmd/traceevent/plugins commits, should be added in
kernel/traceevent/plugins:
    "trace-cmd report: Add -O offset for function plugin"
         https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=1785022e12cf0079889c519ffc7157f2143326ea
    "trace-cmd: Move kernel_stack event handler to "function" plugin."
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=8ba49dad8877fbd27cd6659397a01fb9243f7953
    "tools lib traceevent: Add builtin handler for trace_marker_raw"
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=d9f4b4043a68602f869c8c73b499cd7c7b4194b9
    "trace-cmd: Add plugin for decoding syscalls/sys_enter_futex"
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=25224f44a75e2ede5c2085683c0a008980ca87e7
    "Change to SPDX License format"
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=ff551288621dd07e9a9da433cb5b9f539c025cb6
    "trace-cmd: Add more SVM exit reasons"
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=4421d9551b903d720bb8534a02c3564187eab045
    "trace-cmd: Add plugin for tlb_flush"
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=7a0ead47bdb85288c855fafae24719b1ca9b907e
    "trace-cmd: Add hack to report out blktrace"
        https://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git/commit/?id=9e0fd22b14805a3a3219a99bc5eccebf70f5484a

kernel/traceevent/plugins commits, should be added in
trace-cmd/traceevent/plugins:
    "libtraceevent: Remove unneeded semicolon"
        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eebe80c982546ce1041b7dcf3c461406f1e7e88f
     "tools lib traceevent: Fix memory leakage in filter_event"
        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f84ae29a6169318f9c929720c49d96323d2bbab9
     "tools lib traceevent: Take care of return value of asprintf"
        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f8ff18be1f5c6ba1c2befb043bea6e7eaf9f8987
     "tools lib traceevent: Added support for pkg-config"
        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=cc03e1a8f82dff36fb329469c28cbfe7d2e6156a
     "tools lib traceevent: Remove hard coded install paths from
pkg-config file"
        https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=53dbabfe50262eeebb56ce18789c3c885f15e6ac

kernel/traceevent/plugins commits, should be added in
trace-cmd/traceevent/plugins:
     "tools lib traceevent: update KVM plugin"
         https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2f465deef7ce8c722121b782dd91c284f5ae80ca
-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center

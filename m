Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6F8C4321E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 Oct 2022 09:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJTJdN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 20 Oct 2022 05:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiJTJdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 20 Oct 2022 05:33:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1051F578AC;
        Thu, 20 Oct 2022 02:33:10 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j7so33416237wrr.3;
        Thu, 20 Oct 2022 02:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QM8xkj32OoGOO0dMFriK7QKceoHG9G7kAZT7+VWERlE=;
        b=b6mbfCz45LcmmxbeztESys81fAArj5s822v0D1SUZhcWCuLKKpHfcHleX6kSYJo1Cr
         Vi1zHKDHnMBXPty87cd/vxRpSIof/lfchrLXfujxHCHxQOurynErRPCJIkpVLeaJ7nvi
         nfyQCUrOHYwQ5IlN9kMnbl28I3lmILkTC5rfpfjj6e5cbCImzYULVGZAigYFZbFkm+Yt
         JilcA5Rhu3K38iF2+ihglsbtMRpfnADeZDt7bzvUs98g0JFAqhhOVveUbgUmB2sVuNVs
         yS0K9qkz+h6ijEW0NLRjz+smBoUtmkbEG3oTMUBYeTvfgVozKIPSV+9FUH9dkQ8xszi7
         oRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QM8xkj32OoGOO0dMFriK7QKceoHG9G7kAZT7+VWERlE=;
        b=oIaPqReh9MJL7lgpDYCEosvlIy/jiAnBnUH18Fv19n6dX0Zev7Qt3Dkk9p180t8vh3
         O15syV+SAElsULKl0UNn1PfNtqnqiJplq765HdQQgh1wff2Q+/bi1E5aK5gKHw3+ilpB
         bkzCtym0CmklmL3N7FfhR/4bFbfEudC0qTMX7mAUBq3LF5RQeERf/RKDBehkogowsH6O
         hOxhPGkMNzchyUkxtGvMYDheRkmpD9CVmHsi6+bKZHYEM+c5jLMTLavG2mSCNcnOIOMO
         7EnsONTSDNN8B1fGaEDKonx/2ufsEYzdIiFOQPiiLqgSOx0Paf4boIDbpxBs+bFc9kdD
         9dGw==
X-Gm-Message-State: ACrzQf1/r37HxQONY9Es/4kNTpJOXRLrh4s1qP8sDfc0Z9mFspEIX+SH
        3BH3pGr+YOvA7hf7ywrAfG+Qo/dtDDMnUeVEJd4=
X-Google-Smtp-Source: AMsMyM4akWM8p8pI/VIq0RSzFwTj5ro6JIGyA6261z2bK27wgaDOXgeN2+3J+poqMp9PjP7+NoxuUgrd6eBYoIZEwDg=
X-Received: by 2002:a5d:6901:0:b0:22f:b097:7de6 with SMTP id
 t1-20020a5d6901000000b0022fb0977de6mr8264466wru.373.1666258388437; Thu, 20
 Oct 2022 02:33:08 -0700 (PDT)
MIME-Version: 1.0
From:   richard clark <richard.xnu.clark@gmail.com>
Date:   Thu, 20 Oct 2022 17:32:57 +0800
Message-ID: <CAJNi4rM0K=-wgJrS0iLMkam77JTO7oRxcP9VkHGbuTiVGBovMA@mail.gmail.com>
Subject: Question about 'for_each_kernel_tracepoint(...)' function
To:     rostedt@goodmis.org, bristot@kernel.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,
Can this function only find the trace points defined in the kernel
image? I want to define a trace event in my kernel module A, then B
module to register a probe callback function for that event TP in A. I
want to kick off a timer in A and call the traced function
periodically, thus I can monitor the events happening in A from B.

Can I do that, is it possible?

Richard

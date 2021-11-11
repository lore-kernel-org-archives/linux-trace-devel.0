Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5553FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34B2A61284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbhKKPF7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhKKPF7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:05:59 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE33EC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:09 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c8so24962119ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=749/FL5ZwIUml8TltF4PGXK829m2GDhs8zpWxGUJRgU=;
        b=M7+OBmXexdFdE6nyHgToMzf6q4uo+E5v5B+P+PR0CbjLeKnjHU2SDRsFv01Et0KDQN
         8kl8cIgRpoLgx9fo+OI9kovivva1mOrEiVotYSl1dy5Dl4iFViJ0CA+aPJXBdYxdOgC8
         EndH0WQe0+nzLCXzMzGYdXzBgM94AWXhZAjpC7cxmFssm2hCl6/UN1V+c48nL0Xevkx6
         +8yUcIhnC9faovtRM/U+6XIC3tl4H576nj4Uv/kCAErZI84UjxkuRpFIWAFJWEq+TabX
         s8mLrx/fQnYvdeul5z5K9WQtOFNFlNb6PzVrcyrQ+G6neF78C7xyNNFOMgg6DCpRnWEf
         K/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=749/FL5ZwIUml8TltF4PGXK829m2GDhs8zpWxGUJRgU=;
        b=n7QluxawySKM9XB4OxZNFyGbtgXdxJTLtCpO4ziCVzVhv7J1OVS6BJkDtWViZ7GFJB
         mc17G1/X3LUjdJk5ijL8ALw7JSZqJqOT2rPIM8D+7lIrku/AQ7sr8mZh8TThAsiGLAcP
         sMmw9hM+EscNkG6mDlcvxFKqXFeWUPL8W+HNzdR3IRQxCV56YpW+PCsX+DvSQkow4AIi
         P6osb0eUV7fVhAwHkEHZldBfe4zKL31FJPqWD7M0mMnHCBEdjIhxFwobiZ6Qg5HEmGXm
         VW37b/L5lqctbB/XnaAHMEvUOcS026P7CV/V7yHiexuMi1srPxyN18ill50hMEOxvz2x
         j74Q==
X-Gm-Message-State: AOAM533IvrMHwIhpxeqSxCJ1gBTHW99T7r/1TuGi7ddnDhnKkayR5OtT
        pKxT7VQdMyfxeG8ngIjm115ycNo0D6S1KQ==
X-Google-Smtp-Source: ABdhPJzyM6BKa7I6zSIsPD2xLA/wAyLSIKlW+zDlvHsJHOimJH2G/0QlCUWkkDdLRF1EtSo4mtdZUw==
X-Received: by 2002:a50:f157:: with SMTP id z23mr10418865edl.94.1636642988291;
        Thu, 11 Nov 2021 07:03:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm1737826edj.63.2021.11.11.07.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 0/6] trace-cmd fixes and clean-ups
Date:   Thu, 11 Nov 2021 17:02:59 +0200
Message-Id: <20211111150305.85943-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Various trace-cmd application and library fixes, clean-ups and internal
refactoring, needed for trace file version 7 and compression changes.

v5 changes:
 - Rebased on top of the latest master.
v4 changes:
 - Removed from the set the patches that were already merged upstream.
 - Rebased on top of the latest master.
 - Removed these 2 patches from the set, as they will be a separate patch
   sets:
     "trace-cmd library: Refactor APIs for creating output handler"
     "trace-cmd library: Refactor the logic for writing trace data in the file"
 - Addressed Steven's comments.
v3 changes:
 - Fixed issues of split and convert commands with some corner cases.
v2 changes:
 - More cleanups, forgotten in the first version.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd library: Do not use local variables when reading CPU stat
    option
  trace-cmd library: Track maximum CPUs count in input handler
  trace-cmd library: Fix possible memory leak in read_event_files()
  trace-cmd library: Fix possible memory leak in read_ftrace_files()
  trace-cmd library: Set the correct file state when reading file with
    no kallsyms
  trace-cmd library: Set the correct file state when reading file with
    no ftrace printk data

 lib/trace-cmd/trace-input.c | 92 ++++++++++++++++++++-----------------
 1 file changed, 51 insertions(+), 41 deletions(-)

-- 
2.33.1


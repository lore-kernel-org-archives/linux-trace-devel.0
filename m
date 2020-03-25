Return-Path: <SRS0=JHVT=5K=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC18FC43331
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702CF20722
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Mar 2020 14:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V9ddy8Pv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgCYOIf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 10:08:35 -0400
Received: from mail-lf1-f41.google.com ([209.85.167.41]:33022 "EHLO
        mail-lf1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbgCYOIf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 10:08:35 -0400
Received: by mail-lf1-f41.google.com with SMTP id c20so1921424lfb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Mar 2020 07:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFAhyuPcUcO1NtBqKHckwm8aOZZWLN85wFcrK0Egfx4=;
        b=V9ddy8Pv1ecfsHYr6ACqixL50FybVjZ8e237TNw2/TFM74Vdw/NFjn2hAz3bxHtpyv
         g8nz0mY8oBhA57c7cCyvjumHHb4AMRej8FqCVQdD1kEYE+2VgFf2Yr8QlqA7dYxEblUj
         lUIqcZk4HRUzMnPt5jYGBh14cdwR3xvNqotP25j6YTgb5t4RKJSjjKgkPdes+mdWZifp
         H9HEKCg3nq0882TtD33rF/CM7Pcteq4a8XUPQwVErrQx2qUTV5iCLOyWQAlWs8TBxGXE
         MJylvi37W8iTxDyit7n8GttamrFiBqAQybGgmz9ye0sQWOj4zeJj+JZcFenYyOgNlYeF
         /kvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hFAhyuPcUcO1NtBqKHckwm8aOZZWLN85wFcrK0Egfx4=;
        b=DgpP7tT4YEcdMDM4/AUDgCyfjbDox3OKuh1gciclFB9AVIOmxtIaK61lXTsvPMCAV9
         POKDrqPvWUj30hOEXomKk0puUCV5MiI8AdyJgEVmiaZh3BWuvSUOw5ZxwDKNEOZa5JAb
         nMkLWX/M0nT5ejpzxstxyPYK8ZjH2c/UqDBbAE+gt0fjq8uM59wUo25dWQE1fEekEG4R
         LfXT79UwM8O6PYFYOgnZSq42r1e2Vw6DBWUdSARsbAn9viOeEH/cv9gMlJ3u56uIGTMT
         Zq8ypJ1Tat4YBAwBjHzi+o1lbKx7EJ4d05xDazBqaQ37ywboyjKOIXBlMSZycl6BiCud
         FJiQ==
X-Gm-Message-State: ANhLgQ0PUjgQnF3Ak7VFMXZn9v7VMqEld3BnPUM+JuM9kZC3As32dGTe
        zu3VzNYPTRwGzLUDbx5BAGm65/CQJOE=
X-Google-Smtp-Source: ADFU+vu+QG8EKeK/hjE1FhN45hxvAyfnBNKCg59rPDHNcV/fB8ezAo6HocwJfIyaSKAj7n13OqMGUA==
X-Received: by 2002:a05:6512:6c7:: with SMTP id u7mr2558398lff.176.1585145312368;
        Wed, 25 Mar 2020 07:08:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v9sm12017301ljv.82.2020.03.25.07.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 07:08:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/3] Fix applying triggers to multiple events
Date:   Wed, 25 Mar 2020 16:08:26 +0200
Message-Id: <20200325140829.184651-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

trace-cmd supports applying filters to multiple events from given:
 "trace-cmd record -e sched -R stacktrace"
 "trace-cmd record -e sched: -R stacktrace"
 "trace-cmd record -e sched:* -R stacktrace"
but this functionality was not tested, there were few problems with
it.

Tzvetomir Stoyanov (VMware) (3):
  trace-cmd: Fix check for trigger file in create_event()
  trace-cmd: Fix double free error when triggers are configured on
    multiple events
  trace-cmd: Fix setting triggers to all events from given system

 tracecmd/trace-record.c | 101 ++++++++++++++++++++++++++--------------
 1 file changed, 67 insertions(+), 34 deletions(-)

-- 
2.25.1


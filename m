Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA78FC3A5A9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63EE20746
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 06:27:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HlFWXrvK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgEDG1Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 02:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgEDG1Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 02:27:16 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23A9C061A0E
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 May 2020 23:27:15 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id h4so8469679ljg.12
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 May 2020 23:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pcejs8VKfVV5l6lcMNMKznOFDztIo/JwK05KjiKY55A=;
        b=HlFWXrvK3ETcObRGvWxF7elCbn4pu7ez+i7Dqjr17iQp7sSZSccewqZoz8Wj9ykQ6N
         kvlqjAms6xF7kLaTh+OJYi6wAIY4XUXSo03sh9bUwBFyMVvdhFl2M2mPwMHoyUO8AG2A
         X8V0GjsYGjScpOYJuHJ+6P7x/buPSn3MjjDFzU3lJU8LkkH+028euHlQo13H/Xrph20V
         decd972A+Mw05Lyt28tix9gUH5JLFHPDaBvPG/MQPml56hwZ/6w++eLyIHJZQ3jRBNoo
         ps384M4arhdX2ByJNJ+PwxOQ0RAbklpZGzIsSmV68ySwbV/d4/em+IrfQnO8wMVUTJcu
         wwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pcejs8VKfVV5l6lcMNMKznOFDztIo/JwK05KjiKY55A=;
        b=q1E3xxwSYUXUtZYkSxSfyFC1R+lkpGf7dMsPdtxgoQch+B/6m/vIEJwtbuK/3grSUo
         V0pw547hWGuWjYSm+eJlG3IIzNoF52cy06yyCYrFUFALBJnlHuIDRYvOf6xn987cvzus
         GXuomMwGAsvSsk+2GtiROf1jGgL9w0e/KufyEGcknN5Xy3eJ293vQshllVp1HRm9Gt1Z
         XNRJZ6OIAdmQhk27iKStJBprsRoKR9d/kOgXRj0nH77R0zHZKlBkjedzA4dZuzWtHO2l
         gqWiSugs1g9Iu3PLyBXdj4V5jUhlqYu6IHiYlm0ZBwXx4G0O1We3Frot6JUjgMVSQEsg
         WE9g==
X-Gm-Message-State: AGi0PuarpV9L9QniFDRg822SA4Rq0HiDTmEz7xne7IUYn/B2utS4XpSY
        tM+Z2SOyiWVqlKLqLxes4cI94rMNVAQ=
X-Google-Smtp-Source: APiQypJYDzO2saSVLB0izxa585LlHsqqvW8eu0JCZy1ccv1CQbU1BoYGDRYI0K5g58LMMQDAy+a5lQ==
X-Received: by 2002:a2e:9e43:: with SMTP id g3mr9850574ljk.4.1588573634280;
        Sun, 03 May 2020 23:27:14 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u6sm7397150ljd.68.2020.05.03.23.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 23:27:13 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 0/4] Few small trace-cmd fixes
Date:   Mon,  4 May 2020 09:27:07 +0300
Message-Id: <20200504062711.107867-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A couple of trace-cmd bugfixes, good to have in the next trace-cmd
release.

[
 v2 changes:
  - Improve error handling in run_cmd() - clean semaphores on all error
    cases
  - Pass the child PID to update_task_filter() 
]


Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Fix trace-cmd report crash while displaying trace.dat in
    specific use case
  trace-cmd: Add "main" in the output of trace-cmd stat when displaying
    main instance
  trace-cmd: Create ftrace instances before using them.
  trace-cmd: Do not try to update parent's memory from a fork()-ed child

 lib/trace-cmd/trace-input.c |  2 ++
 tracecmd/trace-record.c     | 68 +++++++++++++++++++++++++++++--------
 tracecmd/trace-stat.c       |  4 ++-
 3 files changed, 59 insertions(+), 15 deletions(-)

-- 
2.26.2


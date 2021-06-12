Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61C0C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 01:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAA806128A
	for <linux-trace-devel@archiver.kernel.org>; Sat, 12 Jun 2021 01:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFLBsU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 21:48:20 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:47816 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhFLBsT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 21:48:19 -0400
Received: by mail-yb1-f202.google.com with SMTP id v28-20020a25fc1c0000b0290547fac9371fso6631755ybd.14
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Jun 2021 18:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jZ3bwCc8Nho2xEbnoOHlgbpae4etXRguM6thHC/p43A=;
        b=DAeahABjCVf21ZmiWQ1df6VHb0OfTyUpZQKrDmh4wu6b+eVOXRa0H+xX9vBAJ1hMHh
         RNzdLNn89Ee1WomIiikAVIMtJLjITbWcjDmfoUo9lo8vwWD12iUUZrtvTJKaPjEg6khV
         RCN2tdqXvNRlWgAfXuVGCRnullwY3wU4unaCLBbPXgf47fa2MShTOEN/dSg6t9uqjaqw
         UOcDdng7vtEO/H5MktXarhClvVQ+2at1XfgNKre39Rcq/xeT7LaGfHxA+xCUdv063kfP
         dnlzJFAIbkGYVdd7tyU3zhXBqbpFWkSrZDupNdIRpv2wtgQ9rYBpMEYRruVNRPC+rAy0
         k/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jZ3bwCc8Nho2xEbnoOHlgbpae4etXRguM6thHC/p43A=;
        b=Z6wkPFj6+VsP7B2RS2N1OWARjn4cYjQu5FvX8JWIFfd2NBA2eMou7miKeiW3VYYwVW
         jxFQNYbf5h+Q+m5lXJiqHzTWuJ+esIHUhBAl8QiHiJ2ighmKg4gHWGU4xV0A9M9rUM8d
         IAzoKVlDHI/wt0+rvRGyD0bIpRH2ZYSyjjoM0kA85UKh+ZYYRMP6sW6J7c7dAaImA05V
         aD4aaXFH6MFYMg88/GG+s9E/O3blJZB4++I3fkXNpw29FmZhBpnfJQ1urj2P64MhBIUe
         Hdq9/wX1GxgGZcgVCSo6B6K4lsA7yBlvIqq2IRrTmchlbkBE9YjdS6xiE0lI9KeyN2XU
         MktQ==
X-Gm-Message-State: AOAM533/mP84rSwrCml6qy6lEUCrT89wyHPDv+8EnEN9YPhrmfoPEOPu
        QD1/Fgytp+pMXcwwo5DYglYICd9Rbq8gAKZpVZHfT/kqeSfl7z/6NVj2XBOsbTaCikCyBGEvTOu
        kuxAcXITayeXCnvT87XJn4X/X9OkE54vfKP/P25uzb9ZhZ+eBVJVGq98dFWWxnIg4BGvmgXNktA
        wf53I=
X-Google-Smtp-Source: ABdhPJwOCU+qwvj3+f7gQw10gX2Q4MPv6r+kUL/bVUvAlsLb5aDw4Lqyw6lg0IPiLXk+UaxshCKzhFPbPz6t
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:27c2:28ad:b3af:418a])
 (user=irogers job=sendgmr) by 2002:a25:bbc9:: with SMTP id
 c9mr9445158ybk.407.1623462305498; Fri, 11 Jun 2021 18:45:05 -0700 (PDT)
Date:   Fri, 11 Jun 2021 18:44:59 -0700
Message-Id: <20210612014501.890593-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 0/2] Build and fuzzing related fixes
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Claire Jensen <cjense@google.com>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

EOF checks are missing in a number of cases that cause the parser to
enter an infinite loop if an EOF is encountered.
Some build systems are picky about angled vs quotes, fix this minor issue.

Claire Jensen (2):
  libtraceevent: Add eof checks.
  libtraceevent: Changed angled brackets to double quotes.

 src/event-parse.c | 62 ++++++++++++++++++++++++++++++++++++-----------
 src/event-utils.h |  2 +-
 2 files changed, 49 insertions(+), 15 deletions(-)

-- 
2.32.0.272.g935e593368-goog


Return-Path: <SRS0=ZY51=EL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECE3C00A89
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA5102083B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Nov 2020 09:34:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F9+uZFRB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgKEJeC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730830AbgKEJeA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 04:34:00 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8102AC0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Nov 2020 01:34:00 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id q3so527108edr.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Nov 2020 01:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HS5eSXzpWAL/xt7hVvCjLKSr20OUorSjrWy9eOOUByc=;
        b=F9+uZFRB44qNE8SV9LHufwVs8bNmduAHqABvzK2xT3frLagmx8R/TeKcY8VK9884/o
         zD7wn/gysHKhrBWlLnTXslOf5cFpCb+EgoTqQIVhat+y9H44KcrH0nDpCjpKH+xrnTg5
         GqMM6V4pp5tWcvk4YDuZmwnUc+jsoor/zQ3q8+daeELDqaD4FFhC90WX/5dkG7h3yMAF
         iv94auFaHXfIERecRjFb/zX+wR6trUoVHdZBahs3hIyLp7hheOZJKyXhczz3sxcl7joe
         NwFhc3N9AzX9vd8w1Ll80nEKlBFhp7zIdDPm4LWC6a167LKbJ7ZZa9+sHOPvlzEh75IC
         b3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HS5eSXzpWAL/xt7hVvCjLKSr20OUorSjrWy9eOOUByc=;
        b=NWRRIQBhdqKk9PGUeUDi8ctgfABrW8JwIBidWKMKm/ruRyW+Can4kEO55FYhQ9WIoM
         ypDKMrQDX1O+GnjIncxJEmSkdMQsiWpQaP9SGb/+5YO6WNFKSoOi4tPH6UN93FwTcnCM
         AtgIrMXOzc2VivIHYR4mHoRmw8I1caNCdVVFYxnRt0UCtO5szt9A8wqXwwaXmDFqXm0O
         2tvgXNAFooLZAqc+YazUEQSMj4KQl2j7k671tSessJLzKoCVcA5vw8PHINCKg3l+tVrb
         WySZG09BeJphaIwJNhbYJTLqkuitPTuX/1gv6nSexBXNQC4CsurtYFAvHx06wT4RUCeh
         TQVQ==
X-Gm-Message-State: AOAM531njPuqZdZJX+u1yDaG/UCmZtPi5phamsMzsbP9BkwRCWH1G4vu
        UX9XPqRqkFgkKwwv/066hsIJFnmE9QUVqg1/
X-Google-Smtp-Source: ABdhPJzN/Ec8PncWjUxqetRpmGP+mHqZah328AUYm3xcbzCsF6LiZtj0M4OWNImlpHXw8XCaGMNl5Q==
X-Received: by 2002:aa7:c2d7:: with SMTP id m23mr1642161edp.230.1604568839332;
        Thu, 05 Nov 2020 01:33:59 -0800 (PST)
Received: from localhost.localdomain ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 1sm586725ejt.107.2020.11.05.01.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 01:33:58 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/6] libtracefs fixes and improvements
Date:   Thu,  5 Nov 2020 11:33:48 +0200
Message-Id: <20201105093354.532742-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A few final tracefs library fixes and improvements, before releasing it as
an official library.

Tzvetomir Stoyanov (VMware) (6):
  trace-cmd: Change tracefs.h include path
  libtracefs: Change APIs to work with constant strings
  libtracefs: Add new API to check if instance exists
  libtracefs: Combine allocate and create APIs into one
  libtracefs: Add new tracefs API tracefs_instances_walk()
  trace-cmd: Add new libtrasefs API to get the current trace clock

 include/trace-cmd/trace-cmd.h       |   1 +
 include/tracefs/tracefs.h           |  17 ++--
 lib/trace-cmd/trace-timesync.c      |   5 +-
 lib/tracefs/include/tracefs-local.h |   1 +
 lib/tracefs/tracefs-events.c        |  61 +++++-------
 lib/tracefs/tracefs-instance.c      | 141 ++++++++++++++++++++++++++--
 tracecmd/include/trace-local.h      |   4 +-
 tracecmd/trace-record.c             |  68 ++++++--------
 tracecmd/trace-show.c               |   2 +-
 tracecmd/trace-stat.c               |  83 +++++-----------
 utest/tracefs-utest.c               | 120 ++++++++++++++++++-----
 11 files changed, 322 insertions(+), 181 deletions(-)

-- 
2.28.0


Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4BEC43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:17:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FAB9206CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l3z5zYEp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbgC3QR4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:17:56 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:46942 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3QRz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:17:55 -0400
Received: by mail-lf1-f52.google.com with SMTP id q5so14674729lfb.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tqu8auMYCXx4310sLJYIeuXmDwmGVikl8lAjcCnAg3M=;
        b=l3z5zYEpRp6CVvHaniEvtYfmvwJvwjYqX8nc8tjfgf/ZFZ2xzqjkIrszmYqULmfj7C
         TZHpkzSLQrvdY3BLb7bUyY92cHlgzdVJcHJDgDB/1bk37Ic/OmF13kWoFw1QjVeQNWi5
         9/efprUaBl74uw/EcySIKhl6WA6ajnr2pOZAx+WfT4avXqtpucMz8v1H4RW6Q8UAk0FH
         8fwZHxiuYjh/SI4eKlueC3qDfzKy1HpDPPG5NZ69kdiRB0DQFIhWJZxM5twyeGDqSNeu
         99jwSjkIxOs1Oxs/La0pbZf0dqpyLpeNVUXxUptpUSrbD50Utx2u9webEBW20soe38R+
         LPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tqu8auMYCXx4310sLJYIeuXmDwmGVikl8lAjcCnAg3M=;
        b=sizy09Rf83mvjDTJdoBJDZNNTk8tLslV548XqhozRjRWvFbszJFTI+j7bIg/l1afBc
         crsxk9I0ooUNRKTcpKOoa5GXpUVjmN2vdV4Id9PZ/ViVIFfLixLjQ+krIZLSLDIeIV0U
         HDqyIPRBSv/pC4/S/jHDWZVc1iKpU98kYUuog2JG4F2+3fI1WBHbmh2brjkP+jhg4t2U
         baZ2lv9qA3EcB+TS91fQ7LNsCCjaDb+WR2j97/vX0rINngKu3GxI58QSLh7CHMmtluGL
         k41SPrJ4CJUZ6PRByBSGGdA0gCEiav1RhjcGeezcn7HfO5Df/J1odtFYEuE7sfqMAFQg
         dwWw==
X-Gm-Message-State: AGi0PubYBEsv1jmpZIeVXbqLiDitsBI1Fs+zthfueK5qABtA8CFSDCmi
        IBMyXFevgFOaj8dmMoEf4YE=
X-Google-Smtp-Source: APiQypIOBQQvb07aoIwF01JDPRVLY0HPZcgTlP+jHS1GgvTHM/U7T7ZT4Ttz4tuiWHQslXH4DBSDWQ==
X-Received: by 2002:a19:c102:: with SMTP id r2mr8657285lff.170.1585585073402;
        Mon, 30 Mar 2020 09:17:53 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id u7sm447957lfb.84.2020.03.30.09.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:17:52 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] Have "stop" button for multi-threaded searches
Date:   Mon, 30 Mar 2020 19:17:20 +0300
Message-Id: <20200330161723.29816-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far "stop" button was available only during the single-threaded
searches. In order to make the multi-threaded searches stoppable
and restartable we are changing the searching mechanism making all
searching threads to progress in the data in parallel.

Yordan Karadzhov (VMware) (3):
  kernel-shark: Simplify the search methods in class KsTraceViewer
  kernel-shark: Change the mechanism of the multi-threaded search
  kernel-shark: Make the "stop search" button always visible

 kernel-shark/src/KsModels.cpp      |  89 ++++++++++++------
 kernel-shark/src/KsModels.hpp      |  16 ++--
 kernel-shark/src/KsSearchFSM.cpp   |  11 ++-
 kernel-shark/src/KsSearchFSM.hpp   |   5 +-
 kernel-shark/src/KsTraceViewer.cpp | 141 +++++++++++++++++++++++------
 kernel-shark/src/KsTraceViewer.hpp |   5 +-
 6 files changed, 195 insertions(+), 72 deletions(-)

-- 
2.20.1


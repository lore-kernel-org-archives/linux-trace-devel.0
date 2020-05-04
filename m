Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C606C4724C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 17:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE5D206A4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 17:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jZ885hNi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730100AbgEDRoH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 13:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDRoH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 13:44:07 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B06EC061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 May 2020 10:44:07 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 188so10517677lfa.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 May 2020 10:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JPIK2mCq4XtX5M/DDvSoOtaduzDEw53miyv8JKapJAY=;
        b=jZ885hNi2fXKQyWZWtgdRgFBS7KU56xEgA6EGE13GV5/I7OSR0JTpCpObmQaxHrAWH
         Zlo2M7mNof4MIhyDSQpq6o/tbFX1dOXZmUsX3SmxmNavwNtLublT16IAuXFhsJpFLL43
         y3axhxcft6I6w+mccwtsFDcuf5fGdRM/14jXNmx2mdWwyMrirCq4WlMqan3yJ0cv3aJ/
         buaK31CMKxbNnYcLBvEDvV4v5nqJQFFpEqw+0U4FDlwSf1AKe60IBsGPBy6626DQ+Irl
         jloNOAooYewkWx7R/OZ6WwYTVOAcygla5AWbSFHH2P9Owdkk9yXkgjzEld8TrB9aTWU7
         0cCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JPIK2mCq4XtX5M/DDvSoOtaduzDEw53miyv8JKapJAY=;
        b=qXXp3pumLgS23/w2dMvDvZVFkk2e0Qb7Z3S9Ong3Bvpi9NiKVxT1G+dCqXWxSx4/Jy
         WylOH+ZUTm5S10HlF1g/rbTCatHL5Tc0nSK8GQGT9d85hnlykupP3x0bJFIIBBOAIQGj
         TJMe5oVe04ZM/4cLHUiOFrwysANMGPlT8dZe67a8FYMG8TfWRjChdcQsYIbfp5sfNiVp
         2r7IYobX6+XPTOE08LDdCSb841ZoupTospcaskzEl84dCHNVhrr6/o6M34CbOYMbMiy6
         IGSGMX/+EmvB21aM8sTK/ZFSghy88HxAMR+G0MjNFo3VOZPnsd7dmka8YYzwA3eRlXDy
         6nPA==
X-Gm-Message-State: AGi0PuaGTKdQG4w/Kic+jh0vpGYeVM11vGApBP7prIHub3gAxM4PV+dg
        tY3YZVWm7Nfn9yBjs1NrYbw=
X-Google-Smtp-Source: APiQypLb76k4WGVztEtksU8pfe54QvPmeN5PPLxljZ9N76aYTjMNr362H8itKI1VfHdFD0mDV3Gpyw==
X-Received: by 2002:ac2:47fb:: with SMTP id b27mr11289046lfp.10.1588614245551;
        Mon, 04 May 2020 10:44:05 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id g10sm10260845lfc.95.2020.05.04.10.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:44:05 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/3] kernel-shark: Make the "stop search" button always visible
Date:   Mon,  4 May 2020 20:43:42 +0300
Message-Id: <20200504174342.24615-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504174342.24615-1-y.karadz@gmail.com>
References: <20200504174342.24615-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far the button was showing up only when we do a single-threaded
search in the data. Stopping the multi-threaded searches became
possible after the modification of the parallel search introduced
in the previous commit. When the multi-threaded search is restarted
(after being stopped) the label showing the number of matches found
is reset to show nothing. It will show the count again when the
search finishes or is stopped.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsSearchFSM.cpp | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel-shark/src/KsSearchFSM.cpp b/kernel-shark/src/KsSearchFSM.cpp
index 4f01cc8..6a93ca7 100644
--- a/kernel-shark/src/KsSearchFSM.cpp
+++ b/kernel-shark/src/KsSearchFSM.cpp
@@ -142,11 +142,7 @@ void NotDone::handleInput(KsSearchFSM* sm, sm_input_t input)
 		sm->lockSearchPanel();
 		sm->updateCondition();
 		sm->progressBarVisible(true);
-
-		if (sm->column() == KsViewModel::TRACE_VIEW_COL_INFO ||
-		    sm->column() == KsViewModel::TRACE_VIEW_COL_LAT)
-			sm->searchStopVisible(true);
-
+		sm->searchStopVisible(true);
 		sm->changeState(std::shared_ptr<InProgress>(new InProgress));
 		break;
 
@@ -168,6 +164,11 @@ void Paused::handleInput(KsSearchFSM* sm, sm_input_t input)
 		sm->lockSearchPanel();
 		sm->searchStopVisible(true);
 		sm->searchRestartVisible(false);
+
+		if (sm->column() != KsViewModel::TRACE_VIEW_COL_INFO &&
+		    sm->column() != KsViewModel::TRACE_VIEW_COL_LAT)
+			sm->_searchCountLabel.setText("");
+
 		sm->changeState(std::shared_ptr<InProgress>(new InProgress));
 		break;
 
-- 
2.20.1


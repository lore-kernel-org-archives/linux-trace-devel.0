Return-Path: <SRS0=+PQ5=VM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF13BC76191
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF1F0206B8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q+YjJRFz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfGONVY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:21:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51867 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730111AbfGONVY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 09:21:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so15167897wma.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jul 2019 06:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xL/50sP+0yqBwtM2a/folq4pA8V482HHff9A2bu6yYU=;
        b=Q+YjJRFzEkuq21qL3fY3fBr1OmO1ToAFk6xKhqYCRKdYVJtAlmkI8Kqyo7p47rdKPm
         AREvOgYmk/WRPfzsgQXxy27L+5a7r3jZ4dJqaBakhFNUT1VnmG0HjPD2huJhB0VSNbpp
         JqOWvifadCiUlc8Gx13TYXc8sYW2tD/w5Xj1vuD3ctr4yrC26UM15G4LCYInbY63adKG
         rCe5lHNjOyHRhBcvJS4Jm/rfx4eWn9pZR9Ri+qgnU5K4JiqxgjVZpdSmcf6Fup/LhGk2
         aCO5gLXzXF13+61RGx+7oJPHnvp1RT0TAETf+UHQOwIPy9RM1OnCriuYcAKs5K1t4Iu4
         mlFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xL/50sP+0yqBwtM2a/folq4pA8V482HHff9A2bu6yYU=;
        b=fGsg38IldcGIIUHVnBp4pFsfm+oTqClff+Es5S3uWjNPYI19/CxiyJ50m8lR6mqjny
         CQMZ/NIlp8bpguXQ2T1TOlyg3mcAVV5eY+u+EaKwDwNWJP5CLIdWU4wRuBzyIgZGSt5t
         /FX20Gi98ic+U9BXJIvKUotrcN1MCieHaU5uNyHath0hWLPTHlwFGF9b1ApXKFks3mj8
         gVNQt+9+fJeuz1ZrGVEtQeKb0FbOZcMrIkwWt4fFjxz2dj3ZVhq1jmn5Q+d/vmcN5KHD
         vZWLl7w5VRb4k/0gwg2+PiLeKZDUkFhh42URVyiMak214dPczs6LJ3ADOy00f6368yjM
         okiA==
X-Gm-Message-State: APjAAAVu+zET0lLvot8IuVcxnTU31mc5eMpG1tgncGgyAfbPeVyq3P1x
        3U+1vuedVxwfyQn5lBenyII=
X-Google-Smtp-Source: APXvYqzlwPXwYzzsZOSZhn4dQ0G54UlpMvtsj8hJI11L6PFFL/dacQYb19jV9BwUR9Z5vL0usPQzDA==
X-Received: by 2002:a05:600c:2243:: with SMTP id a3mr23877313wmm.83.1563196882542;
        Mon, 15 Jul 2019 06:21:22 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c78sm23819426wmd.16.2019.07.15.06.21.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 06:21:22 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH 1/3] kernel-shark: The graph widget must follow the active marker
Date:   Mon, 15 Jul 2019 16:20:40 +0300
Message-Id: <20190715132042.5154-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715132042.5154-1-y.karadz@gmail.com>
References: <20190715132042.5154-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "Graph follows" checkbox controls if the Graph widget follows or not
the change of the Active marker made from the View widget (the text data
table).
In the same time, when the user clicks on the checkbox switching it from
Unchecked to Checked, a signal is send to the Graph widget to make sure
that it will visualize the current position of the Active marker. When
sending this signal, we currently use the iterator of the search results
list, which is wrong because of two reasons. First, the  search results
list can be empty, which will trigger a segmentation fault, as reported
by Valentin Schneider. But even more important is that nothing guarantees
that when the checkbox is clacked, the marker and the iterator both point
to the same trace entry. Note that the iteration over the search results
is only one of the possible ways to change the marker.

Reported-By: Valentin Schneider <valentin.schneider@arm.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204139
Tested-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsTraceViewer.cpp | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 05977c3..89e5dba 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -285,10 +285,11 @@ void KsTraceViewer::_searchEditText(const QString &text)
 
 void KsTraceViewer::_graphFollowsChanged(int state)
 {
-	_graphFollows = (bool) state;
+	int row = selectedRow();
 
-	if (_graphFollows && _searchDone())
-		emit select(*_it); // Send a signal to the Graph widget.
+	_graphFollows = (bool) state;
+	if (_graphFollows && row != KS_NO_ROW_SELECTED)
+		emit select(row); // Send a signal to the Graph widget.
 }
 
 void KsTraceViewer::_search()
-- 
2.20.1


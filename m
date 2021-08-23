Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C172DC4338F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 20:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F9E7613A8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 20:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhHWUsC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 16:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232237AbhHWUsA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 16:48:00 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CF2C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 13:47:17 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id v6so5192238qto.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 13:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBpOnz8UcXYVoFmPtMypT/cBX8WKZCZ1xL8UFieBWOQ=;
        b=efYLF5g+Jg+4nJXo67XsRlZDKwa0zGyd8axsKtN6hhRom1rZ7w8OmoFyqOPUlC6qcJ
         jUExsvosFr6WErzSkLnyaxSK1Dy/5z54Vn26FnpgQXWzoWP1pGimFT3uS/Gv6HY81eVr
         MIYJABaebE0Z5F+OZrqQaB7Pk9OeUpcWalrr5BfBXOhhJLiuv4GJnTEXMOY7rDBAulIC
         XsYDgHtG3eZJaH3RKCYspweRFoq5KZguIg7efSVzHd9/PMs1P8UQEfDLYgAOXHSvHfdk
         BXvDedyOVKlYq6iNNB5XerjHzAlEyeDVtyh8WmTzOeanJjTLnEqAhPXrwJzDZcAy0waH
         wdLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MBpOnz8UcXYVoFmPtMypT/cBX8WKZCZ1xL8UFieBWOQ=;
        b=tPGf7TE1daakdNkKuWLtgDpqkKDF3h65L7mY0nU2ZlJw7whOWC98kVD1yhMJVWYTBK
         +OQXYWiCYkRI+20yQxEOtmOK7I1HcflZLKpOjIJRTTPt5F1TWfeoH6y0R8pben4a3JD8
         MrQh0PqJqaqpgdZjz0gTi6LoaReTBSkQH5Czi0CYYDBSwUEvLaVAGvaAr5e9kJn733cs
         unBeBF1RxfPvUVY5d6ooo/6vVNNOMsBrFLPShrmdEJHH+Dogb24miMcNTsFgB8Ka5JIr
         qIAYQ1KrgrDWQlEhWSIjE1uSVy9r6W2ZAJPAoFwv+Bpk7/i5/0S9+jiAmJ6D6CsPpalJ
         NGtg==
X-Gm-Message-State: AOAM531yh9wEfZxUZwAIWvwoW5fPGTDELO1YHr1JUFKfX0hojjb778+W
        2Eq4OBpd2B5lmZyf+yH0Vez/WKjyncgJFw==
X-Google-Smtp-Source: ABdhPJx4yeQMHWpIiwqkq37JM2G2r2BrbU+IdF55x/Yh3qZ0T+8TJa0qPzgKKbG9D9A8MCVu90W3yQ==
X-Received: by 2002:ac8:5805:: with SMTP id g5mr12865733qtg.360.1629751636355;
        Mon, 23 Aug 2021 13:47:16 -0700 (PDT)
Received: from localhost.localdomain ([185.153.176.246])
        by smtp.gmail.com with ESMTPSA id g20sm9109505qki.73.2021.08.23.13.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 13:47:15 -0700 (PDT)
From:   Victor Cora Colombo <victorcora98@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Victor Cora Colombo <victorcora98@gmail.com>
Subject: [PATCH v3] trace-cmd: Add dependencies to BUILDING section in README
Date:   Mon, 23 Aug 2021 17:45:43 -0300
Message-Id: <20210823204543.1327-1-victorcora98@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KernelShark has instructions in its README on how to get necessary
dependencies to build it. trace-cmd could follow this example and
also add more information on how to build it.

This patch adds instructions to README on how to get necessary libraries
and dependencies to build trace-cmd.

Signed-off-by: Victor Cora Colombo <victorcora98@gmail.com>
---
 README | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/README b/README
index 1153152..9a3533d 100644
--- a/README
+++ b/README
@@ -24,6 +24,27 @@ Lesser General Public License 2.1 (See COPYING.LIB).
 
 BUILDING:
 
+In order to install build dependencies on Debian / Ubuntu do the following:
+    sudo apt-get install build-essential git pkg-config -y
+    sudo apt-get install libtracefs-dev libtraceevent-dev -y
+
+In order to install build dependencies on Fedora, as root do the following:
+    dnf install gcc make git pkg-config -y
+    dnf install libtracefs-devel libtraceevent-devel -y
+
+In case your distribution does not have the required libtracefs and
+libtraceevent libraries, build and install them manually:
+
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/
+    cd libtraceevent
+    make
+    sudo make install
+
+    git clone https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
+    cd libtracefs
+    make
+    sudo make install
+
 To make trace-cmd
     make
 
-- 
2.33.0


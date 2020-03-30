Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C443C2D0EE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11298206CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nny3zfMw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgC3QSK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:18:10 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43625 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbgC3QSK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:18:10 -0400
Received: by mail-lf1-f66.google.com with SMTP id n20so14664932lfl.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JPIK2mCq4XtX5M/DDvSoOtaduzDEw53miyv8JKapJAY=;
        b=Nny3zfMwCegmrMPqqXsShKhBlOvshJd0HcBWf8lUFS+5LUF5VDBZzSNAzeUgqu1cHy
         ahR0J+q0cDJsA8aDw1bYhWbfNMmzbD/quDO+b4M+Pu5fqYH3BNrHZTfZ6SeRjpXZa72/
         KpWC+MK73qlmNtY82O8g9QhMAT97Mogsdc5wOzNXw35G3JPcC2yVh6MIQG68nhpgDuGQ
         GuTnDVlaHIArBG2aDf/m8m9XAVU0Y+UEnX7etxBawMZhXWK25GJ2ohe1KS46y2QmxjIo
         RC38tvX4Qo5yhFOOeIDz8l1iSTV8sDgHUUO0fVM9/8HW3jttPwuTke4Rp8hzPSDAvS/2
         JL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JPIK2mCq4XtX5M/DDvSoOtaduzDEw53miyv8JKapJAY=;
        b=QpKIznqvIDM9wx6EHhjqVNsjl12itkJ909N2CpPsKiRUTD3ky2JAqMwgpPYbfF5QyW
         fFE+UD73TsKSsU8pBdHsLmU6OQDnJKR0Qt3ewaguk7+9Ntj7tfkUjSDvMoqibXEagj5L
         ToZ6/CGZiIfY7+shpBT7sUy29iBo9lutgL2ZqUqMPJGOCYLTB6XInUHp7eoWi7V8JijC
         78Hiy9hrpYt0ZgVbthK1fnjttAp2FOEn+RhpovZmrSo2oHYC21yy3p9uSEN5Ev1h9qks
         +9nqjwGYmRi9Iqg1xXq/xG/6q8PqmhCqVcEqDCb6sRFcUkcxwzeahuY75HCiFqzd7PRo
         cKHQ==
X-Gm-Message-State: AGi0PuYVQO5RqEtW1j4Y/iG/QWtPBaHP4SnebBrIUY8mHDfuWXkFMHUr
        Q+x31vMZwLuFjtjVDNMK7ss=
X-Google-Smtp-Source: APiQypJYNG3IF7Dl9XUc27B5OUuZ4GZXlUpV6a5IMxH9LcFF4xlcvnPfM/u8E/rJ3Kf5ZhWHSBo4Xg==
X-Received: by 2002:a19:434f:: with SMTP id m15mr5423246lfj.3.1585585088183;
        Mon, 30 Mar 2020 09:18:08 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id u7sm447957lfb.84.2020.03.30.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:18:07 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Make the "stop search" button always visible
Date:   Mon, 30 Mar 2020 19:17:23 +0300
Message-Id: <20200330161723.29816-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330161723.29816-1-y.karadz@gmail.com>
References: <20200330161723.29816-1-y.karadz@gmail.com>
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


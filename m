Return-Path: <SRS0=DxZ9=RI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69DA4C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33D7920848
	for <linux-trace-devel@archiver.kernel.org>; Tue,  5 Mar 2019 14:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbfCEOjt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 09:39:49 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40770 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbfCEOjs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 09:39:48 -0500
Received: by mail-wm1-f65.google.com with SMTP id g20so2758486wmh.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 05 Mar 2019 06:39:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pXEdXHmawmG3QA6v4cL+jeAse3wn/D8hhPSj1R68cDg=;
        b=hcBr6gkkArj3KOLSf4WpX+HW9GJKX5wicWT5qybTHBSR6SGOUV9mwdH2QgWqOwgp9+
         MZTj7sTnkqlgJXA5U5KcAHUWU6QEVaezW60H+ykjBv0vtpYOgp2J2hOW2c0rCQnTS8zS
         9h7ErqUbwCRDArFedH5jva7XwDvle3tQoyYfFXirzt4XEJqq1hUvko9kiDJST2JucugW
         uZ/m1QxbuZIplsIeVDeKMulfi6PczNtYr+I1RM4vgHuYGYEr88EepPOhCp8Q/z+t/EHi
         FAbmSOhqPXnn5gUGxi5mXYwwux521esQSWQ+h72aGcNojydAHitZlnISBM94h3R5jd0/
         aDZg==
X-Gm-Message-State: APjAAAV7KxxNydSMX+aVRcapHX075QKkJT3xZzoNa8xe/UEnLJIAGdCC
        dK+it5PoZuZH92a3NxkWFtSb2cof
X-Google-Smtp-Source: APXvYqw3Ugfmgdw2yYoniaXdabrzXbaxSQVzbTVjBmXYM4OEyGjdtFfw0ii4RoREIa/jEpvZcoWbIA==
X-Received: by 2002:a1c:8086:: with SMTP id b128mr3139712wmd.117.1551796787022;
        Tue, 05 Mar 2019 06:39:47 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o12sm31908915wre.0.2019.03.05.06.39.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Mar 2019 06:39:46 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/3] Improvements and fixes for sched_switch plugin
Date:   Tue,  5 Mar 2019 16:39:21 +0200
Message-Id: <20190305143924.11056-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Yordan Karadzhov (3):
  kernel-shark: Define free_contex function for the sched_events plugin
  kernel-shark: Fix a memory leak in the sched_events plugin
  kernel-shark: sched_events plugin init with sched_switch events only

 kernel-shark/src/plugins/sched_events.c | 30 +++++++++++++++----------
 1 file changed, 18 insertions(+), 12 deletions(-)

-- 
2.19.1


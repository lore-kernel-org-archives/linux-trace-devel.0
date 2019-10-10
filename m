Return-Path: <SRS0=o8EP=YD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF4A6C4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89749206B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:24:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n9ig8Twb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfJJVY5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:24:57 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41174 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 17:24:57 -0400
Received: by mail-lj1-f196.google.com with SMTP id f5so7699555ljg.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2019 14:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3cecunE8LfiC2psFh4s1384O2enkWgDcErKitnMnn6o=;
        b=n9ig8Twb7X7mfum1qYwxZnn9El9ovUnmyUxJDJV9dW86++YlsP+6Bl7cTPgZbOe3IG
         KGRsk2usRq9QqAln+i4CRc/8u3671MzSawkH6XYB7lmaIRKOOzGdBaeMeqTw3Szx9/S3
         39BVfexbChqc38RHkq7kN8Gl1y1S4DL21lz9NemL59PbgRcE3WJuRxiEA5rn1fHjyOxj
         0lwlQ5IVz8K/i288/xdFAdpxljmJLLBhGib8vUUsejE+FZyYnCuNjKOtNB6h8iFglXf4
         LAy8uVfMUcNaFbRX7WA5SzxgV/WJTuZikjTU0wEBWjOECt39iq+7bpfw27QZdZNf6Ybo
         akNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3cecunE8LfiC2psFh4s1384O2enkWgDcErKitnMnn6o=;
        b=J6gWUayc3M9yG83ZgOknFf8dJ+jAmAIWoP6nLu2oo5w1ITX7GoJa4ANqCZVCcIEPNG
         jUb+w1sthgeyrp6n63nIgfH9f2G8Qr7QmpkLXAx9sCcY7e1WjzxoPWEfrxa3ums0FHYI
         wLaKtREPH4JqcWvdrIA7WK6gD6u+imqK132CzoAUh0z4ZbhJARgZjEpZjbdApkg03OQh
         IIddMM/5FPqnIOzmsQouch8FaZsvt0Ax4LQ1kGGafY8CvLYn+dbGSrSCc39wkVm0+Exl
         KYBo0OkTV+CZDTFgH4CUOk9QdI6lc7Hd1aAOic73kau+bU87/CRN4vijoP770xGTC4FD
         ju9Q==
X-Gm-Message-State: APjAAAXxvccDqlX3Iy1pg0v0XGYsUvyfd3atU9TWxeF+wA+fGqzqp6UY
        gWMq77Y3dYq/3/QScHr+dSAXMkCKq5A=
X-Google-Smtp-Source: APXvYqx0lckkwH8sFNKpn+O1Lm/bM1zMN7TFhTtsYwtDStp8XpWlsXEVlMn322obZgBpe7gHoUl0Gw==
X-Received: by 2002:a2e:83d6:: with SMTP id s22mr7310137ljh.95.1570742694878;
        Thu, 10 Oct 2019 14:24:54 -0700 (PDT)
Received: from localhost (128-72-185-159.broadband.corbina.ru. [128.72.185.159])
        by smtp.gmail.com with ESMTPSA id g10sm1576013lfb.76.2019.10.10.14.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 14:24:54 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <srostedt@redhat.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Subject: [PATCH 1/4] kernel-shark: Set text color to black in KsDualMarker's QLabels
Date:   Fri, 11 Oct 2019 00:24:26 +0300
Message-Id: <20191010212429.469155-2-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010212429.469155-1-mike.rudenko@gmail.com>
References: <20191010212429.469155-1-mike.rudenko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

At present, background color of marker position QLabels is forced to
white with a stylesheet, but the text color stays unchanged. As a
result, the text is barely visible when using dark color schemes. This
patch forces the text color to black for these QLabels, making it
readable on all color schemes.

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
---
 kernel-shark/src/KsDualMarker.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsDualMarker.cpp b/kernel-shark/src/KsDualMarker.cpp
index 755e246..0070777 100644
--- a/kernel-shark/src/KsDualMarker.cpp
+++ b/kernel-shark/src/KsDualMarker.cpp
@@ -156,7 +156,7 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)

 	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
 		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
-		l->setStyleSheet("QLabel {background-color : white;}");
+		l->setStyleSheet("QLabel {background-color : white; color : black}");
 		l->setTextInteractionFlags(Qt::TextSelectableByMouse);
 		l->setFixedWidth(FONT_WIDTH * 16);
 	}
--
2.23.0
